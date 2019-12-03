# Sync to newest SlackBuild.org tree
#同步到最新的SlackBuild.org树
sport r

# Search (fuzzy) SlackBuild tree for packages foo and BaR
#搜索（模糊）SlackBuild树，用于包foo和BaR
sport s foo bar

# Operate from alternate build tree
#从备用构建树操作
SBOPATH=/path/to/tree sport s foo

# View info and README of BaR (not fuzzy)
#查看BaR的信息和自述文件（不模糊）
sport c foo BaR

# Build a package
#建立一个包
sport i --build-only foo

# Build and install package foo and BaR
#构建并安装包foo和BaR
sport i foo BaR

# Build and install package from current directory
#从当前目录构建和安装包
sport i .

# Upgrade instead of install
#升级而不是安装
INSTALLER=upgradepkg sport i foo

# Build dependency list for baz
#为baz构建依赖列表
echo "foo BaR" >> /tmp/baz.list

# Install list of packages from file
#从文件安装包列表
sport i $(< /tmp/baz.list)

# Check if package is installed
#检查是否已安装包
sport k foo
