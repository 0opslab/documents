# List all loaded/active units
#列出所有已加载/活动单位
systemctl list-units

# Check the status of a service
#检查服务的状态
systemctl status foo.service

# Start a service
#开始服务
systemctl start foo.service

# Restart a service
#重启服务
systemctl restart foo.service

# Stop a service
#停止服务
systemctl stop foo.service

# Reload a service's configuration
#重新加载服务的配置
systemctl reload foo.service

# Enable a service to startup on boot
#启用服务以在启动时启动
systemctl enable foo.service

# Disable a service to startup on boot
#禁用服务以在启动时启动
systemctl disable foo.service

# List the dependencies of a service
#列出服务的依赖项
# when no service name is specified, lists the dependencies of default.target
#如果未指定服务名称，则列出default.target的依赖项
systemctl list-dependencies foo.service 

# List currently loaded targets
#列出当前加载的目标
systemctl list-units --type=target

# Change current target
#改变目前的目标
systemctl isolate foo.target

# Change default target
#更改默认目标
systemctl enable foo.target
