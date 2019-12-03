#replace : with new line
##replace：用新线
echo $PATH|tr ":" "\n" #equivalent with:
echo $PATH|tr -t ":" \n 

#remove all occurance of "ab"
##remove所有出现的“ab”
echo aabbcc |tr -d "ab"
#ouput: cc
##ouput：cc

#complement "aa"
##complement“aa”
echo aabbccd |tr -c "aa" 1
#output: aa11111 without new line
##output：aa11111没有换行
#tip: Complement meaning keep aa,all others are replaced with 1
##tip：补充意义保持aa，所有其他用1替换

#complement "ab\n"
##complement“ab \ n”
echo aabbccd |tr -c "ab\n" 1
#output: aabb111 with new line
##output：带有新行的aabb111

#Preserve all alpha(-c). ":-[:digit:] etc" will be translated to "\n". sequeeze mode.
##Preserve all alpha（-c）。 “： -  [：digit：] etc”将被翻译为“\ n”。挤压模式。
echo $PATH|tr -cs "[:alpha:]" "\n" 

#ordered list to unordered list
##ordered list to unordered list
echo "1. /usr/bin\n2. /bin" |tr -cs " /[:alpha:]\n" "+"
