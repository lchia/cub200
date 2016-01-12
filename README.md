# cub200
1. Requirments
matconvnet:
	git clone https://github.com/vlfeat/matconvnet
  compile: >matlab
	>>cd ./matconvnet/matlab/
	>>vl_compilenn('enableGpu', true)
vlfeat:
	git clone https://github.com/vlfeat/vlfeat
  compile: >matlab
	>>cd ./vlfeat/toolbox/
	>>vl_setup

