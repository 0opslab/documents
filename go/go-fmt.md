fmt包可能是接触go编程接触到最早的包，但是这个包中有部分高级用法和特性还是需要认真学习的。

### 占位符

```go
    普通占位符
    占位符    说明                          举例                  输出
    %v      相应值的默认格式。            Printf("%v", people)  {zhangsan}，
    %+v    打印结构体时，会添加字段名    Printf("%+v", people)  {Name:zhangsan}
    %#v    相应值的Go语法表示            Printf("#v", people)  main.Human{Name:"zhangsan"}
    %T      相应值的类型的Go语法表示      Printf("%T", people)  main.Human
    %%      字面上的百分号，并非值的占位符  Printf("%%")            %

    布尔占位符
    占位符      说明                举例                    输出
    %t          true 或 false。    Printf("%t", true)      true

    整数占位符
    占位符    说明                                  举例                      输出
    %b      二进制表示                            Printf("%b", 5)            101
    %c      相应Unicode码点所表示的字符              Printf("%c", 0x4E2D)        中
    %d      十进制表示                            Printf("%d", 0x12)          18
    %o      八进制表示                            Printf("%d", 10)            12
    %q      单引号围绕的字符字面值，由Go语法安全地转义 Printf("%q", 0x4E2D)        '中'
    %x      十六进制表示，字母形式为小写 a-f        Printf("%x", 13)            d
    %X      十六进制表示，字母形式为大写 A-F        Printf("%x", 13)            D
    %U      Unicode格式：U+1234，等同于 "U+%04X"  Printf("%U", 0x4E2D)        U+4E2D

    浮点数和复数的组成部分（实部和虚部）
    占位符    说明                              举例            输出
    %b      无小数部分的，指数为二的幂的科学计数法，
        与 strconv.FormatFloat 的 'b' 转换格式一致。例如 -123456p-78
    %e      科学计数法，例如 -1234.456e+78        Printf("%e", 10.2)    1.020000e+01
    %E      科学计数法，例如 -1234.456E+78        Printf("%e", 10.2)    1.020000E+01
    %f      有小数点而无指数，例如 123.456        Printf("%f", 10.2)    10.200000
    %g      根据情况选择 %e 或 %f 以产生更紧凑的（无末尾的0）输出 Printf("%g", 10.20)  10.2
    %G      根据情况选择 %E 或 %f 以产生更紧凑的（无末尾的0）输出 Printf("%G", 10.20+2i) (10.2+2i)

    字符串与字节切片
    占位符    说明                              举例                          输出
    %s      输出字符串表示（string类型或[]byte)  Printf("%s", []byte("Go语言"))  Go语言
    %q      双引号围绕的字符串，由Go语法安全地转义  Printf("%q", "Go语言")        "Go语言"
    %x      十六进制，小写字母，每字节两个字符      Printf("%x", "golang")        676f6c616e67
    %X      十六进制，大写字母，每字节两个字符      Printf("%X", "golang")        676F6C616E67

    指针
    占位符        说明                      举例                            输出
    %p      十六进制表示，前缀 0x          Printf("%p", &people)            0x4f57f0

    其它标记
    占位符      说明                            举例          输出
    +      总打印数值的正负号；对于%q（%+q）保证只输出ASCII编码的字符。 
                                      Printf("%+q", "中文")  "\u4e2d\u6587"
    -      在右侧而非左侧填充空格（左对齐该区域）
    #      备用格式：为八进制添加前导 0（%#o）      Printf("%#U", '中')      U+4E2D
        为十六进制添加前导 0x（%#x）或 0X（%#X），为 %p（%#p）去掉前导 0x；
        如果可能的话，%q（%#q）会打印原始 （即反引号围绕的）字符串；
        如果是可打印字符，%U（%#U）会写出该字符的
        Unicode 编码形式（如字符 x 会被打印成 U+0078 'x'）。
    ' '    (空格)为数值中省略的正负号留出空白（% d）；
        以十六进制（% x, % X）打印字符串或切片时，在字节之间用空格隔开
    0      填充前导的0而非空格；对于数字，这会将填充移到正负号之后
```



### Print系列函数

Print 系列函数会将参数列表a中的各个参数转换为字符串并写入到的标准输出中。非字符串参数之间会添加空格，返回写入到字节数。ln会在最后添加一个换行符。Printf将用参数列表a填写到格式字符串format的占位符中。

```go
func Print(a ...interface{}) (n int, err error)
func Println(a ...interface{}) (n int, err error)
func Printf(format string, a ...interface{}) (n int, err error)


// 功能同上面三个函数，只不过将转换结果写入到 w 中。
func Fprint(w io.Writer, a ...interface{}) (n int, err error)
func Fprintln(w io.Writer, a ...interface{}) (n int, err error)
func Fprintf(w io.Writer, format string, a ...interface{}) (n int, err error)


//功能同上面三个函数，只不过将转换结果以字符串形式返回。
func Sprint(a ...interface{}) string
func Sprintln(a ...interface{}) string
func Sprintf(format string, a ...interface{}) string

//功能同 Sprintf，只不过结果字符串被包装成了 error 类型。
func Errorf(format string, a ...interface{}) error
```

下面是使用实例

