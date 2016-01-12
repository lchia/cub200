function imdb_cnn_train(imdb, opts, varargin)
% Train a CNN model on a dataset supplied by imdb

opts.lite = false ;
opts.numFetchThreads = 0 ;
opts.train.batchSize = opts.batchSize ;
opts.train.numEpochs = 25 ;
opts.train.continue = true ;
opts.train.gpus = 1 ;
opts.train.prefetch = false ;
opts.train.learningRate = [0.001*ones(1, 10) 0.0001*ones(1, 10) 0.00001*ones(1,10)] ;
opts.train.expDir = opts.expDir ;
opts = vl_argparse(opts, varargin) ;

% -------------------------------------------------------------------------
%                                                    Network initialization
% -------------------------------------------------------------------------

net = initializeNetwork(imdb, opts) ;

% Fill in defaul values
net = vl_simplenn_tidy(net) ;
 
% optionally switch to batch normalization
if opts.useBatchNorm
    convID = [] ;
    for ii = 1 : numel(net.layers)
        if strcmp(net.layers{ii}.type, 'conv')
            convID = [convID, ii];
        end
    end
    
    for ii = 1 : numel(convID)
        net = insertBnorm( net, convID(ii) + (ii-1) ) ;
    end
end
   
% Fill in defaul values
net = vl_simplenn_tidy(net) ;

% Initialize average image
opts_train_computeMean = true ;
if (opts_train_computeMean)
    % compute the average image
    averageImagePath = fullfile(opts.expDir, 'average.mat') ;
    if exist(averageImagePath, 'file')
      load(averageImagePath, 'averageImage') ;
    else
      train = find(imdb.images.set == 1) ;
      fprintf('==>Compute train-mean: ');
      batch_time = tic ;
      trainNum = numel(train) ;
      
      imageSize = net.meta.normalization.imageSize ;
      im_train = zeros( [imageSize, trainNum] ) ;
      t_ratio = 0;%for showing
      for ii = 1 : trainNum
          if ( mod(ii, floor(trainNum/10)) == 0 )
              t_ratio = t_ratio + 1;
              fprintf(' %d/10, ', t_ratio);
          end
          imgPath = fullfile(imdb.imageDir, imdb.images.name{train(ii)});
          img = imread(imgPath);
          if size(img,3) == 1 ; img = repmat(img, [1,1,3]) ; end %gray2rgb
          im_train(:, :, :, ii) = imresize(img, imageSize([1,2])) ;
      end
      fprintf(' using %f seconds.\n', toc(batch_time));
      averageImage = mean(cat(4, im_train),4) ;
      save(averageImagePath, 'averageImage') ;
    end

    net.meta.normalization.averageImage = averageImage ;
    clear averageImage im temp ;
end

% -------------------------------------------------------------------------
%                                               Stochastic gradient descent
% -------------------------------------------------------------------------
fn = getBatchWrapper(net.meta.normalization, opts.numFetchThreads) ;
[net,info] = cnn_train(net, imdb, fn, opts.train, 'conserveMemory', true) ;

% Save model
net = vl_simplenn_move(net, 'cpu');
saveNetwork(fullfile(opts.expDir, 'final-model.mat'), net);

% -------------------------------------------------------------------------
function saveNetwork(fileName, net)
% -------------------------------------------------------------------------
layers = net.layers;

% Replace the last layer with softmax
layers{end}.type = 'softmax';
layers{end}.name = 'prob';

% Remove fields corresponding to training parameters
ignoreFields = {'filtersMomentum', ...
                'biasesMomentum',...
                'filtersLearningRate',...
                'biasesLearningRate',...
                'filtersWeightDecay',...
                'biasesWeightDecay',...
                'class'};
for i = 1:length(layers),
    layers{i} = rmfield(layers{i}, ignoreFields(isfield(layers{i}, ignoreFields)));
end
classes = net.meta.classes;
normalization = net.meta.normalization;
save(fileName, 'layers', 'classes', 'normalization');


% -------------------------------------------------------------------------
function fn = getBatchWrapper(opts, numThreads)
% -------------------------------------------------------------------------
fn = @(imdb,batch) getBatch(imdb,batch,opts,numThreads) ;

% -------------------------------------------------------------------------
function [im,labels] = getBatch(imdb, batch, opts, numThreads)
% -------------------------------------------------------------------------
images = strcat([imdb.imageDir '/'], imdb.images.name(batch)) ;
im = imdb_get_batch(images, opts, ...
                            'numThreads', numThreads, ...
                            'prefetch', nargout == 0);
labels = imdb.images.label(batch) ;

