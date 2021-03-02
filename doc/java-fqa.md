# title{java-fqa - java相关的那些问题出来}
## 线上服务CPU100%问题快速定位

步骤一 ：找到最耗CPU的进程

步骤二：找到最耗CPU的线程

步骤三：将线程PID转化为16进制

步骤四：查看堆栈，找到线程在干嘛

```bash
# 执行top -c ，显示进程运行信息列表，键入P (大写p)，进程按照CPU使用率排序
top
# 找到进程中最耗CPU的线程
# 显示一个进程的线程运行信息列表键入P (大写p)，线程按照CPU使用率排序
top -Hp 10765 

#将线程PID转化为16进制
printf “%x\n” 10804

#查看指定进程中线程的内容
jstack 10765 | grep ‘0x2a34’ -C5 --color
```

## 线上Java服务出现OOM问题排查

产生OutOfMemoryError错误的原因包括

​	

1. java.lang.OutOfMemoryError: Java heap space(表示Java堆空间不够)
2. java.lang.OutOfMemoryError: PermGen space(表示Java永久带（方法区）空间不够)
3. java.lang.OutOfMemoryError: unable to create new native thread(创建了太多的线程)
4. java.lang.OutOfMemoryError：GC overhead limit exceeded

步骤一：查看相应进程的内存区分分配

```bash
# 对各个区域的内存使用量评估 有些内存区域可能真的过小，根据JVM参数进行调整
jmap -heap 1223
```

步骤二： 查看最吃内存的对象

```bash
# 根据实际情况进行分析，一遍解决问题
jmap -histo:live 10765 | more
```