```go
package main

import "fmt"

//@Document 演示fmt包中print系列函数的使用

func main(){
	fmt.Print("a","b",1,2,"c","d")
	//在字符串末尾添加换行符
	//add a newline char '\n' at the end of the string
	fmt.Println("a","b",1,2,"c","d")

	//format string
	fmt.Printf("ab %d %d %d cd\n",1,2,3)


	s := fmt.Sprint("a","b",1,2,"c","d")
	fmt.Println(s)

}
```

### 自定义格式化实现

该包中定义了如下几个接口用于实现自定义有类型的自定义格式化过程

```go
// 当格式化器需要格式化该类型的变量时，会调用其 Format 方法。
type Formatter interface {
	// f 用于获取占位符的旗标、宽度、精度等信息，也用于输出格式化的结果
	// c 是占位符中的动词
	Format(f State, c rune)
}

// 由格式化器（Print 之类的函数）实现，用于给自定义格式化过程提供信息
type State interface {
	// Formatter 通过 Write 方法将格式化结果写入格式化器中，以便输出。
	Write(b []byte) (ret int, err error)
	// Formatter 通过 Width 方法获取占位符中的宽度信息及其是否被设置。
	Width() (wid int, ok bool)
	// Formatter 通过 Precision 方法获取占位符中的精度信息及其是否被设置。
	Precision() (prec int, ok bool)
	// Formatter 通过 Flag 方法获取占位符中的旗标[+- 0#]是否被设置。
	Flag(c int) bool
}

// Stringer 由自定义类型实现，用于实现该类型的自定义格式化过程。
// 当格式化器需要输出该类型的字符串格式时就会调用其 String 方法。
type Stringer interface {
	String() string
}

// Stringer 由自定义类型实现，用于实现该类型的自定义格式化过程。
// 当格式化器需要输出该类型的 Go 语法字符串（%#v）时就会调用其 String 方法。
type GoStringer interface {
	GoString() string
}
```

### Scan系列函数

scan从表中输入中读取数据，并将数据用空白分割并解析后存入到a提供的变量中，换行符会被当做空白符处理，变量必须以指针的形式传入，当读到EOF或所有数据都填写完毕则停止扫描。返回成功解析的参数数量

```go
func Scan(a ...interface{}) (n int, err error)

// Scanln 和 Scan 类似，只不过遇到换行符就停止扫描。
func Scanln(a ...interface{}) (n int, err error)

// Scanf 从标准输入中读取数据，并根据格式字符串 format 对数据进行解析，
// 将解析结果存入参数 a 所提供的变量中，变量必须以指针传入。
// 输入端的换行符必须和 format 中的换行符相对应（如果格式字符串中有换行
// 符，则输入端必须输入相应的换行符）。
// 占位符 %c 总是匹配下一个字符，包括空白，比如空格符、制表符、换行符。
// 返回成功解析的参数数量。
func Scanf(format string, a ...interface{}) (n int, err error)

// 功能同上面三个函数，只不过从 r 中读取数据。
func Fscan(r io.Reader, a ...interface{}) (n int, err error)
func Fscanln(r io.Reader, a ...interface{}) (n int, err error)
func Fscanf(r io.Reader, format string, a ...interface{}) (n int, err error)

// 功能同上面三个函数，只不过从 str 中读取数据。
func Sscan(str string, a ...interface{}) (n int, err error)
func Sscanln(str string, a ...interface{}) (n int, err error)
func Sscanf(str string, format string, a ...interface{}) (n int, err error)

```

### 自定义扫描器

go中定义如下接口用于实现自定义扫描

```go
// Scanner 由自定义类型实现，用于实现该类型的自定义扫描过程。
// 当扫描器需要解析该类型的数据时，会调用其 Scan 方法。
type Scanner interface {
	// state 用于获取占位符中的宽度信息，也用于从扫描器中读取数据进行解析。
	// verb 是占位符中的动词
	Scan(state ScanState, verb rune) error
}

// 由扫描器（Scan 之类的函数）实现，用于给自定义扫描过程提供数据和信息。
type ScanState interface {
	// ReadRune 从扫描器中读取一个字符，如果用在 Scanln 类的扫描器中，
	// 则该方法会在读到第一个换行符之后或读到指定宽度之后返回 EOF。
	// 返回“读取的字符”和“字符编码所占用的字节数”
	ReadRune() (r rune, size int, err error)
	// UnreadRune 撤消最后一次的 ReadRune 操作，
	// 使下次的 ReadRune 操作得到与前一次 ReadRune 相同的结果。
	UnreadRune() error
	// SkipSpace 为 Scan 方法提供跳过开头空白的能力。
	// 根据扫描器的不同（Scan 或 Scanln）决定是否跳过换行符。
	SkipSpace()
	// Token 用于从扫描器中读取符合要求的字符串，
	// Token 从扫描器中读取连续的符合 f(c) 的字符 c，准备解析。
	// 如果 f 为 nil，则使用 !unicode.IsSpace(c) 代替 f(c)。
	// skipSpace：是否跳过开头的连续空白。返回读取到的数据。
	// 注意：token 指向共享的数据，下次的 Token 操作可能会覆盖本次的结果。
	Token(skipSpace bool, f func(rune) bool) (token []byte, err error)
	// Width 返回占位符中的宽度值以及宽度值是否被设置
	Width() (wid int, ok bool)
	// 因为上面实现了 ReadRune 方法，所以 Read 方法永远不应该被调用。
	// 一个好的 ScanState 应该让 Read 直接返回相应的错误信息。
	Read(buf []byte) (n int, err error)
}
```

