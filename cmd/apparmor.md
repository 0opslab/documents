# title{apparmor - Apparmor将通过将程序限制在一组有限的资源来保护系统}

```bash
# Desc: 
#描述：

# To activate a profile:
#要激活配置文件：
sudo aa-enforce usr.bin.firefox
# OR
#要么
export _PROFILE_='usr.bin.firefox' sudo $(rm /etc/apparmor.d/disable/$_PROFILE_ ; cat /etc/apparmor.d/$_PROFILE_ | apparmor_parser -a )

# TO disable a profile:
#要禁用个人资料：
sudo aa-disable usr.bin.firefox
# OR
#要么
export _PROFILE_='usr.bin.firefox' sudo $(ln -s /etc/apparmor.d/$_PROFILE_ /etc/apparmor.d/disable/ && apparmor_parser -R /etc/apparmor.d/$_PROFILE_)

# To list profiles loaded:
#列出加载的配置文件：
sudo aa-status
# OR
#要么
sudo apparmor_status

# List of profiles aviables: /etc/apparmor.d/
#配置文件列表aviables：/etc/apparmor.d/
```