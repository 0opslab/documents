## 常用命令

```bash
# 从公网拉取一个镜像
docker pull images_name

# 查看已有的docker镜像
docker images

# 查看帮助
docker command --help

# 启动一个容器
docker run hello-world

# 导出镜像
docker save -o image_name.tar image_name

# 删除镜像
docker rim image_name

# 启动一个容器并进入该容器
docker run -it --name=con_name images

# 创建一个容器，放入后台运行，把物理机80端口映射到容器的80端口
# -p 参数说明
#-p hostPort:containerPort
#-p ip:hostPort:containerPort
#-p ip::containerPort
#-p hostPort:containerPort:udp
docker run -d -p 81:80 image_name

# 看容器的端口映射情况
docker port con_id

# 查看正在运行的容器
docker ps

# 查看所有的容器
docker ps -a

# 动态查看容器日志
docker logs -f con_name

# 进入容器
docker attach con_name

# 退出容器
exit
#一起按，注意顺序，退出后容器依然保持启动状态
ctrl+p && ctrl+q ()


# 删除容器
# 强制删除需要加-f，不加-f不能删除正在运行中的容器，非常危险，最好不用
docker rm  con_name

#查看docker网络
docker network ls
```