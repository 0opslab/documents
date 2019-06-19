---
title: GO的IO流操作
date: 2018-01-23 20:59:13
tags: GO
---

程序就是INPUT-计算-OUTPUT，各种语言都提供了IO库，供程序员使用，GO语言也不例外，为了方便开发者使用，GO的标准库中将IO操作封装在了如下几个包中：

* io 为IO操作提供了基本的接口
* io/ioutil 封装了一些使用IO函数
* fmt实现格式化I/O，类似C语言中的printf和scanf
* bufio实现带缓冲的io

io包提供了对I/O原语的基本接口。包的基本任务是包装这些原语已有的实现，使之成为共享的公共接口，这些公共接口抽象出了泛用的函数并附加了一些相关的原语的操作。因为这些接口和原语是对底层实现完全不同的低水平操作的包装，除非得到其它方面的通知，客户端不应假设它们是并发执行安全的

核心接口

```go
// Writer 接口包装了基本的 Write 方法，用于将数据存入自身。
// Write 方法用于将 p 中的数据写入到对象的数据流中，
// 返回写入的字节数和遇到的错误。
// 如果 p 中的数据全部被写入，则 err 应该返回 nil。
// 如果 p 中的数据无法被全部写入，则 err 应该返回相应的错误信息。
type Writer interface {
    Write(p []byte) (n int, err error)
}
// WriterTo 接口包装了基本的 WriteTo 方法，用于将自身的数据写入 w 中。
// 直到数据全部写入完毕或遇到错误为止，返回写入的字节数和遇到的错误。
type WriterTo interface {
    WriteTo(w Writer) (n int64, err error)
}


// Reader 接口包装了基本的 Read 方法，用于输出自身的数据。
// Read 方法用于将对象的数据流读入到 p 中，返回读取的字节数和遇到的错误。
// 在没有遇到读取错误的情况下：
// 1、如果读到了数据（n > 0），则 err 应该返回 nil。
// 2、如果数据被读空，没有数据可读（n == 0），则 err 应该返回 EOF。
// 如果遇到读取错误，则 err 应该返回相应的错误信息。
type Reader interface {
    Read(p []byte) (n int, err error)
}
// ReaderFrom 接口包装了基本的 ReadFrom 方法，用于从 r 中读取数据存入自身。
// 直到遇到 EOF 或读取出错为止，返回读取的字节数和遇到的错误。
type ReaderFrom interface {
    ReadFrom(r Reader) (n int64, err error)
}

// Seeker 接口包装了基本的 Seek 方法，用于移动数据的读写指针。
// Seek 设置下一次读写操作的指针位置，每次的读写操作都是从指针位置开始的。
// whence 的含义：
// 如果 whence 为 0：表示从数据的开头开始移动指针。
// 如果 whence 为 1：表示从数据的当前指针位置开始移动指针。
// 如果 whence 为 2：表示从数据的尾部开始移动指针。
// offset 是指针移动的偏移量。
// 返回新指针位置和遇到的错误。
type Seeker interface {
    Seek(offset int64, whence int) (ret int64, err error)
}


实现了 io.Reader 或 io.Writer 接口的类型#####
os.File 同时实现了 io.Reader 和 io.Writer
strings.Reader 实现了 io.Reader
bufio.Reader/Writer 分别实现了 io.Reader 和 io.Writer
bytes.Buffer 同时实现了 io.Reader 和 io.Writer
bytes.Reader 实现了 io.Reader
compress/gzip.Reader/Writer 分别实现了 io.Reader 和 io.Writer
crypto/cipher.StreamReader/StreamWriter 分别实现了 io.Reader 和 io.Writer
crypto/tls.Conn 同时实现了 io.Reader 和 io.Writer
encoding/csv.Reader/Writer 分别实现了 io.Reader 和 io.Writer
mime/multipart.Part 实现了 io.Reader
io.LimitedReader、io.PipeReader、io.SectionReader实现了io.Reader
io.PipeWriter实现了io.Writer
```

### io 包

处理定义来了基本的I/O原语外，该包中也提供一些常用的函数，方便各种操作

