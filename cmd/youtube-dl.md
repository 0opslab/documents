# title{youtube-dl - 一款视频下载神器}
```bash
# To download a video in 720p MP4:
#要下载720p MP4中的视频：
youtube-dl -f 22 example.com/watch?v=id

# To download a video in 720p MP4 or WebM or FLV:
#要以720p MP4或WebM或FLV下载视频：
youtube-dl -f 22/45/120

# To list all available formats of a video:
#列出视频的所有可用格式：
youtube-dl -F example.com/watch?v=id

# To download a video to /$uploader/$date/$title.$ext:
#要将视频下载到/$uploader/$date/$title.$ext：
youtube-dl -o '%(uploader)s/%(date)s/%(title)s.%(ext)s' example.com/watch?v=id

# To download a video playlist starting from a certain video:
#从某个视频开始下载视频播放列表：
youtube-dl --playlist-start 5 example.com/watch?v=id&list=listid

# To simulate a download with youtube-dl:
#要使用youtube-dl模拟下载：
youtube-dl -s example.com/watch?v=id

# To download audio in mp3 format with best quality available
#以最佳质量下载mp3格式的音频
youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 example.com/watch?v=id

# For all video formats see
#对于所有视频格式请参阅
# http://en.wikipedia.org/wiki/YouTube#Quality_and_codecs
#HTTP://恩.Wikipedia.org/wiki/YouTube#quality_安定_codecs
```
