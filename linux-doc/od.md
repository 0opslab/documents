# Dump file in octal format
#以八进制格式转储文件
od /path/to/binaryfile
od -o /path/to/binaryfile
od -t o2 /path/to/binaryfile

# Dump file in hexadecimal format
#以十六进制格式转储文件
od -x /path/to/binaryfile
od -t x2 /path/to/binaryfile

# Dump file in hexadecimal format, with hexadecimal offsets and a space between each byte
#以十六进制格式转储文件，具有十六进制偏移量和每个字节之间的空格
od -A x -t x1 /path/to/binaryfile
