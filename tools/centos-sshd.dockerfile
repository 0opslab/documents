## https://www.jianshu.com/p/540407aeb55b
FROM centos:centos7
MAINTAINER 简书：Rethink "https://www.jianshu.com/u/425d52eec5fa" "shijianzhihu@foxmail.com"

RUN yum install openssh-server -y 

#修改root用户密码
#用以下命令修改密码时，密码中最好不要包含特殊字符，如"!"，否则可能会失败；
RUN /bin/echo "rethink123" | passwd --stdin root

#生成密钥
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_ecdsa_key \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_ed25519_key

#修改配置信息
RUN /bin/sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd \
    && /bin/sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config \
    && /bin/sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config


EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]