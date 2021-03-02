# title{dir - 一些目录相关的常用操作}

```bash

#!/bin/bash
#
while true; do
 	read -p "Enter a directory: " dirName
	[ "$dirName" == 'quit' ] && exit 3
 	[ -d "$dirName" ] && break || echo "Wrong directory..."
done

# echo "Correct..."

for fileName in $dirName/*; do
	if [[ "$fileName" =~ .*[[:upper:]]{1,}.* ]]; then
		echo "$fileName"
	fi
done


for DirName in /tmp/1.dir /tmp/2.dir /tmp/3.dir; do
  mkdir $DirName
  chmod 750 $DirName
done


#!/bin/bash

for DirName in /tmp/1.dir /tmp/2.dir /tmp/3.dir; do
  mkdir $DirName
  chmod 750 $DirName
done


dstDir=/tmp/dir-$(date +%Y%m%d-%H%M%S)

mkdir $dstDir

for i in {1..10}; do
    touch $dstDir/file$i
done

```