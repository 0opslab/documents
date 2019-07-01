---
title: Python根据文件HASH查找重复文件
date: 2018-01-24 20:54:32
tags: Python
categories: Python
---

虽然当前存储和内存都不值钱，但是需要查找重复文件的小需求。这里使用Python根据文件HASH查找重复的文件。

```python
#! /usr/bin/python
# coding=UTF-8
# version:python3.x
import hashlib
import optparse
import os

"""根据文件hash查找指定目录下的重复文件"""


def hash_file(fine_name, type="sha256", block_size=64 * 1024):
    """ Support md5(), sha1(), sha224(), sha256(), sha384(), sha512(),
    blake2b(), blake2s(),sha3_224, sha3_256, sha3_384, sha3_512,
    shake_128, and shake_256
    """
    with open(fine_name, 'rb') as file:
        hash = hashlib.new(type, b"")
        while True:
            data = file.read(block_size)
            if not data:
                break
            hash.update(data)
        return hash.hexdigest()


if __name__ == '__main__':
    usage = "*.py [ -d <path>]"
    parser = optparse.OptionParser()
    parser.add_option('-d', '--dir', dest="path", help="handle path", metavar="FILE")
    (options, args) = parser.parse_args()
    if options.path:
        hash_map = []
        for root, dirs, files in os.walk(options.path):
            for file in files:
                file_name = os.path.join(root, file)
                # file_hash = get_hash(file_name)
                file_hash = hash_file(file_name, "md5")
                info = {'file': file_name, 'hash': file_hash}
                hash_map.append(info)

        result = {}
        for item in hash_map:
            for it in hash_map:
                if it['hash'] == item['hash'] and it['file'] != item['file']:
                    result[it['hash']] = "{" + it['file'] + "," + item['file'] + "}"

        for (k, v) in result.items():
            print(k, "\t", v.replace("\\","/"))
    else:
        print(parser.print_help())

```

