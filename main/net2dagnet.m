function dagnn_net = net2dagnet(net)
% % ------------------------------------------------------------------------------------------
% % For testing this function
% clc; clear; close all;
%--------------------------------------------------------------------------------------------------------
%% download a pre-trained CNN from the web (needed once)
% urlwrite(...
%   'http://www.vlfeat.org/matconvnet/models/imagenet-googlenet-dag.mat', ...
%   '../data/imagenet-googlenet-dag.mat') ; 

%% change it into dagnn mode
% gnet = load('../data/imagenet-googlenet-dag.mat') ; % load the pre-trained CNN
% glayers = gnet.layers;
% for ii = 1 : numel(glayers)
%     fprintf('--%d-th layer: %s\n', ii, glayers(ii).type) ;
% end 
% net = dagnn.DagNN.loadobj( gnet ) ; 

%% transfer vgg-m to dagnn-vgg-m
% mnet = load('../data/models/imagenet-vgg-m.mat') ; 

%% ----------------------------------------------------------------------------------------------
% main 
dagnn_net = struct('vars', [], 'params', [], 'layers', [], 'meta', []) ;

% meta
dagnn_net.meta.classes = net.classes ;
dagnn_net.meta.normalization = net.normalization ;

% layers
layers = net.layers ;
this_layer_inputs = 'data' ; % init. this_layer_inputs
ii = 0 ; 
dagnn_net.vars(ii+1).name = this_layer_inputs ; % vars.name
dagnn_net.vars(ii+1).precious = 0 ; % vars.precious
idx = 0 ;
for ii = 1 : numel(layers)
    layer_name =  layers{ii}.name ;
    dagnn_net.layers(ii).name = layer_name ;
    
    dagnn_net.vars(ii+1).name = layer_name ; % vars.name & vars.precious
    dagnn_net.vars(ii+1).precious = 0 ;

    % type & block & params
    layer_type = layers{ii}.type ;
    switch layer_type
        case 'conv'
            dagnn_net.layers(ii).type = 'dagnn.Conv' ;
            dagnn_net.layers(ii).block.size = size(layers{ii}.filters) ;
            if ~isempty(layers{ii}.biases) ; dagnn_net.layers(ii).block.hasBias = true ; end 
            dagnn_net.layers(ii).block.pad = layers{ii}.pad ;
            dagnn_net.layers(ii).block.stride = layers{ii}.stride ;
            dagnn_net.layers(ii).block.opts = {'cuDNN'} ;
            params_name = {['conv', num2str(ii), 'f'], ['conv', num2str(ii), 'b']};
            dagnn_net.layers(ii).params = params_name ;
            
            idx = idx + 2 ; 
            eval( ['dagnn_net.params(', num2str(idx-1), ').name = params_name{1};' ] ) ;
            eval( ['dagnn_net.params(', num2str(idx-1), ').value = layers{ii}.filters ;'] ) ;
            eval( ['dagnn_net.params(', num2str(idx-1), ').learningRate = 1 ;' ] ) ;
            eval( ['dagnn_net.params(', num2str(idx-1), ').weightDecay = 1 ;' ] ) ;
            eval( ['dagnn_net.params(', num2str(idx), ').name = params_name{2} ;' ] ) ;
            eval( ['dagnn_net.params(', num2str(idx), ').value = layers{ii}.biases ;'] ) ;
            eval( ['dagnn_net.params(', num2str(idx), ').learningRate = 1 ;' ] ) ;
            eval( ['dagnn_net.params(', num2str(idx), ').weightDecay = 1 ;' ] ) ;
        case 'relu'
            dagnn_net.layers(ii).type = 'dagnn.ReLU' ;
            dagnn_net.layers(ii).block.useShortCircuit = true ;
            dagnn_net.layers(ii).block.leak = 0 ;
            dagnn_net.layers(ii).block.opts = {};
            dagnn_net.layers(ii).params = {} ;
        case 'normalize'
            dagnn_net.layers(ii).type = 'dagnn.LRN' ;
            dagnn_net.layers(ii).block.param = layers{ii}.param ;
            dagnn_net.layers(ii).params = {} ;
        case 'pool'
            dagnn_net.layers(ii).type = 'dagnn.Pooling' ;
            dagnn_net.layers(ii).block.method = layers{ii}.method ;
            dagnn_net.layers(ii).block.poolSize = layers{ii}.pool ;
            dagnn_net.layers(ii).block.pad = layers{ii}.pad ;
            dagnn_net.layers(ii).block.stride = layers{ii}.stride ;
            dagnn_net.layers(ii).block.opts = {'cuDNN'} ;
            dagnn_net.layers(ii).params = {} ;
        case 'softmaxloss'
            dagnn_net.layers(ii).type = 'dagnn.SoftMax' ;
            dagnn_net.layers(ii).block = struct() ;
            dagnn_net.layers(ii).params = {} ;
        otherwise
            fprintf('==>NOTE: no such dagnn_layer for layer-%s.\n', layers{ii}.type) ;
    end
    
    % inputs & outputs
    this_layer_outputs = layer_name ; % last_layer_outputs == this_layer_inputs
    dagnn_net.layers(ii).inputs = this_layer_inputs ;
    dagnn_net.layers(ii).outputs = this_layer_outputs ;
    this_layer_inputs = this_layer_outputs ;
end