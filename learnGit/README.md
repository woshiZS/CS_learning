## Git 笔记

> 之前只会用，但是背后蕴含的原理还是不太懂（远程协作和分支），刚好趁着做cs144仔细看一下

### Git remote

* 不同于SVN有一个固定中心，git更像那种p2p，任意两个人之间都可以collaborate。

> The `git remote` command lets you create, view, and delete connections to other repositories.

* 实质上还是修改./.git/config 文件

```git remote```: List the remote connections you have to other repositories. -v will show the URL

```git remote add <name> <url>```: 和一个远程库连接

```git remote rm <name> ```: 删除一个远程连接库

``` git remore rename <old-name> <new-name> ```: 重命名

* The origin

在你git clone的时候，git会自动创建一个origin标签，指向被拷贝的远程库。

``` git remote get-url <name> ```: 获取一个标签的URL。

``` git remote show <name> ```: 会显示远程仓库的一些详细信息

``` git prune <name> ``` : 删除本地再该仓库中没有的分支。

```git push <remote-name> <branch-name>```: 将本地push到远程标签的某个分支之上。

### Git fetch

简单而言是一种比较他人工作与自己仓库的方式，使用fetch指令需要显式的使用git checkout拉到另外一个分支，换言之，git pull算是一种比较激进的策略，采取的是拉取之后直接merge的方式。

* 实际上git所有的提交都存储在./.git/objects这个目录之中。 标签引用则存储在./.git/refs中，本地仓库存储在heads分目录下，远程分支的refs存储在remotes/文件夹下面

```git branch```显示所有分支（本地），加 -r表示remote显示所有远程分支。

* 我们可以git checkout 到某一个分支然后git log，想平常分支一样查看远程分支的提交记录。

```git fetch <remote>```: 下载所有远程的分支到本地

```git fetch <remote> <branch>```: 选取特定的远程分支下载到本地

```git fetch --all ```: 将所有远程仓库的所有远程分支下载到本地

```git fetch --dry-run```: 我的理解是带上这个标签，会向你展示命令是如何执行的，但是实际上这些指令并不会被执行。

```bash
git remote add coworkers_repo git@bitbucket.org:coworker/coworkers_repo.git
git fetch coworkers_repo coworkers/feature_brach
# 远程分支的ref不在我们本地序列之中
git checkout coworkers/features_branch
# 此时从远程分支新建一个本地分支即可
git checkout -b local_feature_branch
```

#### 和中心（origin）同步的过程

```git fetch origin```: 拉取所有的分支

```git log --oneline master..origin/master```: 查看有什么新增的提交（在origin仓库的）

```bash
git checkout master
git log origin/master
```

查看远程库最近的提交，和上面不一样的是，上一条指令只会显示本地没有，但是远程有的提交，但是这个指令所有的提交都会显示。

```git merge origin/master```: 如果同意了最近的提交，可以使用merge指令让本地和远程指向同一个同一个commit

### Git push

* export local commits to remote repository.

```git push <remote> <branch>```: 推送当前分支到远程，注意branch指的是本地的分支，此操作将会在远程库上建立一个同名分支。

```git push <remote> --force```: 非fast-forward也可允许push，这样会修改远程库的提交历史，相当于local覆盖远程

```git push <remote> --all```: 推送本地所有的分支

```git push <remote> --tags```: 推送所有的标签，以前好像没怎么用过QAQ

```bash
git checkout master
git fetch origin master
git rebase -i origin/master
git push origin master
```

这里主要介绍一下rebase，其实相当于他的名字，重新选择提交节点，会选择最近最近的一个不同作为重新起点。

* Amended force push

commit的时候添加amend相当于修改上一次提交，此时本地看到的提交和远程的会不一样，此时push需要force选项。

* delete a remote branch or tag

```bash
git branch -D branch_name
git push origin :branch_name
```

delete a branch locally and remotely.

### Git  pull

```git pull <remote> ```: 拉去远程仓库的变动到当前分支并马上merge

```git pull --no-commit <remote> ```: 不会创建一个新的提交

```git pull --rebase <remote> ```: 有点像SVN的update，把自己的所有提交放到最上面。

```git pull --verbose```: 显示详细信息



暂时写到这里，后面有机会再加，bitbucket的教程还是蛮不错的。