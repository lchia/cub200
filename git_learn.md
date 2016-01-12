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

    $ git add
	Nothing specified, nothing added.
	Maybe you wanted to say 'git add .'?

    $ git add git_learn.md

    $ git commit -m 'add messages to README.md'
	[master 14919cd] add messages to README.md
	 1 file changed, 138 insertions(+)
	 create mode 100644 git_learn.md

9. Git commit 
提交当前工作目录的修改内容。 
直接调用git commit命令，会提示填写注释。通过如下方式在命令行就填写提交注释：git commit -m "Initial commit of gittutor reposistory"。 注意，和CVS不同，git的提交注释必须不能为空，否则就会提交失败。 
       git commit还有一个 -a的参数，可以将那些没有通过git add标识的变化一并强行提交，但是不建议使用这种方式。 
每一次提交，git就会为全局代码建立一个唯一的commit标识代码，用户可以通过git reset命令恢复到任意一次提交时的代码。 
       git commit –-amend –m “message” （在一个commit id上不断修改提交的内容） 

10. Git diff 
	把本地的代码和index中的代码进行比较，或者是把index中的代码和本地仓库中的代码进行比较。 
	1） Git diff 
	比较工作目录和Index中的代码。 

    $ git diff
	diff --git a/README.md b/README.md
	index dcac0da..4d5ec5e 100644
	--- a/README.md
	+++ b/README.md
	@@ -1,2 +1,13 @@
	 # cub200
	-cub200
	+1. Requirments
	+matconvnet:
	+       git clone https://github.com/vlfeat/matconvnet
	+  compile: >matlab
	+       >>cd ./matconvnet/matlab/
	+       >>vl_compilenn('enableGpu', true)
	+vlfeat:
	+       git clone https://github.com/vlfeat/vlfeat
	+  compile: >matlab
	+       >>cd ./vlfeat/toolbox/
	+       >>vl_setup
	+
	diff --git a/git_learn.md b/git_learn.md
	index de7d017..611eead 100644
	--- a/git_learn.md
:

	2） Git diff - - cached 
	比较index和本地仓库中的代码。 

11. 查看当前的git库中有那些文件。 
    $ git ls-files

12. 在 git 版本库中创建分支的成本几乎为零，所以，不必吝啬多创建几个分支。当第一次执行git init时，系统就会创建一个名为“master”的分支。 而其它分支则通过手工创建。  分支是用来将特性开发绝缘开来的。在你创建仓库的时候，master 是“默认的”分支。在其他分支上进行开发，完成后再将它们合并到主分支上。
	创建一个叫做“feature_x”的分支，并切换过去：
	$ git checkout -b feature_x
	切换回主分支：
	$ git checkout master
	再把新建的分支删掉：
	$ git branch -d feature_x
	除非你将分支推送到远端仓库，不然该分支就是 不为他人所见的：
	$ git push origin <branch>
下面列举一些常见的分支策略： 
创建一个属于自己的个人工作分支，以避免对主分支 master 造成太多的干扰，也方便与他人交流协作； 
当进行高风险的工作时，创建一个试验性的分支； 
合并别人的工作的时候，最好是创建一个临时的分支用来合并，合并完成后再“fetch”到自己的分支。 
对分支进行增、删、查等操作。 
注意：分支信息一般在.git/refs/目录下，其中heads目录下为本地分支，remotes为对应服务器上的分支，tags为标签。 
>>. 列出本地git库中的所有分支。在列出的分支中，若分支名前有*，则表示此分支为当前分支。 
    $ git branch 
	* master

       git branch –r 列出服务器git库的所有分支。 
（可以继续使用命令 “ git checkout -b 本地分支名 服务器分支名”来获取服务器上某个分支的代码文件）。 
>>. 查看当前在哪个分支上 
   $ cat .git/HEAD 
	ref: refs/heads/master
>>. 创建一个分支 
1） git branch 分支名 
虽然创建了分支，但是不会将当前工作分支切换到新创建的分支上，因此，还需要命令“git checkout 分支名” 来切换
    $ git branch dagnn
    $ git branch
	  dagnn
	* master
	  –r