```go
// WriteString writes the contents of the string s to w, which accepts a slice of bytes.
// WriteString 将字符串 s 的内容写入 w，它接受一个字节片段。如果 w 实现 WriteString 方法，
// 则直接调用它。否则，w.Write 只会被调用一次。
func WriteString(w Writer, s string) (n int, err error)

// ReadAtLeast reads from r into buf until it has read at least min bytes.
// ReadAtLeast 从 r 读入 buf，直到它读取至少最小字节。它返回复制的字节数，如果读取的字节更少，
//则返回错误。只有在没有字节被读取的情况下，错误才是 EOF 。如果在读取少于最小字节数后发生 EOF，
//则 ReadAtLeast 返回 ErrUnexpectedEOF 。如果 min 大于 buf 的长度，
///则 ReadAtLeast 返回 ErrShortBuffer。返回时，n> = min 当且仅当 err == nil 
func ReadAtLeast(r Reader, buf []byte, min int) (n int, err error)

// ReadFull reads exactly len(buf) bytes from r into buf.
// It returns the number of bytes copied and an error if fewer bytes were read.
// The error is EOF only if no bytes were read.
// ReadFull 完全读取从 r 到 buf 的 len(buf) 个字节。它返回复制的字节数，如果读取的字节更少，
// 则返回错误。只有在没有字节被读取的情况下，错误才是 EOF 。如果在读取一些但不是全部字节后发生 EOF，
// 则 ReadFull 将返回 ErrUnexpectedEOF 。返回时，n == len(buf) 当且仅当 err == nil 
func ReadFull(r Reader, buf []byte) (n int, err error)

// CopyN copies n bytes (or until an error) from src to dst.
// CopyN 拷贝从 src 到 dst 的 n 个字节（或直出现一个错误）。
//它返回拷贝的字节数和复制时遇到的最早的错误。返回时，written == n 当且仅当 err == nil 。
func CopyN(dst Writer, src Reader, n int64) (written int64, err error)

// Copy copies from src to dst until either EOF is reached
// on src or an error occurs. It returns the number of bytes
// copied and the first error encountered while copying, if any.
// A successful Copy returns err == nil, not err == EOF.
//将副本从 src 复制到 dst ，直到在 src 上达到 EOF 或发生错误。
//它返回复制的字节数和复制时遇到的第一个错误（如果有的话）
func Copy(dst Writer, src Reader) (written int64, err error)

// CopyBuffer is identical to Copy except that it stages through the
// provided buffer (if one is required) rather than allocating a
// temporary one. If buf is nil, one is allocated; otherwise if it has
// zero length, CopyBuffer panics.
//CopyBuffer 与 Copy 相同，只是它通过提供的缓冲区（如果需要的话）进行分级，而不是分配临时的缓冲区。
//如果 buf 为零，则分配一个；否则如果它的长度为零，CopyBuffer 会发生混乱。
func CopyBuffer(dst Writer, src Reader, buf []byte) (written int64, err error)

// LimitReader returns a Reader that reads from r
// but stops with EOF after n bytes.
// The underlying implementation is a *LimitedReader.
//LimitReader 返回一个 Reader，它从 r 读取，但在 n 字节后用 EOF 停止。底层的实现是一个 *LimitedReader 
func LimitReader(r Reader, n int64) Reader


```

下面是