% -------------------------------------------------------------------------
function net = initializeNetwork(imdb, opts)
% -------------------------------------------------------------------------
scal = 1 ;
init_bias = 0.1;
numClass = length(imdb.classes.name);
if ~isempty(opts.model)
    net = load(fullfile(opts.model)); % Load model if specified
    net.normalization.keepAspect = opts.keepAspect;
    fprintf('Initializing from model: %s\n', opts.model);

    % Replace the last but one layer with random weights
    net.layers{end-1} = struct('type', 'conv', ...
                           'filters', 0.01/scal * randn(1,1,4096,numClass,'single'), ...
                           'biases', zeros(1, numClass, 'single'), ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'filtersLearningRate', 10, ...
                           'biasesLearningRate', 20, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0);
                       
    % Last layer is softmaxloss (switch to softmax for prediction)
    net.layers{end} = struct('type', 'softmaxloss') ;

    % Rename classes
    net.classes.name = imdb.classes.name;
    net.classes.description = imdb.classes.name;
     
    % TODO: add dropout layers if initializing from previous models
    return;
end

% Else initial model randomly
net.layers = {} ;

% Block 1
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', 0.01/scal * randn(11, 11, 3, 96, 'single'), ...
                           'biases', zeros(1, 96, 'single'), ...
                           'stride', 4, ...
                           'pad', 0, ...
                           'filtersLearningRate', 1, ...
                           'biasesLearningRate', 2, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [3 3], ...
                           'stride', 2, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'normalize', ...
                           'param', [5 1 0.0001/5 0.75]) ;

% Block 2
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', 0.01/scal * randn(5, 5, 48, 256, 'single'), ...
                           'biases', init_bias*ones(1, 256, 'single'), ...
                           'stride', 1, ...
                           'pad', 2, ...
                           'filtersLearningRate', 1, ...
                           'biasesLearningRate', 2, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [3 3], ...
                           'stride', 2, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'normalize', ...
                           'param', [5 1 0.0001/5 0.75]) ;

% Block 3
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', 0.01/scal * randn(3,3,256,384,'single'), ...
                           'biases', init_bias*ones(1,384,'single'), ...
                           'stride', 1, ...
                           'pad', 1, ...
                           'filtersLearningRate', 1, ...
                           'biasesLearningRate', 2, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0) ;
net.layers{end+1} = struct('type', 'relu') ;

% Block 4
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', 0.01/scal * randn(3,3,192,384,'single'), ...
                           'biases', init_bias*ones(1,384,'single'), ...
                           'stride', 1, ...
                           'pad', 1, ...
                           'filtersLearningRate', 1, ...
                           'biasesLearningRate', 2, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0) ;
net.layers{end+1} = struct('type', 'relu') ;

% Block 5
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', 0.01/scal * randn(3,3,192,256,'single'), ...
                           'biases', init_bias*ones(1,256,'single'), ...
                           'stride', 1, ...
                           'pad', 1, ...
                           'filtersLearningRate', 1, ...
                           'biasesLearningRate', 2, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [3 3], ...
                           'stride', 2, ...
                           'pad', 0) ;

% Block 6
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', 0.01/scal * randn(6,6,256,4096,'single'),...
                           'biases', init_bias*ones(1,4096,'single'), ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'filtersLearningRate', 1, ...
                           'biasesLearningRate', 2, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'dropout', ...
                           'rate', 0.5) ;

% Block 7
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', 0.01/scal * randn(1,1,4096,4096,'single'),...
                           'biases', init_bias*ones(1,4096,'single'), ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'filtersLearningRate', 1, ...
                           'biasesLearningRate', 2, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'dropout', ...
                           'rate', 0.5) ;

% Block 8
net.layers{end+1} = struct('type', 'conv', ...
                           'filters', 0.01/scal * randn(1,1,4096,numClass,'single'), ...
                           'biases', zeros(1, numClass, 'single'), ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'filtersLearningRate', 1, ...
                           'biasesLearningRate', 2, ...
                           'filtersWeightDecay', 1, ...
                           'biasesWeightDecay', 0) ;

% Block 9
net.layers{end+1} = struct('type', 'softmaxloss') ;

% Other details
net.meta.normalization.imageSize = [227, 227, 3] ;
net.meta.normalization.interpolation = 'bicubic' ;
net.meta.normalization.border = 256 - net.meta.normalization.imageSize(1:2) ;
net.meta.normalization.averageImage = [] ;
net.meta.normalization.keepAspect = true ;

net.meta.classes = [] ;


% --------------------------------------------------------------------
function net = insertBnorm(net, l)
% --------------------------------------------------------------------
assert(isfield(net.layers{l}, 'weights'));
ndim = size(net.layers{l}.weights{1}, 4);
layer = struct('type', 'bnorm', ...
               'weights', {{ones(ndim, 1, 'single'), zeros(ndim, 1, 'single')}}, ...
               'learningRate', [1 1 0.05], ...
               'weightDecay', [0 0]) ;
net.layers{l}.biases = [] ;
net.layers = horzcat(net.layers(1:l), layer, net.layers(l+1:end)) ;
