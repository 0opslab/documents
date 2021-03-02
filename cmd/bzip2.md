# title{bzip2 - bzip2命令是.bz2文件的压缩程序}

语法
bzip2 [-cdfhkLstvVz][--repetitive-best][--repetitive-fast][- 压缩等级][要压缩的文件]
参数：

-c或--stdout 　将压缩与解压缩的结果送到标准输出。
-d或--decompress 　执行解压缩。
-f或--force 　bzip2在压缩或解压缩时，若输出文件与现有文件同名，预设不会覆盖现有文件。若要覆盖，请使用此参数。
-h或--help 　显示帮助。
-k或--keep 　bzip2在压缩或解压缩后，会删除原始的文件。若要保留原始文件，请使用此参数。
-s或--small 　降低程序执行时内存的使用量。
-t或--test 　测试.bz2压缩文件的完整性。
-v或--verbose 　压缩或解压缩文件时，显示详细的信息。
-z或--compress 　强制执行压缩。
-L,--license,
-V或--version 　显示版本信息。
--repetitive-best 　若文件中有重复出现的资料时，可利用此参数提高压缩效果。
--repetitive-fast 　若文件中有重复出现的资料时，可利用此参数加快执行速度。
-压缩等级 　压缩时的区块大小。


```bash
# compress foo -> foo.bz2
#压缩foo  - > foo.bz2
bzip2 -z foo

# decompress foo.bz2 -> foo
#解压缩foo.bz2  - > foo
bzip2 -d foo.bz2

# compress foo to stdout
#压缩foo到stdout
bzip2 -zc foo > foo.bz2

# decompress foo.bz2 to stdout
#将foo.bz2解压缩到stdout
bzip2 -dc foo.bz2
```