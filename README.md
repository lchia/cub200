# cub200
===================

#1. Requirments 
----------------
##(1) matconvnet: <br>
	git clone https://github.com/vlfeat/matconvnet
  compile: >matlab <br>
	>>cd ./matconvnet/matlab <br>
	>>vl_compilenn('enableGpu', true) <br>
##(2) vlfeat: <br>
	git clone https://github.com/vlfeat/vlfeat
  compile: >matlab <br>
 	>>cd ./vlfeat/toolbox/ <br>
 	>>vl_setup <br>

#2. Preparation
----------------
##I. link dataset
		ln -sf 'path_to_dataset' CUB_200_2011
##II. link 'data'
		ln -sf 'path_to_data' data
##III. link 'vlfeat' & 'matconvnet'
		ln -sf 'path_to_vlfeat' vlfeat
		ln -sf 'path_to_matconvnet' matconvnet

#3. 'data' making >matlab
------------------
		cd ./dbparsing
		run main.m
