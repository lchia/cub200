function make_lmdb_cmdstr(lmdb_dir, preDir, runDir)
shf_file = fullfile(runDir, 'run_lmdb_h2.sh');
if exist(shf_file, 'file'); system(['rm ', shf_file]); end
fid_shf = fopen(shf_file, 'a');
for ii = 1 : 70
   npre = ['h2_h', num2str(ii), '_'];
   htrain = fullfile(preDir, [npre, 'train.txt']); htest = fullfile(preDir, [npre, 'test.txt']);
   htrain_lmdb = fullfile(lmdb_dir, [npre, 'train_lmdb']); htest_lmdb = fullfile(lmdb_dir, [npre, 'test_lmdb']);
   cubImageDir = '../CUB_200_2011/images/';

   cmdstr_trian = ['./lmdb_creat.sh cub200-h2 ', htrain, ' ', htrain_lmdb,  ' ', cubImageDir]
   cmdstr_test  = ['./lmdb_creat.sh cub200-h2 ', htest,  ' ', htest_lmdb,   ' ', cubImageDir]
   fprintf(fid_shf, '%s\n%s\n', cmdstr_trian, cmdstr_test);
end
fclose(fid_shf);
system(['chmod +x ', shf_file]);
