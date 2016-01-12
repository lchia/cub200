function main()
cubDir = '../CUB_200_2011';
% >>Split CUB_200_2011 into h1&h2 classes
get_cub_h1h2(cubDir);
 
useCropped = false;
useVal = false; 
imdb = cub_imdb(cubDir, useCropped, useVal); 

if 1
 preDir = '../data/hierachy1'; 
 cub_pre_lmdb_h1(imdb, preDir);
end

preDir = '../data/hierachy2/datas'; 
if exist(preDir, 'dir')
  cub_pre_lmdb_h2(imdb, preDir);
end


if 1
 lmdb_dir = '../data/hierachy2/lmdb';
 if exist(lmdb_dir); rmdir(lmdb_dir, 's'); end
 mkdir(lmdb_dir);
 make_lmdb_cmdstr(lmdb_dir, preDir, '../makedb');
end
