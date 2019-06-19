# Split a file based on pattern
#根据模式拆分文件
csplit input.file '/PATTERN/'

# Use prefix/suffix to improve resulting file names
#使用前缀/后缀来改进生成的文件名
csplit -f 'prefix-' -b '%d.extension' input.file '/PATTERN/' '{*}'
