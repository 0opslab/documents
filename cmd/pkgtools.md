# title{pkgtools - }

```bash
# Create a Slackware package from a structured directory and sub-tree
#从结构化目录和子树创建Slackware包
$ cd /path/to/pkg/dir
$ su - c 'makepkg --linkadd y --chown n $foo-1.0.3-x86_64-1_tag.tgz'


# Install a Slackware package
#安装Slackware软件包
installpkg foo-1.0.3-x86_64-1.tgz

# Install a Slackware package to non-standard location
#将Slackware软件包安装到非标准位置
ROOT=/path/to/dir installpkg foo-1.0.4-noarch-1.tgz

# Create backup of files that will be overwritten when installing
#创建安装时将覆盖的文件备份
tar czvf /tmp/backup.tar.gz $(installpkg --warn foo-1.0.4-noarch-1.tgz)


# Upgrade a Slackware package including files only in new version
#升级Slackware软件包，包括仅在新版本中的文件
upgradepkg --install-new foo-1.0.6-noarch-1.tgz

# Upgrade a Slackware package even if version is the same
#即使版本相同，也要升级Slackware软件包
upgradepkg --reinstall foo-1.0.4-noarch-1.tgz


# Remove a Slackware package
#删除Slackware包
removepkg foo-0.2.8-x86_64-1

# Remove a Slackware package, retaining a backup (uninstalled) copy
#删除Slackware软件包，保留备份（卸载）副本
removepkg -copy foo-0.2.8-x86_64-1  # -> /var/log/setup/tmp/preserved_packages/foo...

```