```go
// WriteString 将字符串 s 写入到 w 中
// 返回写入的字节数和写入过程中遇到的任何错误
// 如果 w 实现了 WriteString 方法
// 则调用 w 的 WriteString 方法将 s 写入 w 中
// 否则，将 s 转换为 []byte
// 然后调用 w.Write 方法将数据写入 w 中
func WriteString(w Writer, s string) (n int, err error)
 
func main() {
    // os.Stdout 实现了 Writer 接口
    io.WriteString(os.Stdout, "Hello World!")
    // Hello World!
}
 
 
------------------------------------------------------------
 
// ReadAtLeast 从 r 中读取数据到 buf 中，要求至少读取 min 个字节
// 返回读取的字节数 n 和读取过程中遇到的任何错误
// 如果 n < min，则 err 返回 ErrUnexpectedEOF
// 如果 r 中无可读数据，则 err 返回 EOF
// 如果 min 大于 len(buf)，则 err 返回 ErrShortBuffer
// 只有当 n >= min 时 err 才返回 nil
func ReadAtLeast(r Reader, buf []byte, min int) (n int, err error)
 
func main() {
    r := strings.NewReader("Hello World!")
    b := make([]byte, 32)
    n, err := io.ReadAtLeast(r, b, 20)
    fmt.Printf("%s\n%d, %v", b, n, err)
    // Hello World!
    // 12, unexpected EOF
}
 
 
------------------------------------------------------------
 
// ReadFull 的功能和 ReadAtLeast 一样，只不过 min = len(buf)，其中要求最少读取的字节数目是len(buf)，当r中数据少于len(buf)时便会报错
func ReadFull(r Reader, buf []byte) (n int, err error)
 
func main() {
    r := strings.NewReader("Hello World!")
    b := make([]byte, 32)
    n, err := io.ReadFull(r, b)
    fmt.Printf("%s\n%d, %v", b, n, err)
    // Hello World!
    // 12, unexpected EOF
}
 
 
------------------------------------------------------------
 
// CopyN 从 src 中复制 n 个字节的数据到 dst 中
// 它返回复制的字节数 written 和复制过程中遇到的任何错误
// 只有当 written = n 时，err 才返回 nil
// 如果 dst 实现了 ReadFrom 方法，则调用 ReadFrom 来执行复制操作
func CopyN(dst Writer, src Reader, n int64) (written int64, err error)
 
func main() {
    r := strings.NewReader("Hello World!")
    n, err := io.CopyN(os.Stdout, r, 20)
    fmt.Printf("\n%d, %v", n, err)
    // Hello World!
    // 12, EOF
}
 
 
------------------------------------------------------------
 
// Copy 从 src 中复制数据到 dst 中，直到所有数据复制完毕
// 返回复制过程中遇到的任何错误
// 如果数据复制完毕，则 err 返回 nil，而不是 EOF
// 如果 dst 实现了 ReadeFrom 方法，则调用 dst.ReadeFrom(src) 复制数据
// 如果 src 实现了 WriteTo 方法，则调用 src.WriteTo(dst) 复制数据
func Copy(dst Writer, src Reader) (written int64, err error)
 
func main() {
    r := strings.NewReader("Hello World!")
    n, err := io.Copy(os.Stdout, r)
    fmt.Printf("\n%d, %v", n, err)
    // Hello World!
    // 12, <nil>
}
 
 
------------------------------------------------------------
 
// LimitReader 覆盖了 r 的 Read 方法
// 使 r 只能读取 n 个字节的数据，读取完毕后返回 EOF
func LimitReader(r Reader, n int64) Reader
 
// LimitedReader 结构用来实现 LimitReader 的功能
type LimitedReader struct
 
func main() {
    r := strings.NewReader("Hello World!")
    lr := io.LimitReader(r, 5)
    n, err := io.CopyN(os.Stdout, lr, 20)
    fmt.Printf("\n%d, %v", n, err)
    // Hello
    // 5, EOF
}
 
 
------------------------------------------------------------
 
// NewSectionReader 封装 r，并返回 SectionReader 类型的对象
// 使 r 只能从 off 的位置读取 n 个字节的数据，读取完毕后返回 EOF
func NewSectionReader(r ReaderAt, off int64, n int64) *SectionReader
 
// SectionReader 结构用来实现 NewSectionReader 的功能
// SectionReader 实现了 Read、Seek、ReadAt、Size 方法
type SectionReader struct
 
// Size 返回 s 中被限制读取的字节数
func (s *SectionReader) Size()
 
func main() {
    r := strings.NewReader("Hello World!")
    sr := io.NewSectionReader(r, 0, 5)
    n, err := io.CopyN(os.Stdout, sr, 20)
    fmt.Printf("\n%d, %v", n, err)
    fmt.Printf("\n%d", sr.Size())
    // World
    // 5, EOF
    // 5
}
 
 
------------------------------------------------------------
 
// TeeReader 覆盖了 r 的 Read 方法
// 使 r 在读取数据的同时，自动向 w 中写入数据
// 所有写入时遇到的错误都被作为 err 返回值
func TeeReader(r Reader, w Writer) Reader
 
func main() {
    r := strings.NewReader("Hello World!")
    tr := io.TeeReader(r, os.Stdout)
    b := make([]byte, 32)
    tr.Read(b)
    // World World!
}
```

