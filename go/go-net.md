---
title: GO网络编程
date: 2018-01-31 20:15:00
tags: GO
---

Go语言标准库里提供了net包，支持基于IP层、TCP/UDP层以及更高成层面的HTTP、FTP等的网络操作。下面是net包中定义的类型和常用的方法。

# SOCKET编程

```go
//表示IP地址信息的类型
type IP []type

//把一个IPv4或者IPv6的地址转换为IP类型
ParseIP(s tring) IP
//创建子网掩码
func IPv4Mask(a,b,c,d byte) IPMask
//获取子网掩码
func (ip IP)DefaultMask() IPMask
//获取一个TCPAddr地址
func ResloveTCPAddr(net,addr string)(*TCPAddr,os.Error)
func LookupHost(name string)(cname string, addrs []string,error)

//TCP连接，可以用来作为客户端和服务端交互的通道
type TCPConn struct {conn}

//向TCPConn通道中写入数据和读取数据
func (c *TCPConn) Write(b []byte)(n int,err os.Error)
func (c *TCPConn) Read(b []byte)(n int,err os.Error)

//表示一个TCP的地址信息
type TCPAddr struct{IP IP Port int}

//Go提供了Dial函数来连接服务器，使用Listen监听，Accept接受连接，和其他语言的socket编程其实没区别

//Conn是GO socket编程中最重要的一个类型
type Conn interface {
        Read(b []byte) (n int, err error)
        Write(b []byte) (n int, err error)
        Close() error
        LocalAddr() Addr       
        RemoteAddr() Addr     
        SetDeadline(t time.Time) error
        SetReadDeadline(t time.Time) error
        SetWriteDeadline(t time.Time) error
}
//连接知道的IP或域名，而短号以:的形式跟在地址后面，如果连接成功返回连接对象，否则返回error
//该函数支持如下几种网络协议:"tcp"、"tcp4"(仅限IPv4)、"tcp6"(仅限 IPv6)、
//"udp"、"udp4"(仅限、、IPv4)、"udp6"(仅限IPv6)、"ip"、"ip4"(仅限IPv4)和"ip6"(仅限IPv6)
// 连接成功后返回Conn对象，通过该对象的Write和Read方法可以进行数据交换
func Dial(net,addr string)(Conn ,error)
func DialTimeout(network, address string, timeout time.Duration) (Conn, error)
conn, err := net.Dial("tcp", "192.168.0.10:2100")
conn, err := net.Dial("udp", "192.168.0.12:975")
conn, err := net.Dial("tcp", "192.0.2.1:80")
conn, err := net.Dial("tcp", "golang.org:http")
conn, err := net.Dial("tcp", "[2001:db8::1]:http")
conn, err := net.Dial("tcp", "[fe80::1%lo0]:80")
conn, err := net.Dial("tcp", ":80")
//下面是一些封装函数
func DialTCP(net string, laddr, raddr *TCPAddr) (c *TCPConn, err error) 
func DialUDP(net string, laddr, raddr *UDPAddr) (c *UDPConn, err error) 
func DialIP(netProto string, laddr, raddr *IPAddr) (*IPConn, error)
func DialUnix(net string, laddr, raddr *UnixAddr) (c *UnixConn, err error)


//Listen和Accept
type Listener interface {
        Accept() (Conn, error)
        Close() error
        Addr() Addr
}

func Listen(net, laddr string) (Listener, error)
```

## 模拟一个TCP时间服务器

```go
package main

import (
    "net"
    "time"
)

func main()  {
    service := ":2000"
    tcpAddr, err := net.ResolveTCPAddr("tcp", service)
    checkErr(err)

    listener, err := net.ListenTCP("tcp", tcpAddr)
    checkErr(err)

    for {
        conn, err := listener.Accept()
        if err != nil {
            continue
        }

        daytime := time.Now().String()
        conn.Write([]byte(daytime))
        conn.Close()
    }
}

func checkErr(err error) {
    if err != nil {
        panic(err)
    }
}
```

## 模拟一个UDP的时间服务器

```go
package main

import (
    "net"
    "time"
)

func main() {
    service := ":2000"
    udpAddr, err := net.ResolveUDPAddr("udp4", service)
    checkErr(err)

    conn, err := net.ListenUDP("udp", udpAddr)
    checkErr(err)

    for {
        handleClient(conn)
    }
}

func handleClient(conn *net.UDPConn) {
    var buf [512]byte

    _, addr, err := conn.ReadFromUDP(buf[0:])
    if err != nil {
        return
    }

    daytime := time.Now().String()

    conn.WriteToUDP([]byte(daytime), addr)
}

func checkErr(err error) {
    if err != nil {
        panic(err)
    }
}
```

#HTTP编程

HTTP协议可以说是目前互联网上使用最广泛的一种网络协议，它定义了客户端和服务端之间请求与项羽的传输标准。GO语言标准库內建了net/http包，涵盖了HTTP客户端和服务端的具体实现。使用该报能可以轻松的编写HTTP客户端或服务端的程序。