2） git checout –b 分支名 
不但创建了分支，还将当前工作分支切换到了该分支上。 
	切换到某个分支：git checkout 分支名(切换到主分支：git checkout master ) 
	删除分支 $ git branch –D 分支名, (注意： 删除后，发生在该分支的所有变化都无法恢复。强制删除此分支.)
		$ git branch -D dagnn 
			Deleted branch dagnn (was 14919cd).
	比较两个分支上的文件的区别: $ git diff master 分支名 （比较主分支和另一个分支的区别） 
	查看分支历史:
		$  git-show-branch （查看当前分支的提交注释及信息） 
		$  git-show-branch -all（查看所有分支的提交注释及信息）
	例如： 
	* [dev] d2 
	! [master] m2 
	-- 
	* [dev] d2 
	* [dev^] d1 
	* [dev~2] d0 
	*+ [master] m2 
	在上述例子中， “--”之上的两行表示有两个分支dev和master， 且dev分支上最后一次提交的日志是“d2”,master分支上最后一次提交的日志是 “m2”。 “--”之下的几行表示了分支演化的历史，其中 dev表示发生在dev分支上的最后一次提交，dev^表示发生在dev分支上的倒数第二次提交。dev~2表示发生在dev分支上的倒数第三次提交。

>>. 查看当前分支的操作记录 
       git whatchanged 
>>. 合并分支 
	法一：  git merge “注释” 合并的目标分支 合并的来源分支, 如果合并有冲突，git会有提示。 
	例如：$ git checkout master   （切换到master分支） 
	      $ git merge HEAD dev~2 (合并master分支和dev~2分支)或者：git merge master dev~2 
	法二： 
	       git pull 合并的目标分支 合并的来源分支 
	例如: $ git checkout master （切换到master分支） 
	      $ git pull . dev~2（合并当前分支和dev~2分支） 

13. 显示对象的不同类型
     $ git show
	commit 14919cd0b9403edba2e4aba581505e3c105c29ba
	Author: lchia <lichenghua2014@ia.ac.cn>
	Date:   Tue Jan 12 11:19:42 2016 +0800

	    add messages to README.md

	diff --git a/git_learn.md b/git_learn.md
	new file mode 100644
	index 0000000..de7d017
	--- /dev/null
	+++ b/git_learn.md
	@@ -0,0 +1,138 @@
	+Git-learn
	+===============================================
	+0. 设置账户信息

14. 4. Git服务器操作命令（与服务器交互） 
>>. Git clone 
取出服务器的仓库的代码到本地建立的目录中（与服务器交互） 
通过git clone获取远端git库后，.git/config中的开发者信息不会被一起clone过来。仍然需要为本地库的.git/config文件添加开发者信息。此外，开发者还需要自己添加   . gitignore文件。 
通过git clone获取的远端git库，只包含了远端git库的当前工作分支。如果想获取其它分支信息，需要使用 “git branch –r” 来查看， 如果需要将远程的其它分支代码也获取过来，可以使用命令 “ git checkout -b 本地分支名 远程分支名”，其中，远程分支名为 “git branch –r” 所列出的分支名， 一般是诸如“origin/分支名”的样子。如果本地分支名已经存在， 则不需要“-b”参数。 

>>. 更新与合并
从服务器的仓库中获取代码，和本地代码合并。（与服务器交互，从服务器上下载最新代码，等同于： Git fetch + Git merge） 
从其它的版本库（既可以是远程的也可以是本地的）将代码更新到本地，例如：“git pull origin master ”就是将origin这个版本库的代码更新到本地的master主分支。 
       git pull可以从任意一个git库获取某个分支的内容。用法如下： 
git pull username@ipaddr:远端repository名远端分支名 本地分支名。这条命令将从远端git库的远端分支名获取到本地git库的一个本地分支中。其中，如果不写本地分支名，则默认pull到本地当前分支。 
需要注意的是，git pull也可以用来合并分支。 和git merge的作用相同。 因此，如果你的本地分支已经有内容，则git pull会合并这些文件，如果有冲突会报警。 
 
	要更新你的本地仓库至最新改动，执行：
	$ git pull
	以在你的工作目录中 获取（fetch） 并 合并（merge） 远端的改动。
	要合并其他分支到你的当前分支（例如 master），执行：
	$ git merge <branch>
	在这两种情况下，git 都会尝试去自动合并改动。遗憾的是，这可能并非每次都成功，并可能出现冲突（conflicts）。 这时候就需要你修改这些文件来手动合并这些冲突（conflicts）。改完之后，你需要执行如下命令以将它们标记为合并成功：
	$ git add <filename>
	在合并改动之前，你可以使用如下命令预览差异：
	$ git diff <source_branch> <target_branch>

>>. 推送改动
将本地commit的代码更新到远程版本库中，例如 “git push origin”就会将本地的代码更新到名为orgin的远程版本库中。 
       git push和git pull正好想反，是将本地某个分支的内容提交到远端某个分支上。用法： git pushusername@ipaddr:远端repository名本地分支名 远端分支名。这条命令将本地git库的一个本地分支push到远端git库的远端分支名中。 