#### 管道Writer和Reader

类型 io.PipeWriter 和 io.PipeReader 在内存管道中模拟 io 操作。数据被写入管道的一端，并使用单独的 goroutine 在管道的另一端读取。

```go
package main

import (
	"bytes"
	"io"
	"os"

)

func main(){
	proverbs := new(bytes.Buffer)
	proverbs.WriteString("Channels orchestrate mutexes serialize\n")
	proverbs.WriteString("Cgo is not Go\n")
	proverbs.WriteString("Errors are values\n")
	proverbs.WriteString("Don't panic\n")

	piper, pipew := io.Pipe()

	// 将 proverbs 写入 pipew 这一端
	go func() {
		defer pipew.Close()
		io.Copy(pipew, proverbs)
	}()

	// 从另一端 piper 中读取数据并拷贝到标准输出
	io.Copy(os.Stdout, piper)
	piper.Close()

}

```





### io/ioutil 包

该包主要实现了i/o的一些功能函数，主要的函数有

```go
//ReadDir reads the directory named by dirname and returns
//a list of directory entries sorted by filename.
//获取目录文件信息返回一个FileInfo的切片
//文件切片信息包括，文件大小 是否为目录 创建时间 系统信息等
func ReadDir(dirname string) ([]os.FileInfo, error)

//从reader中读取所有数据，返回读取到的数据和遇到的错误。
func ReadAll(r io.Reader) ([]byte, error)
func readAll(r io.Reader, capacity int64) (b []byte, err error)
func ReadFile(filename string) ([]byte, error)

// WriteFile 向文件中写入数据，写入前会清空文件。
// 如果文件不存在，则会以指定的权限创建该文件。
// 返回遇到的错误。
func WriteFile(filename string, data []byte, perm os.FileMode) error

```

实例

```go
package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func main(){
	s := strings.NewReader("Hello World!")
	ra, _ := ioutil.ReadAll(s)
	fmt.Printf("%s", ra)

	ra1, _ := ioutil.ReadFile("C:\\Windows\\win.ini")
	fmt.Printf("%s", ra1)

	fn := "C:\\Test.txt"
	s1 := []byte("Hello World!")
	ioutil.WriteFile(fn, s1, os.ModeAppend)
	rf, _ := ioutil.ReadFile(fn)
	fmt.Printf("%s", rf)

	rd, err := ioutil.ReadDir("C:\\Windows")
	for _, fi := range rd {
		fmt.Println("")
		fmt.Println(fi.Name())
		fmt.Println(fi.IsDir())
		fmt.Println(fi.Size())
		fmt.Println(fi.ModTime())
		fmt.Println(fi.Mode())
	}
	fmt.Println("")
	fmt.Println(err)


	s2 := strings.NewReader("hello world!")
	//ReadCloser 接口组合了基本的 Read 和 Close 方法。NopCloser 将提供的
	// Reader r 用空操作 Close 方法包装后作为 ReadCloser 返回
	r := ioutil.NopCloser(s2)
	r.Close()
	p := make([]byte, 10)
	r.Read(p)
	fmt.Println(string(p))
}
```



### bufio

bufio包实现了缓存IO，它包装了io.Reader和io.Writer对象，创建了另外的Reader和Writer对象，它们也实现了io.Reader和io.Writer接口，不过它们是有缓存的。该包同时为文本I/O提供了一些便利操作。

