#!/bin/bash
#

ssh-keygen -t rsa -b 2048 -N "" -f $HOME/.ssh/id_rsa

cat $HOME/.ssh/id_rsa.pub >$HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

## install.config
#10.3.151.61 nginx,appt,rabbitmq,kafka,zk,es,bkdata,consul,fta
#10.3.151.62 mongodb,appo,kafka,zk,es,mysql,beanstalk,consul
#10.3.151.63 paas,cmdb,job,gse,license,kafka,zk,es,redis,consul

for ip in $(awk '{print $1}' install.config); do
    rsync -av -e 'ssh -o StrictHostKeyChecking=no' $HOME/.ssh/authorized_keys root@$ip:$HOME/.ssh/
done
