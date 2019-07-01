**字符串在程序开发中使用的是非常非常的多**。因此Go中提供了一些函数方便程序开发，常见的字符串函数如下,具体的可以查看官方文档

* 统计字符串的长度,按照字节len(str)
* 字符串遍历,同时处理有中文的问题 r := []rune(str)
* 字符串转整形:  n,err := strconv.Atoi("12")
* 正数转字符串 str = strconv.Itoa(12345)
* 字符串转[]byte   var bytes = []byte("hello")
* []byte 转字符串 str = string([]byte{97,98,99})
* 进制转换 str = strconv.FormatInt(123,2)
* 查找字符串是否包含子串 strings.Contains("hello","ll")
* 统计有一个字符串有几个指定的子串 string.Count("abac","a")
* 不区分大小写的字符串比较(==是区分字母大小写的)strings.EqualFold("abc","Abc")
* 返回子串在字符串中出现的位置index，如果没有返回-1 string.Index("abc","a")
* 返回子串在字符串中出现的最后一次的位置index,如有没有返回-1 string.LastIndex("abc","a")
* 将指定的子串替换成另有一个子串 strings.Replace("go go go","g","h",n)   n希望替换几个,如果n为-1表示全部替换
* 按照指定的字符，分割字符串strings.Split("hello","l")
* 字符串大小写转换strings.ToLower("Go") strings.ToUpper("Go")
* 将字符串俩边的空格去掉strings.TrimSpace(" test nts ")
* 将字符串俩边指定的字符去掉strings.Trim(" hello !"," !")/TrimLeft/TrimRight
* 判断字符串是否已指定的字符串开头string.HasPireix("ftp://","ftp")
* 判断字符串是否以指定的字符串结束strings.HasSufffix("tes.png",".png")



### 正则表达式

除了通用的字符串处理函数为，Go中也提供了正则表达式的支持。type Regexp代表一个编译好的正则表达式，Regexp可以被多线程安全的同时使用。

```go
//解析并返回一个正则表达式
func Compile(expr string)(*Regexp,error)

//类似于Compile但会将语法约束到POSIX RER(EGREP)
func CompilePOSIX(expr string)(*Regexp,error)

//类似于Compile，但是在解析失败时会panic，主要用于全局表达式变量的安全区初始化
func MustCompile(str string) *Regexp

//类似CompilePOSIX
func MustCompilePOSIX(str string) *Regexp
```

以下是一些正则的常用方法

```go
//返回用于编译成正则表达式的字符串
func (re *Regexp) String() string

//是否以符合正则表达式的开头
func (re *Regexp) LiteralPrefix() (prefix string, complete bool)

//返回该正则表达式中捕获分组的数量
func (re *Regexp) NumSubexp() int

//SubexpNames返回该正则表达式中捕获分组的名字。第一个分组的名字是names[1]
func (re *Regexp) SubexpNames() []string


//Longest让正则表达式在之后的搜索中都采用"leftmost-longest"模式。
//在匹配文本时，该正则表达式会尽可能早的开始匹配，并且在匹配过程中
//选择搜索到的最长的匹配结果
func (re *Regexp) Longest()

//Match检查b中是否存在匹配pattern的子序列
func (re *Regexp) Match(b []byte) bool

//MatchString类似Match，但匹配对象是字符串
func (re *Regexp) MatchString(s string) bool

//MatchReader类似Match，但匹配对象是io.RuneReader
func (re *Regexp) MatchReader(r io.RuneReader) bool

//Find返回保管正则表达式re在b中的最左侧的一个匹配结果的[]byte切片。
//如果没有匹配到，会返回nil。
//注意：以Index结尾的函数一般返回索引位置
func (re *Regexp) Find(b []byte) []byte
func (re *Regexp) FindString(s string) string
func (re *Regexp) FindIndex(b []byte) (loc []int)
func (re *Regexp) FindStringIndex(s string) (loc []int)

func (re *Regexp) FindSubmatch(b []byte) [][]byte
func (re *Regexp) FindStringSubmatch(s string) []string
func (re *Regexp) FindSubmatchIndex(b []byte) []int
func (re *Regexp) FindStringSubmatchIndex(s string) []int

func (re *Regexp) FindAll(b []byte, n int) [][]byte
func (re *Regexp) FindAllString(s string, n int) []string
func (re *Regexp) FindAllIndex(b []byte, n int) [][]int
func (re *Regexp) FindAllStringIndex(s string, n int) [][]int



//Split将re在s中匹配的结果作为分隔符s分割成多个字符串，并返回这些正则表达式匹配结果
//n > 0 : 返回最多n个子字符串，最后一个子字符串是剩余未进行分割的部分。
//n == 0: 返回nil (zero substrings)
//n < 0 : 返回所有子字符串
func (re *Regexp) Split(s string, n int) []string


//ReplaceAll返回src的一个拷贝，将src中所有re的匹配结果都替换为repl
func (re *Regexp) ReplaceAll(src, repl []byte) []byte
func (re *Regexp) ReplaceAllString(src, repl string) string


```

