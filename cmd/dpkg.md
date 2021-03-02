# title{dpkg - 是Debian Linux系统用来安装、创建和管理软件包的实用工具}


### 常用参数
```bash
-i：安装软件包；
-r：删除软件包；
-P：删除软件包的同时删除其配置文件；
-L：显示于软件包关联的文件；
-l：显示已安装软件包列表；
--unpack：解开软件包；
-c：显示软件包内文件列表；
--confiugre：配置软件包。
```

### 常用命令
```bash
#安装包
dpkg -i package.deb
#删除包
dpkg -r package
#删除包（包括配置文件）
dpkg -P package
#列出与该包关联的文件
dpkg -L package
#显示该包的版本
dpkg -l package
#解开deb包的内容
dpkg --unpack package.deb  
#搜索所属的包内容
dpkg -S keyword            
#列出当前已安装的包
dpkg -l                    
#列出deb包的内容
dpkg -c package.deb        
#配置包
dpkg --configure package   
# List all installed packages with versions and details
#列出所有已安装的软件包及版本和详细信
dpkg -I
# Find out if a Debian package is installed or not
#了解是否安装了Debian软件包
dpkg -s test.deb | grep Status

```