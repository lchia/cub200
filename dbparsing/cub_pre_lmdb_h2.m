function cub_pre_lmdb_h2(imdb, preDir)
% >>h2_train.txt & h2_test.txt
if ~exist(preDir, 'dir'); mkdir(preDir); end

images = imdb.images.name;
h1_label = imdb.images.label.h1;
h1_classes = imdb.classes.name.h1;
h2_label = imdb.images.label.h2;
h2_classes = imdb.classes.name.h2;
ttsplit = imdb.images.set;
imgNum = numel(images);
 
% if ~exist(htest, 'file') || ~exist(htrain, 'file')
cub_tree = struct('h1', [], 'h2', []);
cub_tree.h1.name = imdb.classes.name.h1;
cub_tree.h1.label = imdb.images.label.h1;
fid_cub_file = fopen(fullfile(preDir, '../cub_tree.txt'), 'w');
fprintf(fid_cub_file, '%s\n', '##CUB_200_2011-tree');
for ii = 1  : numel(cub_tree.h1.name) 
   id = find( cub_tree.h1.label == (ii -1) );
   cub_tree.h2(ii).name = cub_tree.h1.name{ii};
   cub_tree.h2(ii).id = id;
   
   cub_tree.h2(ii).classes = unique(h2_classes(h2_label(id) + 1));
   %>>write cub_tree.txt
   fprintf(fid_cub_file, '%2d: %s__%d\n', ii, cub_tree.h2(ii).name, numel(cub_tree.h2(ii).classes)); 
end
fclose(fid_cub_file);

for ii = 1 : imgNum
   nii = images{ii};
   l2ii = h2_label(ii);  c2ii = h2_classes{l2ii+1};          
   l1ii = h1_label(ii);  c1ii = h1_classes{l1ii+1}; 
   fprintf('==>%5d-th: %s(h1_%2d); %s(h2_%3d); @ %s\n',...
       ii, c1ii, l1ii, c2ii, l2ii, nii);
   tt_idx = ttsplit(ii);
   
   [~, l2ii] = ismember(c2ii, cub_tree.h2(l1ii+1).classes);
   
   npre = ['h2_h', num2str(l1ii+1), '_'];
   htrain = fullfile(preDir, [npre, 'train.txt']); htest = fullfile(preDir, [npre, 'test.txt']); 
   fid_htrain = fopen(htrain, 'a'); fid_htest = fopen(htest, 'a'); 
   if tt_idx == 1
       fprintf(fid_htrain, '%s %d\n', nii, l2ii - 1);
   else
       fprintf(fid_htest, '%s %d\n', nii, l2ii - 1);
   end
   fclose(fid_htest); fclose(fid_htrain); 
   
   % >>check: class_h2 == cii
   [class_h1, class_h2] = classes_h1h2_parsing(nii);
   assert(strcmp(class_h2, c2ii));
   assert(strcmp(class_h1, c1ii));
end 

%-----------------------------------------------------------------------------------------------------
function [class_h1, class_h2] = classes_h1h2_parsing(img_name)
%-----------------------------------------------------------------------------------------------------
[pstr, nstr, ext] = fileparts(img_name);% path_str, name_str
lidx = find(pstr == '.'); %label_seg index
cidx = find(pstr == '_'); %class_seg index
 
if isempty(cidx); cidx = lidx; end
class_h2 = pstr(lidx+1:end);
class_h1 = pstr(cidx(end)+1:end);
