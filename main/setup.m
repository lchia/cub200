% run /scratch1/tsungyulin/matlabToolbox/vlfeat-0.9.19/toolbox/vl_setup
warning off ;
run('../vlfeat/toolbox/vl_setup') ;
addpath('../matconvnet/matlab/') ;
run('vl_setupnn') ;
%vl_compilenn('enableGpu', true, 'cudaRoot', '/usr/local/cuda', 'cudaMethod', 'nvcc') ;
addpath('../matconvnet/examples/') ;
clear mex ;  
