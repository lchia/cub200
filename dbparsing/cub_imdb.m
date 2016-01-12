function imdb = cub_imdb(cubDir, useCropped, useVal)
%>> For test
% clc; clear;
% cubDir = './';
% useCropped = false;
% useVal = false;

% >> Main function
if useCropped
imdb.imageDir = fullfile(cubDir, 'images_cropped') ;
else
imdb.imageDir = fullfile(cubDir, 'images');
end

imdb.sets = {'train', 'val', 'test'};

% Image names
[~, imageNames] = textread(fullfile(cubDir, 'images.txt'), '%d %s');
imdb.images.name = imageNames;
imdb.images.id = (1:numel(imdb.images.name));

% Class names
[~, classNames_h2] = textread(fullfile(cubDir, 'classes_h2.txt'), '%d %s');
imdb.classes.name.h2 = horzcat(classNames_h2(:));
[~, classNames_h1] = textread(fullfile(cubDir, 'classes_h1.txt'), '%d %s');
imdb.classes.name.h1 = horzcat(classNames_h1(:));

% Class labels 
[~, classLabel_h2] = textread(fullfile(cubDir, 'image_class_labels_h2.txt'), '%d %d');
imdb.images.label.h2 = reshape(classLabel_h2, 1, numel(classLabel_h2)); %cub-200
[~, classLabel_h1] = textread(fullfile(cubDir, 'image_class_labels_h1.txt'), '%d %d');
imdb.images.label.h1 = reshape(classLabel_h1, 1, numel(classLabel_h1)); %cub-70

% Bounding boxes
[~,x, y, w, h] = textread(fullfile(cubDir, 'bounding_boxes.txt'), '%d %f %f %f %f');
imdb.images.bounds = round([x y x+w-1 y+h-1]');

% Image sets
[~, imageSet] = textread(fullfile(cubDir, 'train_test_split.txt'), '%d %d');
imdb.images.set = zeros(1,length(imdb.images.id));
imdb.images.set(imageSet == 1) = 1;
imdb.images.set(imageSet == 0) = 3;
% imdb.images.set(imageSet == 0) = 2;%Use 'test' as 'val'

if useVal
rng(0); trainSize = numel(find(imageSet==1));
trainIdx = find(imageSet==1);

% set 1/3 of train set to validation
valIdx = trainIdx(randperm(trainSize, round(trainSize/3)));
imdb.images.set(valIdx) = 2;
end
