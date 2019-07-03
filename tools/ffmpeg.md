ffmpeg在做音视频编解码时非常方便，所以很多场景下转码使用的是ffmpeg，铜鼓通过ffmpeg –help命令操作可以看到ffmpeg常见的命令大概分为六部分

* ffmpeg信息查询部分
* 公共做操参数部分
* 文件主要操作参数部分
* 视频操作参数部分
* 音频操作参数部分
* 字幕操作参数部分

### 信息查询命令

| 命令            | 作用                             |
| --------------- | -------------------------------- |
| FFmpeg -version | 显示版本                         |
| -formats        | 显示可用的格式（包括设备）       |
| -demuxers       | 显示可用的demuxers               |
| -muxers         | 显示可用的muxers                 |
| -devices        | 显示可用的设备                   |
| -codecs         | 显示已知的所有编解码器           |
| -decoders       | 显示可用的解码器                 |
| -encoders       | 显示所有可用的编码器             |
| -bsfs           | 显示可用的比特流filter           |
| -protocols      | 显示可用的协议                   |
| -filters        | 显示可用的过滤器                 |
| -pix_fmts       | 显示可用的像素格式               |
| -sample_fmts    | 显示可用的采样格式               |
| -layouts        | 显示channel名称和标准channel布局 |
| -colors         | 显示识别的颜色名称               |

