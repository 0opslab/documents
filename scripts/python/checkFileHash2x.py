#!/usr/bin/python
# -*- coding: utf-8 -*-

import getopt
import hashlib
import sys, os
import time

#func{基于python2的文件hash变化检查脚本}

_FILE_SLIM = 100 * 1024 * 1024
# opts, args = getopt.getopt(sys.argv[1:], "i:o:")
#
# fileInPath = ""
# fileOutPath = ""
# for op, value in opts:
#     if op == "-i":
#         fileInPath = value
#     elif op == "-o":
#         fileOutPath = value
#
# if fileInPath == "":
#     print "输入目录为空，程序结束"
#     os._exit(0)
#
# if fileOutPath == "":
#     fileOutPath = "./result_file.txt"
fileInPath = "/webapp07/nfs/sec_lqlog/69_file_hash_.log"
filePaths = ['/webapp01/www/ydb3', '/webapp02/qhwebapps/qhmcc_client9681', '/webapp02/qhwebapps/qhmcc_client9682',
             '/webapp02/qhwebapps/qhmcc_manager', '/webapp02/qhwebapps/qhmcc_manager9882',
             '/webapp02/qhwebapps/qhmcc_wap9781', '/webapp02/qhwebapps/qhmcc_wap9782', '/webapp02/webapps']
# filePaths = ["/webapp01/www/ydb3/qhmccClientWap/2018/gg/images"]
nowTime = time.strftime("%Y%m%d_%H%M%S", time.localtime())
fileOutPath = "/webapp07/nfs/sec_lqlog/69_check_hash_" + nowTime + ".log"


def File_md5(filename):
    calltimes = 0  # 分片的个数
    hmd5 = hashlib.md5()
    fp = open(filename, "rb")
    f_size = os.stat(filename).st_size  # 得到文件的大小
    result = ""
    if f_size > _FILE_SLIM:
        while (f_size > _FILE_SLIM):
            hmd5.update(fp.read(_FILE_SLIM))
            f_size /= _FILE_SLIM
            calltimes += 1  # delete    #文件大于100M时进行分片处理
        if (f_size > 0) and (f_size <= _FILE_SLIM):
            hmd5.update(fp.read())
    else:
        hmd5.update(fp.read())

    # result = str(hmd5.hexdigest())
    return str(hmd5.hexdigest())


def wirter(file_and_hash):
    # 写文件
    with open(fileOutPath, 'a') as f:
        f.write(file_and_hash + '\n');


# for fpathe, dirs, fs in os.walk(fileInPath):
#     for f in fs:
#         file_hash = File_md5(os.path.join(fpathe, f))
#
#         print file_is_hash
#         wirter(file_is_hash)
wirter("");
one_list = []
two_list = []
with open(fileInPath) as f:
    for line in f:
        one_list.append(line.replace("\n", ""))

for dir in filePaths:
    print "开始计算=========>" + dir
    for fpathe, dirs, fs in os.walk(dir):
        for f in fs:
            try:
                file_hash = File_md5(os.path.join(fpathe, f))
                file_is_hash = os.path.join(fpathe, f) + "|" + file_hash
                two_list.append(file_is_hash)
            except Exception as e:
                pass

difference_one = [v for v in one_list if v not in two_list]
difference_two = [v for v in two_list if v not in one_list]
for one in difference_one:
    nowTime = time.strftime("%Y%m%d_%H%M%S", time.localtime())
    wirter(one + "|" + nowTime+"|文件被删除");
for two in difference_two:
    nowTime = time.strftime("%Y%m%d_%H%M%S", time.localtime())
    wirter(two + "|" + nowTime + "|新增文件");
print "69_SUCCESS"
