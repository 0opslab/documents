# Move a file from one place to another
#将文件从一个位置移动到另一个位置
mv ~/Desktop/foo.txt ~/Documents/foo.txt

# Move a file from one place to another and automatically overwrite if the destination file exists
#将文件从一个位置移动到另一个位置，并在目标文件存在时自动覆盖
# (This will override any previous -i or -n args)
#（这将覆盖任何先前的-i或-n args）
mv -f ~/Desktop/foo.txt ~/Documents/foo.txt

# Move a file from one place to another but ask before overwriting an existing file
#将文件从一个位置移动到另一个位置，但在覆盖现有文件之前询问
# (This will override any previous -f or -n args)
#（这将覆盖以前的-f或-n args）
mv -i ~/Desktop/foo.txt ~/Documents/foo.txt

# Move a file from one place to another but never overwrite anything
#将文件从一个位置移动到另一个位置但从不覆盖任何内容
# (This will override any previous -f or -i args)
#（这将覆盖以前的-f或-i args）
mv -n ~/Desktop/foo.txt ~/Documents/foo.txt

# Move listed files to a directory
#将列出的文件移动到目录
mv -t ~/Desktop/ file1 file2 file3
