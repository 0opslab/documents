## 常用快捷键

**F1 或 Ctrl+Shift+P 打开命令面板。打开的输入框内，可以输入任何命令，例如：**

- 按一下 `Backspace` 会进入到 `Ctrl+P` 模式
- 在 `Ctrl+P` 下输入 `>` 可以进入 `Ctrl+Shift+P` 模式

**在 Ctrl+P 窗口下还可以：**

- 直接输入（搜索）文件名，并跳转到该文件
-  `?` 列出当前可执行的动作
-  `!` 显示 `Errors` 或 `Warnings`，也可以 `Ctrl+Shift+M` 
-  `:` 跳转到行数，也可以 `Ctrl+G` 直接进入
-  `@` 跳转到 Symbol `Ctrl+Shift+O` 直接进入
-  `@:` 根据分类跳转 Symbol，查找数学或函数，也可以 `Ctrl+Shift+O` 后输入 `:` 进入
-  `#` 根据名字查找 Symbol，也可以 `Ctrl+T` 

### 窗口管理

-  `Ctrl+Shift+N`：打开一个新窗口
-  `Ctrl+Shift+W`：关闭窗口

### 编辑区域和文件

-  `Ctrl+\` 切出一个新的编辑区域（最多三个），也可按住 `Ctrl` 鼠标点击左侧资源管理器（`Explorer`）里的文件名
-  `Ctrl+1` `Ctrl+2` `Ctrl+3` 左中右3个编辑区域的快捷键
-  `Ctrl+N` 新建文件
-  `Ctrl+Tab` 文件之间切换

## 代码编辑

### 格式调整

-  `Ctrl+[`、`Ctrl+]`：代码行缩进
-  `Ctrl+Shift+[`、`Ctrl+Shift+]`：展开、折叠代码块
-  `Ctrl+C`、`Ctrl+V`：复制或粘贴当前行 / 当前选中的内容
-  `Ctrl+Shift+P`：代码格式化，或者 `Ctrl+Shift+P` 后输入 `format code/Document` 
-  `Ctrl+I`：选中当前行
-  `Ctrl+Shift+K`：删除当前行
-  `Alt+Up` 或 `Alt+Down`：上下移动一行
-  `Shift+Alt+Up` 或 `Shift+Alt+Down`：向上或向下复制一行
-  `Ctrl+Enter`：在当前行下方插入一行
-  `Ctrl+Shift+Enter`：在当前行上方插入一行

### 光标相关

-  `Home`：移动到行首
-  `End`：移动到行尾
-  `Ctrl+Home`：移动到文件开头
-  `Ctrl+End`：移动到文件结尾
-  `Shift+Home`：选择从光标到行首
-  `Shift+End`：选择从光标到行尾
-  `Shift+Alt+Left`、`Shift+Alt+Right`：扩展 / 缩小光标的选取范围
-  `Ctrl+Shift+L`：同时选中所有的匹配项
-  `Ctrl+D`:同时选中当前项和下一个匹配项
-  `Alt+Shift+鼠标左键`：同时选中多个光标进行相同操作（自由选择）
-  `Ctrl+Alt+Up`、`Ctrl+Alt+Down`：向上或向下产生一个光标（行，列）
-  `Ctrl+Backspace`：删除光标的单词 / 符号（按一次删一个
-  `Ctrl+Delete`：删除光标右侧的单词 / 符号（按一次删一个）
-  `Ctrl+U`:回退上一个光标操作

### 重构代码

-  `F12`：移动到定义处
-  `Alt+F12`：定义处缩略图，只看一眼而不跳过去
-  `Shift+F12`：找到所有的引用
-  `Ctrl+F12`：同时修改本文件中所有匹配的
- 重命名：比如要修改一个方法名，可以选中后按 `F2`，输入新的名字，回车，会发现所有的文件都修改了
- 跳转到下一个 `Error` 或 `Warning`：当有多个错误时可以按 `F8` 逐个跳转
- 查看 `diff`： 在左侧 `Explorer` 里选择文件右键 `Set file to compare`，然后需要对比的文件上右键选择 `Compare with file_name_you_chose` 

### 查找和替换

-  `Ctrl+F`：查找
-  `Ctrl+H`：查找并替换
-  `Ctrl+Shift+F`：整个文件夹中查找（等同侧边栏的查找按钮）

### 显示相关

-  `F11`：全屏
-  `Ctrl+/-`：放大 / 缩小
-  `Ctrl+B`：侧边栏的显示 / 隐藏
-  `Ctrl+Shift+E`：显示资源管理器 `Explorer` 
-  `Ctrl+Shift+F`：显示搜索
-  `Ctrl+Shift+G`：显示 Git
-  `Ctrl+Shift+D`：显示 Debug
-  `Ctrl+Shift+U`：显示 Output

## vscode优化

说实话很多时候vscode真的很卡，尤其在网络不稳定的情况下，因此需要做一些优化。

1. 关闭update

   通过首选项，将所有的update都设置为非auto。其中包括

   update version/Update: Enable Windows Background Updates/Extensions: Auto Check Updates

### FQA

删除空行  ^\s*(?=\r?$)\n