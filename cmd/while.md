# title{while - bash里的那些while循环}
#!/bin/bash

# 
```bash
read -p "A string: " String

while [ "$String" != 'quit' ]; do
  echo $String | tr 'a-z' 'A-Z'
  read -p "Next [quit for quiting]: " String
done
```


```bash
#break n 代表跳出n层循环，如果n比当前循环层数大则跳出全部循环
for I in A B C D
do
    echo -n "$I:"
    for J in `seq 10`
    do
        if [ $J -eq 5 ]; then
            break
            #break 2
        fi
        echo -n "$J"
    done
echo
done
echo
```

```bash
for I in A B C D
do
    echo "$I:"
    for J in `seq 10`
    do
        if [ $J -eq 5 ]; then
            continue        #结束本次并进入下次执行，这里不会打印5
            #continue 2     #跳出循环
        fi
        echo -n "$J"
    done
    echo
done
echo
```



```bash
#
read -p "Input a character: " Char

case $Char in
[0-9])
  echo "A digit." ;;
[a-z])
  echo "A lower." ;;
[A-Z])
  echo "An upper." ;;
[[:punct:]] )
  echo "A punction." ;;
*)
  echo "Special char." ;;
esac

read -p "Do you agree [yes|no]?: " YesNo

case $YesNo in
y|Y|[Yy]es)
  echo "Agreed, proceed." ;;
n|N|[nN]o)
  echo "Disagreed, can't proceed." ;;
*)
  echo "Invalid input." ;;
esac
```