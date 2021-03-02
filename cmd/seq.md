# title{seq - 是一个序列的缩写，主要用来输出序列化的东西}

### 选项
```bash
用法：seq [选项]... 尾数
　或：seq [选项]... 首数 尾数
　或：seq [选项]... 首数 增量 尾数
以指定增量从首数开始打印数字到尾数。
 
  -f, --format=格式     使用printf 样式的浮点格式
  -s, --separator=字符串        选项主要改变输出的分格符(默认使用：\n)
  -w, --equal-width    在列前添加0 使得宽度相同【自动补位】
      --help            显示此帮助信息并退出
      --version         显示版本信息并退出
```

### 常用命令
```bash
seq 10 100               # 列出10-100
seq 1 10 |tac            # 倒叙列出
seq -s '+' 90 100 |bc    # 从90加到100
seq -f 'dir%g' 1 10 | xargs mkdir     # 创建dir1-10
seq -f 'dir%03g' 1 10 | xargs mkdir   # 创建dir001-010
seq -w 1 10 默认补位操作

seq 1 4 | xargs -I{} echo {} > h.txt    
```