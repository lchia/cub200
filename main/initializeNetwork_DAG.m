% -------------------------------------------------------------------------
% function net = initializeNetwork_DAG(imdb, opts)
% -------------------------------------------------------------------------
% scal = 1 ;
% init_bias = 0.1;
% numClass = length(imdb.classes.name);

clc; clear; close all;
% load vgg-m.mat & change it into dagnn mode
mnet = load('../data/models/imagenet-vgg-m.mat') ;
addpath('/home/lch/lchpro/matconvnet/matlab') ;
addpath('/home/lch/lchpro/matconvnet/matlab/simplenn') ;
obj = fromSimpleNN(mnet) ; 

 