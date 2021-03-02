#!/bin/bash
#
useradd $1 
echo $1 | passwd --stdin $1 &> /dev/null

#
for uno in $(seq 301 310); do
    useradd user${uno}
done


#
if ! id $1 &> /dev/null; then
    useradd $1
fi


declare -i count=0

for i in {501..510}; do
    if id tuser$i &> /dev/null; then
	echo "tuser$i exists."
    else
        useradd tuser$i
	let count++
    fi 
done

echo "Total add $count users."