```go
//常用函数
// NewReaderSize returns a new Reader whose buffer has at least the specified
// size. If the argument io.Reader is already a Reader with large enough
// size, it returns the underlying Reader.
// NewReaderSize 返回一个新的 Reader，其缓冲区至少具有指定的大小。
// 如果参数 io.Reader 已经是一个足够大的 Reader ，它将返回底层的 Reader
func NewReaderSize(rd io.Reader, size int) *Reader
// NewReader returns a new Reader whose buffer has the default size.
// NewReader 返回一个新的 Reader ，其缓冲区具有默认大小。s。
func NewReader(rd io.Reader) *Reader
// NewWriterSize returns a new Writer whose buffer has at least the specified
// size. If the argument io.Writer is already a Writer with large enough
// size, it returns the underlying Writer.
// NewWriterSize 返回一个新的 Writer，其缓冲区至少具有指定的大小。如果参数 io.Writer
// 已经是一个尺寸足够大的 Writer，它将返回底层的 Writer
func NewWriterSize(w io.Writer, size int) *Writer
// NewWriter returns a new Writer whose buffer has the default size.
// NewWriter 返回一个新的 Writer，其缓冲区具有默认大小
func NewWriter(w io.Writer) *Writer
// NewReadWriter allocates a new ReadWriter that dispatches to r and w.
// NewReadWriter 分配一个新的 ReadWriter 分派给 r 和 w 。
func NewReadWriter(r *Reader, w *Writer) *ReadWriter
// NewScanner returns a new Scanner to read from r.
// The split function defaults to ScanLines.
// NewScanner 返回一个新的扫描仪来从 r 读取内容。分割功能默认为 ScanLines
func NewScanner(r io.Reader) *Scanner

// ScanBytes is a split function for a Scanner that returns each byte as a token.
//ScanBytes 是 Scanner 的分割函数，它将每个字节作为标记返回
func ScanBytes(data []byte, atEOF bool) (advance int, token []byte, err error)
// ScanRunes is a split function for a Scanner that returns each
// UTF-8-encoded rune as a token. The sequence of runes returned is
// equivalent to that from a range loop over the input as a string, which
// means that erroneous UTF-8 encodings translate to U+FFFD = "\xef\xbf\xbd".
// Because of the Scan interface, this makes it impossible for the client to
// distinguish correctly encoded replacement runes from encoding errors.
// ScanRunes 是扫描仪的分离功能，可以将每个UTF-8编码符文作为标记返回。
// 返回的符文序列与输入中的范围循环相当于一个字符串，这意味着错误的UTF-8编码转换为 
// U+FFFD = "\xef\xbf\xbd"。由于Scan界面，这使得客户端无法区分正确编码的替换符文和编码错误。
func ScanRunes(data []byte, atEOF bool) (advance int, token []byte, err error)

// ScanLines is a split function for a Scanner that returns each line of
// text, stripped of any trailing end-of-line marker. The returned line may
// be empty. The end-of-line marker is one optional carriage return followed
// by one mandatory newline. In regular expression notation, it is `\r?\n`.
// The last non-empty line of input will be returned even if it has no
// newline.
// ScanLines 是扫描仪的分离功能，可以返回每一行文本，并将任何尾随行尾标记剥离。返回的行可能为空。
// 行尾标记是一个可选的回车符，后跟一个强制换行符。在正则表达式中，它是\r?\n。即使没有换行，
// 也会返回最后一个非空行输入。
func ScanLines(data []byte, atEOF bool) (advance int, token []byte, err error)

// ScanWords is a split function for a Scanner that returns each
// space-separated word of text, with surrounding spaces deleted. It will
// never return an empty string. The definition of space is set by
// unicode.IsSpace.
// ScanWords 是 Scanner 的分割功能，可以返回每个空格分隔的文字，并删除周围的空格。
// 它永远不会返回一个空字符串。空间的定义由 unicode.IsSpace 设置
func ScanWords(data []byte, atEOF bool) (advance int, token []byte, err error)

type Reader struct{}
	//丢弃跳过下 n 个字节，返回丢弃的字节数
	func (b *Reader) Discard(n int) (discarded int, err error)
	//Peek 返回接下来的n个字节，而不会推进阅读器。字节在下次读取呼叫时停止有效。
	//如果 Peek 返回少于 n 个字节，它也会返回一个错误，解释为什么读取很短。
	//如果 n 大于 b 的缓冲区大小，则错误为 ErrBufferFull
    func (b *Reader) Peek(n int) ([]byte, error)
	//读取数据到页面。它返回读入p的字节数。这些字节是从底层读取器读取的，
	//因此 n 可能小于 len（p） 。在 EOF 时，计数将为零，err 将为 io.EOF
    func (b *Reader) Read(p []byte) (n int, err error)
	//ReadByte 读取并返回一个字节。如果没有可用的字节，则返回错误
    func (b *Reader) ReadByte() (byte, error)
	//ReadBytes 读取直到输入中第一次出现 delim ，并返回一个包含数据的片段直至并包含分隔符
    func (b *Reader) ReadBytes(delim byte) ([]byte, error)
	//ReadLine 是一个低级的 line-reading 取原语。大多数调用者应该使用
	//ReadBytes('\n') 或 ReadString('\n') 来代替或使用扫描器
    func (b *Reader) ReadLine() (line []byte, isPrefix bool, err error)
	//ReadRune 读取单个 UTF-8 编码的 Unicode 字符，并以字节为单位返回符文及其大小
    func (b *Reader) ReadRune() (r rune, size int, err error)
	//ReadSlice 读取直到输入中第一次出现 delim，返回指向缓冲区中字节的片段
    func (b *Reader) ReadSlice(delim byte) (line []byte, err error)
	//ReadString 进行读取，直到输入中第一次出现 delim，返回一个包含数据的字符串直到并包含分隔符。
    func (b *Reader) ReadString(delim byte) (string, error)
	//重置放弃任何缓冲数据，重置所有状态，并将缓冲读取器从 r 读取。
    func (b *Reader) Reset(r io.Reader)
	//UnreadByte 未读取最后一个字节。只有最近读取的字节可以是未读的
    func (b *Reader) UnreadByte() error
	//UnreadRune 未阅读最后的符文。如果缓冲区上的最新读取操作不是 ReadRune，则 UnreadRune 会返回错误。
    func (b *Reader) UnreadRune() error
	//WriteTo 实现 io.WriterTo。这可能会多次调用底层 Reader 的Read 方法
    func (b *Reader) WriteTo(w io.Writer) (n int64, err error)


type Writer struct{}
	//可用返回缓冲区中未使用的字节数
    func (b *Writer) Available() int
	//Buffered 返回已写入当前缓冲区的字节数
    func (b *Writer) Buffered() int
	//Flush 将任何缓冲的数据写入底层的 io.Writer
    func (b *Writer) Flush() error
	//ReadFrom 实现了 io.ReaderFrom
    func (b *Writer) ReadFrom(r io.Reader) (n int64, err error)
	//重置放弃任何未刷新的缓冲数据，清除任何错误，并重置b以将其输出写入 w。
    func (b *Writer) Reset(w io.Writer)
	//Write 将 p 的内容写入缓冲区。它返回写入的字节数。如果nn < len(p)，它也会返回一个错误
    func (b *Writer) Write(p []byte) (nn int, err error)
	//WriteByte 写入一个字节
    func (b *Writer) WriteByte(c byte) error
	//WriteRune 写入一个 Unicode 代码点，返回写入的字节数和任何错误
    func (b *Writer) WriteRune(r rune) (size int, err error)
	//WriteString 写入一个字符串。它返回写入的字节数。如果计数小于 len(s)，它也会返回一个错误
    func (b *Writer) WriteString(s string) (int, error)

type ReadWriter struct{}



type Scanner struct{}
	//缓冲区设置扫描时要使用的初始缓冲区以及扫描期间可能分配的最大缓冲区大小。
	//最大令牌大小是 max 和 cap(buf) 中较大的一个。如果 max <= cap(buf)，
    //扫描将仅使用此缓冲区并且不进行分配。
    func (s *Scanner) Buffer(buf []byte, max int)
    // 字节返回由扫描调用产生的最新令牌。底层数组可能指向将被随后的扫描调用覆盖的数据。它没有分配
    func (s *Scanner) Bytes() []byte
	// Err 返回扫描器遇到的第一个非EOF错误
    func (s *Scanner) Err() error
    // 扫描将扫描仪推进到下一个标记，然后通过字节或文本方法使用该标记。当扫描停止时，它会返回 false
	// 通过到达输入末尾或错误。在 Scan 返回 false 后，Err 方法将返回扫描期间发生的任何错误，
	// 除了如果它是 io.EOF，Err 将返回 nil。如果分割函数返回100个空令牌而不提前输入，
	// 则扫描恐慌。这是扫描仪的常见错误模式。
    func (s *Scanner) Scan() bool
    // 分割设定扫描仪的分割功能。默认的分割功能是 ScanLines
    func (s *Scanner) Split(split SplitFunc)
    // 文本将通过调用 Scan 生成的最新令牌返回为保存其字节的新分配的字符串
    func (s *Scanner) Text() string



```



























































