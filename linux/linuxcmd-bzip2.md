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
