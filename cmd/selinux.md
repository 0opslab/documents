# title{selinux - 安全增强型 Linux（Security-Enhanced Linux）简称 SELinux，它是一个 Linux 内核模块，也是 Linux 的一个安全子系统。}
## 简单的管理selinux

```bash
sestatus -v                    # 查看selinux状态
getenforce                     # 查看selinux模式
setenforce 0                   # 设置selinux为宽容模式(可避免阻止一些操作)
semanage port -l    # 查看selinux端口限制规则
semanage port -a -t http_port_t -p tcp 8000  # 在selinux中注册端口类型
vi /etc/selinux/config         # selinux配置文件
SELINUX=enfoceing              # 关闭selinux 把其修改为  SELINUX=disabled
```