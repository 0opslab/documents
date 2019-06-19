# For the sake of briefness, we use Bash  "group compound" stanza:
#为简洁起见，我们使用Bash“group compound”节：
#   /dev/sd{a,b,...}1 => /dev/sda1 /dev/sdb1 ...
#/dev/sd{a,b,...}1 => / dev / sda1 / dev / sdb1 ...
# Along the following variables:
#沿着以下变量：
#   ${M} array identifier (/dev/md${M})
#$ {M}数组标识符（/ dev / md $ {M}）
#   ${D} device identifier (/dev/sd${D})
#$ {D}设备标识符（/ dev / sd $ {D}）
#   ${P} partition identifier (/dev/sd${D}${P})
#$ {P}分区标识符（/ dev / sd $ {D} $ {P}）

# Create (initialize) a new array
#创建（初始化）一个新数组
mdadm --create /dev/md${M} --level=raid5 --raid-devices=4 /dev/sd{a,b,c,d,e}${P} --spare-devices=/dev/sdf1

# Manually assemble (activate) an existing array
#手动组装（激活）现有阵列
mdadm --assemble /dev/md${M} /dev/sd{a,b,c,d,e}${P}

# Automatically assemble (activate) all existing arrays
#自动组装（激活）所有现有阵列
mdadm --assemble --scan

# Stop an assembled (active) array
#停止组装（活动）阵列
mdadm --stop /dev/md${M}

# See array configuration
#请参阅阵列配置
mdadm --query /dev/md${M}

# See array component configuration (dump superblock content)
#请参阅阵列组件配置（转储超级块内容）
mdadm --query --examine /dev/sd${D}${P}

# See detailed array confiration/status
#查看详细的阵列配置/状态
mdadm --detail /dev/md${M}

# Save existing arrays configuration
#保存现有阵列配置
# (MAY be required by initrd for successfull boot)
#（initrd可能需要成功启动）
mdadm --detail --scan > /etc/mdadm/mdadm.conf

# Erase array component superblock
#擦除数组组件超级块
# (MUST do before reusing a partition for other purposes)
#（必须在重用分区用于其他目的之前）
mdadm --zero-superblock /dev/sd${D}${P}

# Manually mark a component as failed
#手动将组件标记为失败
# (SHOULD when a device shows wear-and-tear signs, e.g. through SMART)
#（当设备显示磨损迹象时，例如通过SMART）
mdadm --manage /dev/md${M} --fail /dev/sd${D}${P}

# Remove a failed component
#删除发生故障的组件
# (SHOULD before preemptively replacing a device, after failing it)
#（应该在抢先更换设备之前，在失败之后）
mdadm --manage /dev/md${M} --remove /dev/sd${D}${P}

# Prepare (format) a new device to replace a failed one
#准备（格式化）新设备以替换发生故障的设备
sfdisk -d /dev/sd${D,sane} | sfdisk /dev/sd${D,new}

# Add new component to an existing array
#将新组件添加到现有阵列
# (this will trigger the rebuild)
#（这将触发重建）
mdadm --manage /dev/md${M} --add /dev/sd${D,new}${P}

# See assembled (active) arrays status
#请参阅组装（活动）阵列状态
cat /proc/mdstat

# Rename a device
#重命名设备
# (SHOULD after hostname change; eg. name="$(hostname -s)")
#（主机名更改后应该出现;例如：name =“$（hostname -s）”）
mdadm --assemble /dev/md${M} /dev/sd{a,b,c,d,e}${P} --name="${name}:${M}" --update=name

