Git-learn
===============================================
0. 设置账户信息
       git config --global user.name "lchia"
    $ git config --global user.email lichenghua2014@ia.ac.cn
	##Git文档忽略机制 
	工作目录中有一些文件是不希望接受Git 管理的，譬如程序编译时生成的中间文件等等。Git 提供了文档忽略机制，可以将工作目录中不希望接受Git 管理的文档信息写到同一目录下的.gitignore 文件中。 
	例如：工作目录下有个zh目录，如果不想把它加入到Git管理中，则执行： 
	       echo “zh” > .gitignore 
	       git add . 
	有关gitignore 文件的诸多细节知识可阅读其使用手册：man gitignore 

1. 创建一个空的Git库
    $ git init
	在当前目录中产生一个.git 的子目录。以后，所有的文件变化信息都会保存到这个目录下，而不像CVS那样，会在每个目录和子目录下都创建一个CVS目录。在.git目录下有一个config文件，可以修改其中的配置信息.

    $ git status
	On branch master

	Initial commit

	Changes to be committed:
	  (use "git rm --cached <file>..." to unstage)

		new file:   CUB_200_2011
		new file:   data
		new file:   dbparsing/cub_imdb.m

2. Git add 
将当前工作目录中更改或者新增的文件加入到Git的索引中，加入到Git的索引中就表示记入了版本历史中，这也是提交之前所需要执行的一步。 
可以递归添加，即如果后面跟的是一个目录作为参数，则会递归添加整个目录中的所有子目录和文件。例如： 
       git add dir1 （ 添加dir1这个目录，目录下的所有文件都被加入 ） 
       Git add f1 f2 （ 添加f1，f2文件） 
       git add .      ( 添加当前目录下的所有文件和子目录 ) 

3. 将add的文件commit到仓库
    $ git commit -m 'version 1.0'
	[master (root-commit) af8657e] version 1.0
	 34 files changed, 2607 insertions(+)
	 create mode 120000 CUB_200_2011
	 create mode 120000 data
	 create mode 100644 dbparsing/cub_imdb.m
	 create mode 100644 dbparsing/cub_pre_lmdb_h1.m
	 create mode 100644 dbparsing/cub_pre_lmdb_h2.m
	 create mode 100644 dbparsing/get_cub_h1h2.m
	 create mode 100644 dbparsing/main.m
	 create mode 100644 dbparsing/make_lmdb_cmdstr.m
	 create mode 100644 main/bird_demo.m
	 create mode 100644 main/cars_get_database.m
	 create mode 100644 main/compute_confusion.m
	 create mode 100644 main/cub_get_database.m
	 create mode 100644 main/cub_imdb.m
	 create mode 100644 main/encoder_save.m
	 create mode 100644 main/fromSimpleNN.m
	 create mode 100644 main/get_cub_h1h2.m
	 create mode 100644 main/get_dcnn_features.m
	 create mode 100644 main/get_rcnn_features.m
	 create mode 100644 main/imdb_cnn_train.m
	 create mode 100644 main/imdb_get_batch.m
	 create mode 100644 main/initializeNetwork_DAG.m
	 create mode 100644 main/model_setup.m
	 create mode 100644 main/model_train.m
	 create mode 100644 main/net2dagnet.m
	 create mode 100644 main/print_dataset_info.m
	 create mode 100644 main/run_experiments_train.m
	 create mode 100644 main/savefast.m
	 create mode 100644 main/setup.m
	 create mode 100644 main/test_image.jpg
	 create mode 100644 main/vl_nnl2norm.m
	 create mode 100644 main/vl_nnsqrt.m
	 create mode 100755 makedb/run_lmdb_h2.sh
	 create mode 120000 matconvnet
	 create mode 120000 vlfeat

4. 去github上创建自己的Repository, copy the 仓库的https地址: https://github.com/lchia/cub200

5. 将本地的仓库关联到github上
    $ git remote add origin https://github.com/lchia/cub200

6. 上传github之前，要先pull一下，执行如下命令
    $ git pull orgin master
	warning: no common commits
	remote: Counting objects: 3, done.
	remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
	Unpacking objects: 100% (3/3), done.
	From https://github.com/lchia/cub200
	 * branch            master     -> FETCH_HEAD
	 * [new branch]      master     -> orgin/master
	Merge made by the 'recursive' strategy.
	 README.md | 2 ++
	 1 file changed, 2 insertions(+)
	 create mode 100644 README.md


7. 最后一步，上传代码到github远程仓库
    $ git push -u orgin master 
	Username for 'https://github.com': lchia
	Password for 'https://lchia@github.com': 
	Counting objects: 41, done.
	Delta compression using up to 8 threads.
	Compressing objects: 100% (35/35), done.
	Writing objects: 100% (40/40), 88.76 KiB | 0 bytes/s, done.
	Total 40 (delta 3), reused 0 (delta 0)
	To https://github.com/lchia/cub200
	   fa9def8..e0759bd  master -> master
	Branch master set up to track remote branch master from orgin.

8.  Git status 
查看版本库的状态。可以得知哪些文件发生了变化，哪些文件还没有添加到git库中等等。 建议每次commit前都要通过该命令确认库状态。 
最常见的误操作是， 修改了一个文件， 没有调用git add通知git库该文件已经发生了变化就直接调用commit操作， 从而导致该文件并没有真正的提交。这时如果开发者以为已经提交了该文件，就继续修改甚至删除这个文件，那么修改的内容就没有通过版本管理起来。如果每次在 提交前，使用git status查看一下，就可以发现这种错误。因此，如果调用了git status命令，一定要格外注意那些提示为 “Changed but not updated:”的文件。 这些文件都是与上次commit相比发生了变化，但是却没有通过git add标识的文件。 
 When I Modified 'README.md', then 
    $ git status 
	On branch master
	Your branch is up-to-date with 'orgin/master'.

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)

		modified:   README.md

	Untracked files:
	  (use "git add <file>..." to include in what will be committed)

		git_learn.md
		git_learn.md~

	no changes added to commit (use "git add" and/or "git commit -a")

9. Git commit 
提交当前工作目录的修改内容。 
直接调用git commit命令，会提示填写注释。通过如下方式在命令行就填写提交注释：git commit -m "Initial commit of gittutor reposistory"。 注意，和CVS不同，git的提交注释必须不能为空，否则就会提交失败。 
       git commit还有一个 -a的参数，可以将那些没有通过git add标识的变化一并强行提交，但是不建议使用这种方式。 
每一次提交，git就会为全局代码建立一个唯一的commit标识代码，用户可以通过git reset命令恢复到任意一次提交时的代码。 
       git commit –-amend –m “message” （在一个commit id上不断修改提交的内容） 



