# title{su - su命令用于变更为其他使用者的身份，除 root 外，需要键入该使用者的密码}

### 选项
```bash
-f 或 –fast 不必读启动档（如 csh.cshrc 等），仅用于 csh 或 tcsh
-m -p 或 –preserve-environment 执行 su 时不改变环境变数
-c command 或 –command=command 变更为帐号为 USER 的使用者并执行指令（command）后再变回原来使用者
-s shell 或 –shell=shell 指定要执行的 shell （bash csh tcsh 等），预设值为 /etc/passwd 内的该使用者（USER） shell
–help 显示说明文件
–version 显示版本资讯
– -l 或 –login 这个参数加了之后，就好像是重新 login 为该使用者一样，大部份环境变数（HOME SHELL USER等等）
  都是以该使用者（USER）为主，并且工作目录也会改变，如果没有指定 USER ，内定是 root
USER 欲变更的使用者帐号
ARG 传入新的 shell 参数
```

### 常用命令
```bash
# Switch to another user account
#切换到另一个用户帐户
su USERNAME
```