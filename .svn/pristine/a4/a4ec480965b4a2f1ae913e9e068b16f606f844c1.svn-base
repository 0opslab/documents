# To list VMs on current tenant:
#要列出当前租户上的VM：
nova list

# To list VMs of all tenants (admin user only):
#列出所有租户的虚拟机（仅限管理员用户）：
nova list --all-tenants

# To boot a VM on a specific host:
#要在特定主机上引导VM：
nova boot --nic net-id=<net_id> \
          --image <image_id> \
          --flavor <flavor> \
          --availability-zone nova:<host_name> <vm_name>

# To stop a server
#停止服务器
nova stop <server>

# To start a server
#启动服务器
nova start <server>

# To attach a network interface to a specific VM:
#要将网络接口连接到特定VM：
nova interface-attach --net-id <net_id> <server>
