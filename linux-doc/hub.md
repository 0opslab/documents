As a contributor to open-source
-------------------------------

# clone your own project
#克隆自己的项目
$ git clone dotfiles
→ git clone git://github.com/YOUR_USER/dotfiles.git

# clone another project
#克隆另一个项目
$ git clone github/hub
→ git clone git://github.com/github/hub.git

# see the current project's issues
#看看当前项目的问题
$ git browse -- issues
→ open https://github.com/github/hub/issues

# open another project's wiki
#打开另一个项目的维基
$ git browse mojombo/jekyll wiki
→ open https://github.com/mojombo/jekyll/wiki

## Example workflow for contributing to a project:
#贡献项目的示例工作流程：
$ git clone github/hub
$ cd hub
# create a topic branch
#创建一个主题分支
$ git checkout -b feature
→ ( making changes ... )
$ git commit -m "done with feature"
# It's time to fork the repo!
#现在是时候分开回购了！
$ git fork
→ (forking repo on GitHub...)
→ git remote add YOUR_USER git://github.com/YOUR_USER/hub.git
# push the changes to your new remote
#将更改推送到新远程
$ git push YOUR_USER feature
# open a pull request for the topic branch you've just pushed
#打开你刚刚推送的主题分支的拉取请求
$ git pull-request
→ (opens a text editor for your pull request message)


As an open-source maintainer
----------------------------

# fetch from multiple trusted forks, even if they don't yet exist as remotes
#从多个可信分叉中获取，即使它们尚不存在作为远程数据库
$ git fetch mislav,cehoffman
→ git remote add mislav git://github.com/mislav/hub.git
→ git remote add cehoffman git://github.com/cehoffman/hub.git
→ git fetch --multiple mislav cehoffman

# check out a pull request for review
#查看拉取审查请求
$ git checkout https://github.com/github/hub/pull/134
→ (creates a new branch with the contents of the pull request)

# directly apply all commits from a pull request to the current branch
#直接将拉取请求中的所有提交应用于当前分支
$ git am -3 https://github.com/github/hub/pull/134

# cherry-pick a GitHub URL
#cherry-pick a GitHub URL
$ git cherry-pick https://github.com/xoebus/hub/commit/177eeb8
→ git remote add xoebus git://github.com/xoebus/hub.git
→ git fetch xoebus
→ git cherry-pick 177eeb8

# `am` can be better than cherry-pick since it doesn't create a remote
#`am`可能比cherry-pick更好，因为它不会创建一个遥控器
$ git am https://github.com/xoebus/hub/commit/177eeb8

# open the GitHub compare view between two releases
#打开两个版本之间的GitHub比较视图
$ git compare v0.9..v1.0

# put compare URL for a topic branch to clipboard
#将主题分支的比较URL放到剪贴板中
$ git compare -u feature | pbcopy

# create a repo for a new project
#为新项目创建一个仓库
$ git init
$ git add . && git commit -m "It begins."
$ git create -d "My new thing"
→ (creates a new project on GitHub with the name of current directory)
$ git push origin master
