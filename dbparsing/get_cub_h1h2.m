%-----------------------------------------------------------------------------------------------------
function get_cub_h1h2(cubDir) 
%-----------------------------------------------------------------------------------------------------
%Split CUB_200_2011 into h1&h2 classes
% cubDir = './';
 % cub_images
fid_images = fopen(fullfile(cubDir, 'images.txt'), 'r');
images = textscan(fid_images, '%d %s');
fclose(fid_images);

% cub_parsing_h1&h2
nid_all = images{1,1}; nstr_all = images{1,2}; 
imgNum = size(nstr_all,1);
CUB200 = cell(imgNum, 1);

% >>CUB200.mat
CUB200_mat_file = fullfile(cubDir, 'CUB200.mat');
if ~exist(CUB200_mat_file, 'file')
    for ii = 1 : imgNum
       nii = nstr_all{ii};
       [class_h1, class_h2] = classes_h1h2_parsing(nii);
       fprintf('>%d-th image: %s(H1), %s(H2)\n', ii, class_h1, class_h2);
       %@_@
       CUB200{ii,1} = class_h1;
       CUB200{ii,2} = class_h2;
    end 
    save(CUB200_mat_file, 'CUB200');
else
    load(CUB200_mat_file);
end

% >>classes_h1.txt
classes_h1_all = unique( CUB200(:,1) );
classes_h1_file = fullfile(cubDir, 'classes_h1.txt');
if  ~exist(classes_h1_file, 'file')
    fid_classes_h1 = fopen(classes_h1_file, 'w');
    for ii = 1 : numel(classes_h1_all)
        fprintf(fid_classes_h1, '%d %s\n', ii, classes_h1_all{ii});
    end
    fclose(fid_classes_h1);
end

% >>classes_h2.txt
classes_h2_all = unique( CUB200(:,2) );
classes_h2_file = fullfile(cubDir, 'classes_h2.txt');
if  ~exist(classes_h2_file, 'file')
    fid_classes_h2= fopen(classes_h2_file, 'w'); 
    for ii = 1 : numel(classes_h2_all)
        fprintf(fid_classes_h2, '%d %s\n', ii, classes_h2_all{ii});
    end
    fclose(fid_classes_h2);
end

% >> icl: image_class_labels
icl_h2_file = fullfile(cubDir, 'image_class_labels_h2.txt');
icl_h1_file = fullfile(cubDir, 'image_class_labels_h1.txt');
if ~exist(icl_h2_file, 'file') || ~exist(icl_h1_file, 'file')
    fid_icl_h2 = fopen(icl_h2_file, 'w');
    fid_icl_h1 = fopen(icl_h1_file, 'w');

    for ii = 1 : imgNum
       nid = nid_all(ii); nii = nstr_all{ii};
       [class_h1, class_h2] = classes_h1h2_parsing(nii); 
       [~,loc_h1] = ismember(class_h1, classes_h1_all); 
       [~,loc_h2] = ismember(class_h2, classes_h2_all);
       fprintf('==>%d-th image: %s(H1_%2d), %s(H2_%3d); %s\n', ...
           ii, class_h1, loc_h1, class_h2, loc_h2, nii);
       fprintf(fid_icl_h2, '%d %d\n', ii, loc_h2 - 1);
       fprintf(fid_icl_h1, '%d %d\n', ii, loc_h1 - 1);
    end
    fclose(fid_icl_h2);
    fclose(fid_icl_h1);
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
