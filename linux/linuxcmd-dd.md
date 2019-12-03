# Read from {/dev/urandom} 2*512 Bytes and put it into {/tmp/test.txt}
#从{/ dev / urandom}读取2 * 512字节并将其放入{/tmp/test.txt}
# Note: At the first iteration, we read 512 Bytes.
#注意：在第一次迭代中，我们读取512字节。
# Note: At the second iteration, we read 512 Bytes.
#注意：在第二次迭代中，我们读取512字节。
dd if=/dev/urandom of=/tmp/test.txt count=2 bs=512

# Watch the progress of 'dd'
#观看'dd'的进展
dd if=/dev/zero of=/dev/null bs=4KB &; export dd_pid=`pgrep '^dd'`; while [[ -d /proc/$dd_pid ]]; do kill -USR1 $dd_pid && sleep 1 && clear; done

# Watch the progress of 'dd' with `pv` and `dialog` (apt-get install pv dialog)
#使用`pv`和`dialog`（apt-get install pv对话框）观察'dd'的进度
(pv -n /dev/zero | dd of=/dev/null bs=128M conv=notrunc,noerror) 2>&1 | dialog --gauge "Running dd command (cloning), please wait..." 10 70 0

# Watch the progress of 'dd' with `pv` and `zenity` (apt-get install pv zenity)
#使用`pv`和`zenity`观看'dd'的进度（apt-get install pv zenity）
(pv -n /dev/zero | dd of=/dev/null bs=128M conv=notrunc,noerror) 2>&1 | zenity --title 'Running dd command (cloning), please wait...' --progress

# Watch the progress of 'dd' with the built-in `progress` functionality (introduced in coreutils v8.24)
#使用内置的“progress”功能（在coreutils v8.24中引入）观察'dd'的进度
dd if=/dev/zero of=/dev/null bs=128M status=progress

# DD with "graphical" return
#DD带有“图形”返回
dcfldd if=/dev/zero of=/dev/null bs=500K

# This will output the sound from your microphone port to the ssh target computer's speaker port. The sound quality is very bad, so you will hear a lot of hissing.
#这会将声音从麦克风端口输出到ssh目标计算机的扬声器端口。声音质量很差，所以你会听到很多嘶嘶声。
dd if=/dev/dsp | ssh -c arcfour -C username@host dd of=/dev/dsp
