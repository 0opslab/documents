# To extract an uncompressed archive:
#要提取未压缩的存档：
tar -xvf /path/to/foo.tar

# To create an uncompressed archive:
#要创建未压缩的存档：
tar -cvf /path/to/foo.tar /path/to/foo/

# To extract a .gz archive:
#要提取.gz存档：
tar -xzvf /path/to/foo.tgz

# To create a .gz archive:
#要创建.gz存档：
tar -czvf /path/to/foo.tgz /path/to/foo/

# To list the content of an .gz archive:
#列出.gz存档的内容：
tar -ztvf /path/to/foo.tgz

# To extract a .bz2 archive:
#要提取.bz2存档：
tar -xjvf /path/to/foo.tgz

# To create a .bz2 archive:
#要创建.bz2存档：
tar -cjvf /path/to/foo.tgz /path/to/foo/

# To extract a .tar in specified Directory:
#要在指定目录中提取.tar：
tar -xvf /path/to/foo.tar -C /path/to/destination/

# To list the content of an .bz2 archive:
#列出.bz2存档的内容：
tar -jtvf /path/to/foo.tgz

# To create a .gz archive and exclude all jpg,gif,... from the tgz
#要创建.gz存档并从tgz中排除所有jpg，gif，....
tar czvf /path/to/foo.tgz --exclude=\*.{jpg,gif,png,wmv,flv,tar.gz,zip} /path/to/foo/

# To use parallel (multi-threaded) implementation of compression algorithms:
#要使用压缩算法的并行（多线程）实现：
tar -z ... -> tar -Ipigz ...
tar -j ... -> tar -Ipbzip2 ...
tar -J ... -> tar -Ipixz ...
