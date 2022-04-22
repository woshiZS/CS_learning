## Git 笔记

> 之前只会用，但是背后蕴含的原理还是不太懂（远程协作和分支），刚好趁着做cs144仔细看一下

### Git remote

* 不同于SVN有一个固定中心，固定中心的意思是commit就相当于git的commit和push，本地只是一份clone，真正的记录只有远端库一份，git更像那种p2p，任意两个人之间都可以collaborate。

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

### Git Checkout

主要是因为git fetch需要显示使用git checkout作为前提，所以把这里也再巩固一遍（主要是和分支有关的内容）。

git checkout的功能就是切换到某个特定分支（切换到不同的开发环境）。

* checkout和clone的区别

> 前者是在本地的分支之间进行切换，而后者做的是将远端代码拉到本地。

* Existing branches

  ```bash
  git branch # 列出所有分支
  git checkout <branch_name> # 选择一个分支进行切换，注意切换之前你的work tree是clean的
  ```

* New branches

git checkout和git branch息息相关，

```bash
git branch <new-branch-name>	# 创建新分支
git checkout <new-branch-name>	# 切换到新分支
git checkout -b <new-branch-name>	# 上面两个指令的内容合并到一起
git checkout -b <new-branch-name> <existing-branch> # 默认是基于head创建新分支，可选最后一个参数作为新分支的base
```

切换分支的history可以使用```git reflog```查看

* Git checkout Remote branch

```bash
git fetch --all # 从远端获取所有分支的内容
git checkout <remote-branch-name> # 新版git可以像本地切换分支一样切换到远端分支
git checkout -b <remote-branch> origin/<remote-branch> # 老版本git需要基于远端分支显示创建一个新的分支
# 或者可以创建一个新的分支，然后通过reset到远端分支
git checkout -b <new-branch-name>
git reset --hard origin/<branch-name>
```

* Detached HEADS

首先要了解HEAD是git用来表示current snapshot的方式，checkout的参数可以是分支也可以是提交，但是参数是提交的时候，就进入了detached的状态，意思就是head现在没有了上下文，具体也不多探讨，但是checkout到一个commit多用于你去看一个老的提交干了写什么事情，其他的情况都是不推荐直接chekcout到一个单独的commit的。

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

### Git Stash

实习工作原因有的时候会遇到下面这种情况：

> 1. 你在某个分支上开发并存在一些改动，但是你还不想提交
> 2. 此时你想切换到其他分支工作或者开始另外的一些工作

git stash就相当于把你的work directory中的内容存到一个栈中，然后你tracked到的内容改动保存起来，再次输入git status不会显示这些文件的改动

```shell
git stash
git stash list # 查看所有stash内容
```

将变动从栈中移除并且将改动重新挪回工作区

```shell
git stash pop
```

如果想要移回改动，但是栈中内容也不会消失

```shell
git stash apply
```

如果想要保存untracked files，那么可以加上-u选项

```shell
git stash -u
git stash -a # 将ignored files的变动也保存起来
```

因为可以管理多个stash，所以需要在每次stash的时候添加一些消息来帮助我们进行辨别。

```shell
git stash save <message> # 相当于git commit -m 中的消息
git stash list # 查看所有的stash
```

默认情况下pop会选择最近的一次stash，当然我们也可以手动进行选择

```shell
git stash pop stash@{2}
```

需要查看git stash中的内容时

```shell
git stash show [-p] # p会显示所有改动内容
```

stash支持部分存储的功能，你可以选择某几个文件的内容，甚至可以选择某个文件的某部分内容，

```shell
git stash -p #  会询问你一个个语句块，哪个需要stash起来
```

| Command | Desription                                                   |
| ------- | ------------------------------------------------------------ |
| /       | search for a hunk by regx                                    |
| ?       | help, usually print this table                               |
| n       | don't stash this hunk                                        |
| q       | quit; do not stash this hunk or any of the remaining ones    |
| a       | stash this hunk and all later hunks in the file              |
| d       | do not stash this hunk or any of the later hunks in the file |

如果当前分支的内容和stash存起来的内容存在冲突，那么可以从stash的内容直接新建一个分支, 基于的提交是创建stash时最近的一次的提交。

```shell
git stash brach <branch-name> stash@{1} # pop the specified stash content
```

删除指定stash

```shell
git stash drop stash@{1}
git stash clear # 删除所有分支
```

#### git stash 工作流程

git stash的提交记录在.git/refs/stash中可以看到，

```bash
git log --oneline --graph "stash@{0}" # 可以使用类似命令查看stash处的提交，需要加双引号，否则shell会将大括号给吞掉
```

一般来说创建git stash的时候会创建一些新的提交，如下图所示(图源： atlassian, 侵删)：

<img src="https://wac-cdn.atlassian.com/dam/jcr:f7dd5493-a98d-449e-ae37-146d6270ccf7/05.svg?cdnVersion=225" width="500px"/>

总之，看最下面那个图就行了，大致会给stash生成3个parent.

### Git Submodule

项目中有使用到git submodule，之前没有使用过，现在稍微记录一下。

* git repository的一大缺点就是无法跟踪外部的依赖，虽然可以通过Ruby Gems或NPM这种软件来管理，但是外部代码的编辑和修改还是无法跟踪到
* 子模块相当于主repository中想要跟踪的外部代码，而且只会跟踪到特定的提交，同时也不会也在主repository更新的时候进行update.

适用于以下场景

* 外部代码版本更迭较快，向指定外部代码在一个固定的版本
* 项目中有一个不需要经常更新的组件
* 将项目中的一部分授权给第三方，需要在固定时间进行整合，同样这种情况也不需要经常进行更新。

**常用指令**

```shell
# Inside a git repository
git submodule add <url>
# now that we've added a submodule to a git repository
```

此时会出现两个新文件，一个是url中指向的文件夹以及.gitmodule文件，此时将仓库改动提交并push到远程仓库即可。

当你clone一个含有子模块的仓库到本地时，子模块中是不会有文件的。需要执行以下命令进行初始化。

```shell
# update .git/config with the mapping from .gitmodule files
git submodule init 
# fetch all data from the submodule project and check out the mapped commit
git submodule update
```

当仓库中存在多个子模块的时候，只有被init的子模块才会被创建，在之后的update中才会更新。

**子模块的workflow**

如果在local的子模块中进行改动，先要在子模块中进行提交和push，之后需要再次切换到主目录中将再次add, commit和push改动。

### 实际问题场景

问题描述：项目中遇到问题，feature分支上又提交没有测试完成，存在一部分提交没有merge到主分支，导致新拉出来的分支是没有当前分支的提交，因为实际场景中git和svn都有用到，所以这里两边都说一下。

##### GIT 当前分支领先于需要切换分支

采用cherry pick将新的提交pick到新分支，具体步骤如下：

* 切换到目的分支
* 选取自己需要cherry pick的分支，选择对应log，然后选择cherry pick即可，如果有conflct，则需要自己手动再merge一遍，最后push到远端仓库

##### SVN对应情况

操作和git差不多，不过这边只有merge，也是先切换到对应分支，选择对应提交记录，merge完之后commit即可，注意提交信息需要打开log选择倒数第一次的提交message。

