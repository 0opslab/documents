# title{snap - 一种新的软件打包格式，彻底解决linux依赖性的问题，Snap 软件包拥有更加稳定和安全的特性。snap也就是安装snap软件包的命令}

```bash
# To find the `foo` snap:
#要找到`foo` snap：
snap find foo

# To view detailed information about snap `foo`:
#要查看关于snap`food`的详细信息：
snap info foo

# To view all private snaps (must be logged in):
#要查看所有私人快照（必须登录）：
snap find --private

# To install the `foo` snap:
#要安装`foo` snap：
sudo snap install foo

# To install the `foo` snap from the "beta" channel:
#要从“beta”频道安装`foo`按钮：
sudo snap install foo --channel=beta

# To view installed snaps:
#要查看已安装的快照：
snap list

# To list all revisions of installed snaps:
#列出已安装快照的所有修订：
snap list --all

# To (manually) update all snaps:
#要（手动）更新所有快照：
sudo snap refresh

# To (manually) update the `foo` snap:
#要（手动）更新`foo`按钮：
sudo snap refresh foo

# To update the `foo` snap to the "beta" channel:
#要更新`foo`对齐“beta”频道：
sudo snap refresh foo --channel=beta

# To revert the `foo` snap to a prior version:
#要将`foo` snap恢复为先前版本：
sudo snap revert foo

# To revert the `foo` snap to revision 5:
#要将`foo` snap恢复为修订版5：
snap revert foo --revision 5

# To remove the `foo` snap:
#删除`foo` snap：
sudo snap remove foo

# To log in to snap (must first create account online):
#登录到快照（必须先在线创建帐户）：
sudo snap login

# To log out of snap:
#要注销快照：
snap logout

# To view a transaction log summary:
#要查看事务日志摘要：
snap changes

# To view details of item 123 in the transaction log:
#要查看事务日志中项目123的详细信息：
snap change 123

# To watch transaction 123:
#观看交易123：
snap watch 123

# To abort transaction 123:
#要中止交易123：
snap abort 123

# To download the `foo` snap (and its assertions) *without* installing it:
#要下载`foo` snap（及其断言）*而不安装它：
snap download foo

# To install the locally-downloaded `foo` snap with assertions:
#使用断言安装本地下载的`foo` snap：
snap ack foo.assert
snap install foo.snap

# To install the locally-downloaded `foo` snap without assertions:
#要在没有断言的情况下安装本地下载的`foo` snap：
# NB: this is dangerous, because the integrity of the snap will not be
#注意：这很危险，因为快照的完整性不会
# verified. You should only do this to test a snap that you are currently
#验证。您应该只执行此操作来测试您当前的快照
# developing.
#发展。
snap install --dangerous foo.snap

# To install snap `foo` in "dev mode":
#要在“开发模式”下安装snap`foo`：
# NB: this is dangerous, and bypasses the snap sandboxing mechanisms
#注意：这很危险，并绕过了快照沙箱机制
snap install --devmode foo

# To install snap `foo` in "classic mode":
#要在“经典模式”下安装snap`foo`：
# NB: this is likewise dangerous
#注意：这同样很危险
snap install --classic foo

# To view available snap interfaces:
#要查看可用的捕捉接口：
snap interfaces

# To connect the `foo:camera` plug to the ubuntu core slot:
#要将`foo：camera`插头连接到ubuntu核心插槽：
snap connect foo:camera :camera

# To disconnect the `foo:camera` plug from the ubuntu core slot:
#从ubuntu核心插槽断开`foo：camera`插头：
snap disconnect foo:camera

# To disable the `foo` snap
#要禁用`foo`快照
snap disable foo

# To enable the `foo` snap
#启用`foo` snap
snap enable foo

# To set snap `foo`'s `bar` property to 10:
#将snap`foo`的`bar`属性设置为10：
snap set foo bar=10

# To read snap `foo`'s current `bar` property:
#要阅读snap`foo`的当前`bar`属性：
snap get foo bar
```
