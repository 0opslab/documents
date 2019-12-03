# INSTALL
#安装
# ==============================================================================
#==============================================================================
# Edit /etc/default/distcc and set theses vars
#编辑/ etc / default / distcc并设置这些变量
# STARTDISTCC="true"
#STARTDISTCC = “真”
# ALLOWEDNETS="127.0.0.1 192.168.1.0/24"# Your computer and local computers
#ALLOWEDNETS =“127.0.0.1 192.168.1.0/24”您的计算机和本地计算机
# #LISTENER="127.0.0.1"# Comment it
#LISTENER =“127.0.0.1”评论它
# ZEROCONF="true"# Auto configuration
#ZEROCONF =“true”自动配置

# REMEMBER 1:
#记住1：
# Start/Restart your distccd servers before using one of these commands.
#在使用其中一个命令之前，启动/重新启动distccd服务器。
# service distccd start
#服务distccd开始

# REMEMBER 2:
#记住2：
# Do not forget to install on each machine DISTCC.
#不要忘记在每台机器DISTCC上安装。
# No need to install libs ! Only main host need libs !
#无需安装库！只有主要主机需要库！

# USAGE
#用法
# ==============================================================================
#==============================================================================

# Run make with 4 thread (a cross network) in auto configuration.
#在自动配置中使用4个线程（交叉网络）运行make。
# Note: for gcc, Replace CXX by CC and g++ by gcc
#注意：对于gcc，用CC替换CXX，用gcc替换g ++
ZEROCONF='+zeroconf' make -j4 CXX='distcc g++'

# Run make with 4 thread (a cross network) in static configuration (2 ip)
#在静态配置中使用4线程（交叉网络）运行make（2 ip）
# Note: for gcc, Replace CXX by CC and g++ by gcc
#注意：对于gcc，用CC替换CXX，用gcc替换g ++
DISTCC_HOSTS='127.0.0.1 192.168.1.69' make -j4 CXX='distcc g++'

# Show hosts aviables
#显示主机aviables
ZEROCONF='+zeroconf' distcc --show-hosts
