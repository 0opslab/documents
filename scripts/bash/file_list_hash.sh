#!/bin/bash

#func{get dir hash}
function hash_dir(){
    log="hash_"`date +%Y%m%d%H`".log"
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            hash_dir $1"/"$file
        else
           echo `md5 $1"/"$file`>>$log
        fi
    done
}

# test
hash_dir ~/workspace