下面是regexp的使用实例

```go
package main

import (
	"fmt"
	"regexp"
	"bytes"
)

func main() {
	//这个测试一个字符串是否符合一个表达式。
	match, _ := regexp.MatchString("p([a-z]+)ch", "peach")
	fmt.Println(match)
	//上面我们是直接使用字符串，但是对于一些其他的正则任务，你需要使用 Compile 一个优化的 Regexp 结构体。
	r, _ := regexp.Compile("p([a-z]+)ch")

	//这个结构体有很多方法。这里是类似我们前面看到的一个匹配测试。
	fmt.Println(r.MatchString("peach"))

	//这是查找匹配字符串的。
	fmt.Println(r.FindString("peach punch"))

	//这个也是查找第一次匹配的字符串的，但是返回的匹配开始和结束位置索引，而不是匹配的内容。
	fmt.Println(r.FindStringIndex("peach punch"))
	//Submatch 返回完全匹配和局部匹配的字符串。例如，这里会返回 p([a-z]+)ch 和 `([a-z]+) 的信息。
	fmt.Println(r.FindStringSubmatch("peach punch"))
	//类似的，这个会返回完全匹配和局部匹配的索引位置。
	fmt.Println(r.FindStringSubmatchIndex("peach punch"))
	//带 All 的这个函数返回所有的匹配项，而不仅仅是首次匹配项。例如查找匹配表达式的所有项。
	fmt.Println(r.FindAllString("peach punch pinch", -1))
	//All 同样可以对应到上面的所有函数。
	fmt.Println(r.FindAllStringSubmatchIndex(
		"peach punch pinch", -1))
	//这个函数提供一个正整数来限制匹配次数。
	fmt.Println(r.FindAllString("peach punch pinch", 2))
	//上面的例子中，我们使用了字符串作为参数，并使用了如 MatchString 这样的方法。我们也可以提供 []byte参数并将 String 从函数命中去掉。
	fmt.Println(r.Match([]byte("peach")))
	//创建正则表示式常量时，可以使用 Compile 的变体MustCompile 。因为 Compile 返回两个值，不能用语常量。
	r = regexp.MustCompile("p([a-z]+)ch")
	fmt.Println(r)
	//regexp 包也可以用来替换部分字符串为其他值。
	fmt.Println(r.ReplaceAllString("a peach", "<fruit>"))

	//Func 变量允许传递匹配内容到一个给定的函数中，
	in := []byte("a peach")
	out := r.ReplaceAllFunc(in, bytes.ToUpper)
	fmt.Println(string(out))

	res := regexp.MustCompile("a*")
	split_str := res.Split("abaabaccadaaae", 5)
	fmt.Println(split_str)
	// s: ["", "b", "b", "c", "cadaaae"]

}

```

