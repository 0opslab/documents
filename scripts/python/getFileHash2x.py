#!usr/bin/python
# -*- coding: utf-8 -*-

import getopt
import hashlib
import sys, os

#func{基于python2的获取文件hash的脚本}

# # fileInPath = ""
_FILE_SLIM = 100 * 1024 * 1024

filePaths = ['/webapp01/www/ydb3', '/webapp02/qhwebapps/qhmcc_client9681', '/webapp02/qhwebapps/qhmcc_client9682',
             '/webapp02/qhwebapps/qhmcc_manager', '/webapp02/qhwebapps/qhmcc_manager9882',
             '/webapp02/qhwebapps/qhmcc_wap9781', '/webapp02/qhwebapps/qhmcc_wap9782', '/webapp02/webapps']

# if fileOutPath == "":
#     fileOutPath = "/webapp07/nfs/sec_lqlog/68_check_hash"++".log"
fileOutPath = "/webapp07/nfs/sec_lqlog/69_file_hash_.log"


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
    return str(hmd5.hexdigest())


def wirter(file_and_hash):
    # 写文件
    with open(fileOutPath, 'a') as f:
        f.write(file_and_hash + '\n');


for dir in filePaths:
    print "开始计算=========>" + dir
    for fpathe, dirs, fs in os.walk(dir):
        for f in fs:
            try:
                file_hash = File_md5(os.path.join(fpathe, f))
                file_is_hash = os.path.join(fpathe, f) + "|" + file_hash
                print file_is_hash
                wirter(file_is_hash)
            except Exception as e:
                pass

print "69_SUCCESS"
