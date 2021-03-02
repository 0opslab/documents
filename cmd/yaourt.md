# title{yaourt - archlinux下的一款的包管理工具}

```bash
# All pacman commands are working the same way with yaourt.
#所有pacman命令与yaourt的工作方式相同。
# Just check the pacman cheatsheet.
#只需检查pacman cheatsheet。
# For instance, to install a package : 
#例如，要安装包：
pacman -S <package name>
yaourt -S <package name>
# The difference is that yaourt will also query the Arch User Repository,
#区别在于yaourt还会查询Arch User Repository，
# and if appropriate, donwload the source and build the package requested.
#并在适当的情况下，下载源并构建所请求的包。

# Here are the commands yaourt provides while pacman doesn't :
#以下是yaourt提供的命令，而pacman没有：

# To search for a package and install it
#搜索包并安装它
yaourt <package name>

# To update the local package base and upgrade all out of date package, including the ones from 
#更新本地程序包库并升级所有过时的程序包，包括来自的程序包
AUR and the packages based on development repos (git, svn, hg...)
yaourt -Suya --devel

# For all of the above commands, if you want yaourt to stop asking constantly for confirmations, 
#对于以上所有命令，如果您希望yaourt不再要求确认，
use the option --noconfirm

# To build a package from source
#从源代码构建包
yaourt -Sb <package name>

```
