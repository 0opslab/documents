# title{vagrant - }

```bash
# Initate Vagrant
#启动流浪汉
mkdir vag-vm; cd vag-vm
vagrant init

# Add a box to vagrant repo
#为流浪者回购添加一个盒子
vagrant box add hashicorp/precise32

# Add a box  Vagrant file
#添加一个Vagrant文​​件框
config.vm.box = "hashicorp/precise32"

# Add vm to public network as host
#将vm添加到公共网络作为主机
config.vm.network "public_network"

# Add provision script to vagrant file
#将配置脚本添加到vagrant文​​件
config.vm.provision :shell, path: "provision.sh"

# Start vm 
#启动vm
vagrant up

# Connect to started instance
#连接到已启动的实例
vagrant ssh

# Shutdown vm
#关机vm
vagrant halt

# Hibernate vm
#Hibernate vm
vagrant suspend

# Set vm to initial state by cleaning all data
#通过清除所有数据将vm设置为初始状态
vagrant destroy

# Restart vm with new provision script
#使用新配置脚本重新启动vm
vagran reload --provision
```

