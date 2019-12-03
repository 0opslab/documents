# To search for apt packages:
#要搜索apt包：
apt-cache search "whatever"

# To display package records for the named package(s):
#要显示命名包的包记录：
apt-cache show pkg(s)

# To display reverse dependencies of a package
#显示包的反向依赖关系
apt-cache rdepends package_name

# To display package versions, reverse dependencies and forward dependencies 
#显示包版本，反向依赖关系和转发依赖关系
# of a package
#一个包
apt-cache showpkg package_name
