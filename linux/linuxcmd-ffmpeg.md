# Print file metadata etc.
#打印文件元数据等
ffmpeg -i path/to/file.ext

# Convert all m4a files to mp3
#将所有m4a文件转换为mp3
for f in *.m4a; do ffmpeg -i "$f" -acodec libmp3lame -vn -b:a 320k "${f%.m4a}.mp3"; done

# Convert video from .foo to .bar
#将视频从.foo转换为.bar
# -g : GOP, for searchability
#-g：GOP，用于搜索
ffmpeg -i input.foo -vcodec bar -acodec baz -b:v 21000k -b:a 320k -g 150 -threads 4 output.bar

# Convert image sequence to video
#将图像序列转换为视频
ffmpeg -r 18 -pattern_type glob -i '*.png' -b:v 21000k -s hd1080 -vcodec vp9 -an -pix_fmt yuv420p -deinterlace output.ext

# Combine video and audio into one file
#将视频和音频合并为一个文件
ffmpeg -i video.ext -i audio.ext -c:v copy -c:a copy output.ext

# Listen to 10 seconds of audio from a video file
#收听视频文件中的10秒音频
#
#
# -ss : start time
#-ss：开始时间
# -t  : seconds to cut
#-t：秒减少
# -autoexit : closes ffplay as soon as the audio finishes
#-autoexit：音频结束后立即关闭ffplay
ffmpeg -ss 00:34:24.85 -t 10 -i path/to/file.mp4 -f mp3 pipe:play | ffplay -i pipe:play -autoexit

