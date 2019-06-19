# find all file name ending with .pdf and remove them
#找到所有以.pdf结尾的文件名并删除它们
find -name *.pdf | xargs rm -rf

# if file name contains spaces you should use this instead
#如果文件名包含空格，则应使用此替代
find -name *.pdf | xargs -I{} rm -rf '{}'

# Will show every .pdf like:
#将显示每个.pdf像：
#	&toto.pdf=
#用＆和。 pdf =
#	&titi.pdf=
#＃＆titi.pdf =
# -n1 => One file by one file. ( -n2 => 2 files by 2 files )
#-n1 =>一个文件一个文件。 （-n2 => 2个文件的2个文件）

find -name *.pdf | xargs -I{} -n1 echo '&{}='

# If find returns no result, do not run rm
#如果find没有返回结果，请不要运行rm
# This option is a GNU extension.
#此选项是GNU扩展。
find -name "*.pdf" | xargs --no-run-if-empty rm
