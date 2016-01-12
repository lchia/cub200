github README.md 
=========================

1. 普通文本
-------------------
直接输入的文字就是普通文本。需要注意的是要换行的时候不能直接通过回车来换行，需要使用\<br>。<br>

2. 显示空格的小Tip
-------------------
默认的文本行首空格都会被忽略的，但是如果你想用空格来排一下版的话怎么办呢，有个小技巧，那就是把你的输入法由半角改成全角就OK啦。<br>

3. 单行文本
-------------------
使用两个Tab符实现单行文本。

4. 部分文字的高亮
-------------------
如果你想使一段话中部分文字高亮显示，来起到突出强调的作用，那么可以把它用 \`  \` 包围起来。注意这不是单引号，而是Tab上方，数字1左边的按键（注意使用英文输入法）。<br>
Thank `You` . Please `Call` Me `Coder`

5. 文字超链接
-------------------
给一段文字加入超链接的格式是这样的 `[ 要显示的文字 ]( 链接的地址 )`。比如：<br>
	\[我的博客](http://blog.csdn.net/guodongxiaren) <br>
[我的博客](http://blog.csdn.net/guodongxiaren)  

6. 插入符号
-------------------
* 圆点符 \*
	* 二级圆点
		* 三级圆点。就是多加一个Tab。

7. 缩进
-------------------
缩进的含义是很容易理解的。
>\>
>>\>>
>>>\>>>

8. insert来源于网络的图片
-------------------
网络的图片
	`![](http://www.baidu.com/img/bdlogo.gif)`
鼠标悬停显示提示信息，那么可以仿照前面介绍的文本中的方法，就是这样： <br>
    	`![baidu](http://www.baidu.com/img/bdlogo.gif "百度logo")` 

![](http://www.baidu.com/img/bdlogo.gif) 
![baidu](http://www.baidu.com/img/bdlogo.gif "百度logo") 

9. insert GitHub仓库里的图片
-------------------
	与上面的格式基本一致的，所不同的就是括号里的URL该怎么写。
	`![](https://github.com/guodongxiaren/ImageCache/raw/master/Logo/foryou.gif)` 
![](https://github.com/guodongxiaren/ImageCache/raw/master/Logo/foryou.gif) 

10. 给图片加上超链接
-------------------
如果你想使图片带有超链接的功能，即点击一个图片进入一个指定的网页。 <br>
	`[![baidu]](http://baidu.com)` <br>
	`[baidu]:http://www.baidu.com/img/bdlogo.gif "百度Logo"` <br>
[![baidu]](http://baidu.com)  
[baidu]:http://www.baidu.com/img/bdlogo.gif "百度Logo"