需要格外注意的是，git push好像不会自动合并文件。因此，如果git push时，发生了冲突，就会被后push的文件内容强行覆盖，而且没有什么提示。 这在合作开发时是很危险的事情。 
	
	你的改动现在已经在本地仓库的 HEAD 中了。执行如下命令以将这些改动提交到远端仓库：
	git push origin master
	可以把 master 换成你想要推送的任何分支。
	     $ git push orgin master 
		Username for 'https://github.com': lchia
		Password for 'https://lchia@github.com': 
		Counting objects: 4, done.
		Delta compression using up to 8 threads.
		Compressing objects: 100% (3/3), done.
		Writing objects: 100% (3/3), 3.19 KiB | 0 bytes/s, done.
		Total 3 (delta 1), reused 0 (delta 0)
		To https://github.com/lchia/cub200
		   e0759bd..14919cd  master -> master


	如果你还没有克隆现有仓库，并欲将你的仓库连接到某个远程服务器，你可以使用如下命令添加：
	git remote add origin <server>
	如此你就能够将你的改动推送到所添加的服务器上去了。

>>. Git fetch 
从服务器的仓库中下载代码。（与服务器交互，从服务器上下载最新代码） 
相当于从远程获取最新版本到本地，不会自动merge，比Git pull更安全些。 
使用此方法来获取服务器上的更新。 
例如：如果使用git checkout nov/eclair_rocket （nov/eclair_rocket为服务器上的分支名），则是获取上次使用git fetch命令时从服务器上下载的代码；如果先使用 git fetch ，再使用git checkout nov/eclair_rocket，则是先从服务器上获取最新的更新信息，然后从服务器上下载最新的代码。.


>>. Git release 
一般在将服务器最新内容合并到本地时使用，例如：在版本C时从服务器上获取内容到本地，修改了本地内容，此时想把本地修改的内容提交到服务器上；但发现服务器上的版本已经变为G了，此时就需要先执行Git release，将服务器上的最新版本合并到本地.

>>. Git reset 
库的逆转与恢复除了用来进行一些废弃的研发代码的重置外，还有一个重要的作用。比如我们从远程clone了一个代码库，在本地开发后，准备提交回远程。但 是本地代码库在开发时，有功能性的commit，也有出于备份目的的commit等等。总之，commit的日志中有大量无用log，我们并不想把这些 log在提交回远程时也提交到库中。 因此，就要用到git reset。 
       git reset的概念比较复杂。它的命令形式：git reset [--mixed | --soft | --hard] [] 
命令的选项： 
       --mixed 这个是默认的选项。如git reset [--mixed] dev^(dev^的定义可以参见2.6.5)。它的作用仅是重置分支状态到dev1^, 但是却不改变任何工作文件的内容。即，从dev1^到dev1的所有文件变化都保留了，但是dev1^到dev1之间的所有commit日志都被清除了， 而且，发生变化的文件内容也没有通过git add标识，如果您要重新commit，还需要对变化的文件做一次git add。 这样，commit后，就得到了一份非常干净的提交记录。 （回退了index和仓库中的内容） 
       --soft相当于做了git reset –mixed，后，又对变化的文件做了git add。如果用了该选项， 就可以直接commit了。（回退了仓库中的内容） 
       --hard这个命令就会导致所有信息的回退， 包括文件内容。 一般只有在重置废弃代码时，才用它。 执行后，文件内容也无法恢复回来了。（回退了工作目录、index和仓库中的内容） 
例如： 
切换到使用的分支上； 
       git reset HEAD^ 回退第一个记录 
       git reset HEAD~2 回退第二个记录 
如果想把工作目录下的文件也回退，则使用git reset - - hard HEAD^ 回退第一个记录 
       git reset - - hard HEAD~2 回退第二个记录 
还可以使用如下方法： 
将当前的工作目录完全回滚到指定的版本号，假设如下图，我们有A-G五次提交的版本，其中C的版本号是 bbaf6fb5060b4875b18ff9ff637ce118256d6f20，我们执行了'git reset bbaf6fb5060b4875b18ff9ff637ce118256d6f20'那么结果就只剩下了A-C三个提交的版本

>>. Git revert 
还原某次对版本的修改，例如：git revert commit_id （其中commit_id为commit代码时生成的一个唯一表示的字符串） 
例如：（3.6中）git revert dfb02e6e4f2f7b573337763e5c0013802e392818 （执行此操作，则还原上一次commit的操作） 
