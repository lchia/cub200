function cub_pre_lmdb_h1(imdb, preDir)
% >>h1_train.txt & h1_test.txt
if ~exist(preDir, 'dir'); mkdir(preDir); end

images = imdb.images.name;
h1_label = imdb.images.label.h1;
h1_classes = imdb.classes.name.h1;
ttsplit = imdb.images.set;
imgNum = numel(images);
htrain = fullfile(preDir, 'h1_train.txt'); htest = fullfile(preDir, 'h1_test.txt'); 
 
if ~exist(htest, 'file') || ~exist(htrain, 'file')
    fid_htrain = fopen(htrain, 'w');
    fid_htest = fopen(htest, 'w'); 
    for ii = 1 : imgNum
        nii = images{ii};
        lii = h1_label(ii);
        cii = h1_classes{lii + 1};
        fprintf('==>%5d-th image: %s(H1_%2d); %s\n', ii, cii, lii, nii);
        tt_idx = ttsplit(ii);
        if tt_idx == 1
            fprintf(fid_htrain, '%s %d\n', nii, lii);
        else
            fprintf(fid_htest, '%s %d\n', nii, lii);
        end

        % >>check: class_h1 == cii
        [class_h1, ~] = classes_h1h2_parsing(nii);
        assert(strcmp(class_h1, cii));
    end
    fclose(fid_htest); fclose(fid_htrain); 
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