## 基础

HTTP编程离不开俩样东西，它们分别是Request和Response，分别代表着请求和响应，所有的HTTP编程都是围绕着它们。下面是GO中关于这俩个对象的定义

```go
type Request

    func NewRequest(method, urlStr string, body io.Reader) (*Request, error)

    func ReadRequest(b *bufio.Reader) (req *Request, err error)

    func (r *Request) AddCookie(c *Cookie)

    func (r *Request) Cookie(name string) (*Cookie, error)

    func (r *Request) Cookies() []*Cookie

    func (r *Request) FormFile(key string) (multipart.File, *multipart.FileHeader, error)

    func (r *Request) FormValue(key string) string

    func (r *Request) MultipartReader() (*multipart.Reader, error)

    func (r *Request) ParseForm() (err error)

    func (r *Request) ParseMultipartForm(maxMemory int64) error

    func (r *Request) PostFormValue(key string) string

    func (r *Request) ProtoAtLeast(major, minor int) bool

    func (r *Request) Referer() string

    func (r *Request) SetBasicAuth(username, password string)

    func (r *Request) UserAgent() string

    func (r *Request) Write(w io.Writer) error

    func (r *Request) WriteProxy(w io.Writer) error

type Response

    func Get(url string) (resp *Response, err error)

    func Head(url string) (resp *Response, err error)

    func Post(url string, bodyType string, body io.Reader) (resp *Response, err error)

    func PostForm(url string, data url.Values) (resp *Response, err error)

    func ReadResponse(r *bufio.Reader, req *Request) (resp *Response, err error)

    func (r *Response) Cookies() []*Cookie

    func (r *Response) Location() (*url.URL, error)

    func (r *Response) ProtoAtLeast(major, minor int) bool

    func (r *Response) Write(w io.Writer) error
```



##客户端

使用net/http包不需要任何第三方通信库就可以使用HTTP请求。下面是关于net/http包中于客户端常用操作相关的类型和函数说明。Client和Transport是线程安全的，他们是可以复用的，即只见了一次连接多次使用

```go
//A Client is an HTTP client
type Client struct {
  	//用于确定HTTP请求哦创建机制
	Transport RoundTripper
    //定义重定向策略
	CheckRedirect func(req *Request, via []*Request) error
    //如果jar为空，cookie将不会再请求中发送，并会在响应中被忽略
	Jar CookieJar
	Timeout time.Duration
}

// http response
type Response struct {
	Status     string // e.g. "200 OK"
	StatusCode int    // e.g. 200
	Proto      string // e.g. "HTTP/1.0"
	ProtoMajor int    // e.g. 1
	ProtoMinor int    // e.g. 0
	Header Header
	Body io.ReadCloser
	ContentLength int64
	TransferEncoding []string
	Close bool
	Uncompressed bool
	Trailer Header
	Request *Request
	TLS *tls.ConnectionState
}


//对应常用的HTTP请求方法
//简单的Get请求
func (c *Client) Get(url string)(r *Response,err error)
//简单的post请求
func (c *Client) Post(url string,bodyType string,body io.Reader)(r *Response,err error)
//标准的表单提交
func (c *Client) PostForm(url string,data rul.Values)(r *Response,err error)
//Heaad请求即 HTTP Header 而不返回 HTTPBody
func (c *Client) Head(url string)(r *Response,err error)
//实现一些更丰富的http请求
func (c *Client) Do(req *Request)(resp *Response,err error)
```

下面是对对上述函数的简单实例

```go
import (
	"net/http"
	"net/url"
	"io/ioutil"
	"fmt"
	"bytes"
)

func main() {
	//Get、Head、Post、PostForm配合使用实现HTTP请求：
	resp, err := http.Get("http://0opslab.com/")
	checkErr(err)
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	fmt.Println("GET status:",resp.StatusCode," cotent:",body)

	bodyBuf := &bytes.Buffer{}
	resp2, err := http.Post("http://0opslab.com/", "image/jpeg", bodyBuf)
	checkErr(err)
	defer resp2.Body.Close()
	body2, err := ioutil.ReadAll(resp2.Body)
	fmt.Println("GET status:",resp2.StatusCode," cotent:",body2)


	resp3, err := http.PostForm("http://0opslab.com/",url.Values{"key": {"Value"}, "id": {"123"}})
	checkErr(err)
	defer resp3.Body.Close()
	body3, err := ioutil.ReadAll(resp3.Body)
	fmt.Println("GET status:",resp3.StatusCode," cotent:",body3)



	req, err := http.NewRequest("GET", "http://0opslab.com/", nil)
	req.Header.Add("User-Agent", "Gobook Custom User-Agent")
	// ...
	client := &http.Client{ //
		}
	resp4, err := client.Do(req)
	defer resp4.Body.Close()
	body4, err := ioutil.ReadAll(resp4.Body)
	fmt.Println("GET status:",resp4.StatusCode," cotent:",body4)
}
func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}
```

