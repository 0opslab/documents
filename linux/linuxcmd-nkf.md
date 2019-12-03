# check the file's charactor code
#检查文件的字符代码
nkf -g test.txt

# convert charactor code to UTF-8
#将字符代码转换为UTF-8
nkf -w --overwrite test.txt

# convert charactor code to EUC-JP
#将字符代码转换为EUC-JP
nkf -e --overwrite test.txt

# convert charactor code to Shift-JIS
#将字符代码转换为Shift-JIS
nkf -s --overwrite test.txt

# convert charactor code to ISO-2022-JP
#将字符代码转换为ISO-2022-JP
nkf -j --overwrite test.txt

# convert newline to LF
#将换行符转换为LF
nkf -Lu --overwrite test.txt

# convert newline to CRLF
#将换行符转换为CRLF
nkf -Lw --overwrite test.txt

# convert newline to CR
#将换行符转换为CR
nkf -Lm --overwrite test.txt

# MIME encode
#MIME编码
echo テスト | nkf -WwMQ

# MIME decode
#MIME解码
echo "=E3=83=86=E3=82=B9=E3=83=88" | nkf -WwmQ
