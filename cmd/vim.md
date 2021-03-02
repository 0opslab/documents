# title{vim - vim相关的那些操作}


# 配置编辑器
gconf-editor       
# 配置文件路径
/etc/vimrc         
# 打开文件定位到指定行
vim +24 file       
# 打开多个文件	
vim file1 file2    
# 垂直分屏
vim -O2 file1 file2
# 水平分屏
vim -on file1 file2
# 上下分割打开新文件
sp filename        
# 左右分割打开新文件
vsp filename       
# 多个文件间操作  大写W  # 操作: 关闭当前窗口c  屏幕高度一样=  增加高度+  移动光标所在屏 右l 左h 上k 下j 中h  下一个w  
Ctrl+W [操作]      

```bash
:n                 # 编辑下一个文件
:2n                # 编辑下二个文件
:N                 # 编辑前一个文件
:rew               # 回到首文件
:set nu            # 打开行号
:set nonu          # 取消行号
200G               # 跳转到200
:nohl              # 取消高亮
:set autoindent    # 设置自动缩进
:set ff            # 查看文本格式
:set binary        # 改为unix格式
ctrl+ U            # 向前翻页
ctrl+ D            # 向后翻页
%s/字符1/字符2/g   # 全部替换	
X                  # 文档加密

# File management
#文件管理

:e              reload file
:q              quit
:q!             quit without saving changes
:w              write file
:w {file}       write new file
:x              write file and exit

# Movement
#运动

    k
  h   l         basic motion
    j

w               next start of word
W               next start of whitespace-delimited word
e               next end of word
E               next end of whitespace-delimited word
b               previous start of word
B               previous start of whitespace-delimited word
0               start of line
$               end of line
gg              go to first line in file
G               go to end of file
gk		move down one displayed line
gj		move up one displayed line

# Insertion
#插入
#   To exit from insert mode use Esc or Ctrl-C
#要退出插入模式，请使用Esc或Ctrl-C
#   Enter insertion mode and:
#进入插入模式并：

a               append after the cursor
A               append at the end of the line
i               insert before the cursor
I               insert at the beginning of the line
o               create a new line under the cursor
O               create a new line above the cursor
R               enter insert mode but replace instead of inserting chars
:r {file}       insert from file

# Editing
#编辑

u               undo
yy              yank (copy) a line
y{motion}       yank text that {motion} moves over
p               paste after cursor
P               paste before cursor
<Del> or x      delete a character
dd              delete a line
d{motion}       delete text that {motion} moves over

# Search and replace with the `:substitute` (aka `:s`) command
#搜索并替换为`：substitute`（又名`：s`）命令

:s/foo/bar/	replace the first match of 'foo' with 'bar' on the current line only
:s/foo/bar/g	replace all matches (`g` flag) of 'foo' with 'bar' on the current line only
:%s/foo/bar/g	replace all matches of 'foo' with 'bar' in the entire file (`:%s`)
:%s/foo/bar/gc	ask to manually confirm (`c` flag) each replacement 

# Preceding a motion or edition with a number repeats it 'n' times
#在带有数字的动作或版本之前重复它'n'次
# Examples:
#例子：
50k         moves 50 lines up
2dw         deletes 2 words
5yy         copies 5 lines
42G         go to line 42
```