## 服务端

服务端编程进过了漫长的发展已经有了相对固定的模型，即接收服务端请求，处理服务端请求。在此基础上衍生出了很多扩展方式、如线程池、事件池等等。Go语言因为有协程的加入，因此使服务端编程在简化编码的基础上保证了高可用、高并发的特性。这也是Go如此流行的一个重要原因。Go中提供了函数ListenAndServe根据提供的地址和handler创建一个HTTPServer，handler通常是nil，nil表示DefaultServerMux。可以使用Handle和HandleFunc给DefaultServeMux添加新的handler,下面是一些常用的函数和方法，具体见GO源码

```go
func CanonicalHeaderKey(s string) string

func DetectContentType(data []byte) string

func Error(w ResponseWriter, error string, code int)

func Handle(pattern string, handler Handler)

func HandleFunc(pattern string, handler func(ResponseWriter, *Request))

func ListenAndServe(addr string, handler Handler) error

func ListenAndServeTLS(addr string, certFile string, keyFile string, handler Handler) error

func MaxBytesReader(w ResponseWriter, r io.ReadCloser, n int64) io.ReadCloser

func NotFound(w ResponseWriter, r *Request)

func ParseHTTPVersion(vers string) (major, minor int, ok bool)

func ParseTime(text string) (t time.Time, err error)

func ProxyFromEnvironment(req *Request) (*url.URL, error)

func ProxyURL(fixedURL *url.URL) func(*Request) (*url.URL, error)

func Redirect(w ResponseWriter, r *Request, urlStr string, code int)

func Serve(l net.Listener, handler Handler) error

func ServeContent(w ResponseWriter, req *Request, name string, modtime time.Time, content io.ReadSeeker)

func ServeFile(w ResponseWriter, r *Request, name string)

func SetCookie(w ResponseWriter, cookie *Cookie)

func StatusText(code int) string
type Handler

    func FileServer(root FileSystem) Handler

    func NotFoundHandler() Handler

    func RedirectHandler(url string, code int) Handler

    func StripPrefix(prefix string, h Handler) Handler

    func TimeoutHandler(h Handler, dt time.Duration, msg string) Handler

type HandlerFunc

    func (f HandlerFunc) ServeHTTP(w ResponseWriter, r *Request)

type Header

    func (h Header) Add(key, value string)

    func (h Header) Del(key string)

    func (h Header) Get(key string) string

    func (h Header) Set(key, value string)

    func (h Header) Write(w io.Writer) error

    func (h Header) WriteSubset(w io.Writer, exclude map[string]bool) error

type Hijacker

type ProtocolError

    func (err *ProtocolError) Error() string
```

下面是一个完整的HTTP 服务端编程的实例

```go
package main

import (
	"net/http"
	"fmt"
	"strings"
	"log"
	"html/template"
	"time"
)

//演示GO中cookie的使用
func http_info(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()       //解析url传递的参数，对于POST则解析响应包的主体（request body）
	//注意:如果没有调用ParseForm方法，下面无法获取表单的数据
	fmt.Println(r.Form) //这些信息是输出到服务器端的打印信息
	fmt.Println("path", r.URL.Path)
	//fmt.Println("scheme", r.URL.Scheme)
	//fmt.Println(r.Form["url_long"])
	params := ""
	for k, v := range r.Form {
		params += "&"+k+"="+strings.Join(v, "")
	}
	fmt.Fprintf(w, params) //这个写入到w的是输出到客户端的
}
/**
 处理登录信息
 */
func login(w http.ResponseWriter,r *http.Request){
	//获取请求方式
	fmt.Println("methdo:",r.Method)
	r.ParseForm()
	//读取cookie
	cookie,_ := r.Cookie("username")
	fmt.Println("存在cookie",cookie)

	if r.Method == "GET" {
		t, _ := template.ParseFiles("/local/workspace/opslabGo/data/web/login.gtpl")
		log.Println(t.Execute(w, nil))
	} else {
		//设置cookie
		expiration := time.Now()
		expiration = expiration.AddDate(1, 0, 0)
		cookie := http.Cookie{Name: "username", Value: r.Form["username"][0], Expires: expiration}
		http.SetCookie(w, &cookie)


		//请求的是登录数据，那么执行登录的逻辑判断
		fmt.Println("username:", r.Form["username"])
		fmt.Println("password:", r.Form["password"])
		fmt.Fprintf(w, "username:"+r.Form["username"][0]+" password:"+r.Form["password"][0])

	}
}

func main(){
	http.HandleFunc("/",http_info)
	http.HandleFunc("/login",login)
	err := http.ListenAndServe(":9090",nil)
	if err != nil{
		log.Fatal("Service:",err)
	}
}
```











