# A plain old glob
#一个普通的老水珠
print -l *.txt
print -l **/*.txt

# Show text files that end in a number from 1 to 10
#显示以1到10的数字结尾的文本文件
print -l **/*<1-10>.txt

# Show text files that start with the letter a
#显示以字母a开头的文本文件
print -l **/[a]*.txt

# Show text files that start with either ab or bc
#显示以ab或bc开头的文本文件
print -l **/(ab|bc)*.txt

# Show text files that don't start with a lower or uppercase c
#显示不以小写或大写c开头的文本文件
print -l **/[^cC]*.txt

# Show only directories
#仅显示目录
print -l **/*(/)

# Show only regular files
#仅显示常规文件
print -l **/*(.)

# Show empty files
#显示空文件
print -l **/*(L0)

# Show files greater than 3 KB
#显示大于3 KB的文件
print -l **/*(Lk+3)

# Show files modified in the last hour
#显示过去一小时内修改的文件
print -l **/*(mh-1)

# Sort files from most to least recently modified and show the last 3
#从最近到最近修改过的文件排序并显示最后3个
print -l **/*(om[1,3])

# `.` show files, `Lm-2` smaller than 2MB, `mh-1` modified in last hour,
#`.`显示文件，`Lm-2`小于2MB，在最后一小时修改了`mh-1`，
# `om` sort by modification date, `[1,3]` only first 3 files
#`om`按修改日期排序，`[1,3]`仅前3个文件
print -l **/*(.Lm-2mh-1om[1,3])

# Show every directory that contain directory `.git`
#显示包含目录`.git`的每个目录
print -l **/*(e:'[[ -d $REPLY/.git ]]':)

# Return the file name (t stands for tail)
#返回文件名（t代表尾部）
print -l *.txt(:t)

# Return the file name without the extension (r stands for remove_extension)
#返回没有扩展名的文件名（r代表remove_extension）
print -l *.txt(:t:r)

# Return the extension
#返回扩展名
print -l *.txt(:e)

# Return the parent folder of the file (h stands for head)
#返回文件的父文件夹（h代表头部）
print -l *.txt(:h)

# Return the parent folder of the parent
#返回父级的父文件夹
print -l *.txt(:h:h)

# Return the parent folder of the first file
#返回第一个文件的父文件夹
print -l *.txt([1]:h)

# Parameter expansion
#参数扩展
files=(*.txt)          # store a glob in a variable
print -l $files
print -l $files(:h)    # this is the syntax we saw before
print -l ${files:h}
print -l ${files(:h)}  # don't mix the two, or you'll get an error
print -l ${files:u}    # the :u modifier makes the text uppercase

# :s modifier
#：s编辑
variable="path/aaabcd"
echo ${variable:s/bc/BC/}    # path/aaaBCd
echo ${variable:s_bc_BC_}    # path/aaaBCd
echo ${variable:s/\//./}     # path.aaabcd (escaping the slash \/)
echo ${variable:s_/_._}      # path.aaabcd (slightly more readable)
echo ${variable:s/a/A/}      # pAth/aaabcd (only first A is replaced)
echo ${variable:gs/a/A/}     # pAth/AAAbcd (all A is replaced)

# Split the file name at each underscore
#在每个下划线处拆分文件名
echo ${(s._.)file}

# Join expansion flag, opposite of the split flag.
#加入扩展标志，与拆分标志相对。
array=(a b c d)
echo ${(j.-.)array} # a-b-c-d
