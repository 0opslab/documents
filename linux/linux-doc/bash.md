# To implement a for loop:
#要实现for循环：
for file in *;
do 
    echo $file found;
done

# To implement a case command:
#要实现case命令：
case "$1"
in
    0) echo "zero found";;
    1) echo "one found";;
    2) echo "two found";;
    3*) echo "something beginning with 3 found";;
esac

# Turn on debugging:
#打开调试：
set -x

# Turn off debugging:
#关闭调试：
set +x

# Retrieve N-th piped command exit status
#检索第N个管道命令退出状态
printf 'foo' | fgrep 'foo' | sed 's/foo/bar/'
echo ${PIPESTATUS[0]}  # replace 0 with N

# Lock file:
#锁定文件：
( set -o noclobber; echo > my.lock ) || echo 'Failed to create lock file'
