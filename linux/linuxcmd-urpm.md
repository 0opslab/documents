# search (fuzzy) for package foo
#搜索（模糊）包foo
urpmq -Y foo

# check if foo is installed
#检查是否安装了foo
rpm -q foo

# install package foo
#安装包foo
urpmi foo

# download but don't install foo
#下载但不要安装foo
urpmi --no-install foo

# uninstall package foo
#卸载包foo
urpme foo
