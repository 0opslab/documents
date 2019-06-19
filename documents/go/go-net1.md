net包提供了可移植的网络I/O接口、包括TCP/IP、UDP、域名解析和Unix域socket

在Go每一种通信发放时都使用XXConn结构体来表示，诸如IPConn、TCPConn等，这些结构体都实现了Conn接口，而Conn接口实现了基本的读、协、关闭、火气远程地和本地地址、设置timeout等功能。大多数程序只需要Dail、Listen和Accept函数获得相应的XXConn实现，然后进行相关的通信即可。

```go
type Conn interface{
    //read从连接中读取数据
    //read方法可能会在超过某个固定时间限制后超时返回错误，该错误的timeout方法返回真
    Read(b []byte) (n int, err error)
    
    //write从连接中写入数据
    //Write方法可能会在超过某个固定时间限制后超时返回错误，该错误的Timeout方法返回真
    Write(b []byte) (n int, err error)
    //Close方法关闭该连接
    //并会导致任何阻塞中的read和write方法不再阻塞并返回错误
    Close() error
    //返回本地网络地址
    LocalAddr() Addr
    //返回远端网络地址
    RemoteAddr() Addr
    // 设定该连接的读写deadline，等价于同时调用SetReadDeadline和SetWriteDeadline
    // deadline是一个绝对时间，超过该时间后I/O操作就会直接因超时失败返回而不会阻塞
    // deadline对之后的所有I/O操作都起效，而不仅仅是下一次的读或写操作
    // 参数t为零值表示不设置期限
    SetDeadline(t time.Time) error
    // 设定该连接的读操作deadline，参数t为零值表示不设置期限
    SetReadDeadline(t time.Time) error
    // 设定该连接的写操作deadline，参数t为零值表示不设置期限
    // 即使写入超时，返回值n也可能>0，说明成功写入了部分数据
    SetWriteDeadline(t time.Time) error
}
```

另外该包还提供了一些简单函数用于完成各类操作

```go
//获取网络接口信息
func InterfaceByIndex(index int) (*Interface, error)
func InterfaceByName(name string) (*Interface, error)
func Interfaces() ([]Interface, error)
func InterfaceAddrs() ([]Addr, error)


//将格式为"host:port"、"[host]:port"的网络地址分割为host和port两个部分。
func SplitHostPort(hostport string) (host, port string, err error)
//函数将host和port合并为一个网络地址。一般格式为"host:port"
func JoinHostPort(host, port string) string


//ip相关的操作
//IPv4返回包含一个IPv4地址a.b.c.d的IP地址（16字节格式）
func IPv4(a, b, c, d byte) IP
//ParseIP将s解析为IP地址，并返回该地址。如果s不是合法的IP地址文本表示，ParseIP会返回nil。
func ParseIP(s string) IP
//String返回IP地址ip的字符串表示
func (ip IP) String() string
//ParseCIDR将s作为一个CIDR（无类型域间路由）的IP地址和掩码字符串
func ParseCIDR(s string) (IP, *IPNet, error)

//ResolveIPAddr将addr作为一个格式为"host"或"ipv6-host%zone"的IP地址来解析。
//函数会在参数net指定的网络类型上解析，net必须是"ip"、"ip4"或"ip6"。
func ResolveIPAddr(net, addr string) (*IPAddr, error)
//ResolveTCPAddr将addr作为TCP地址解析并返回。参数addr格式为"host:port"
func ResolveTCPAddr(net, addr string) (*TCPAddr, error)
//ResolveTCPAddr将addr作为UDP地址解析并返回
func ResolveUDPAddr(net, addr string) (*UDPAddr, error)
//ResolveUnixAddr将addr作为Unix域socket地址解析，参数net指定网络类
func ResolveUnixAddr(net, addr string) (*UnixAddr, error)


//LookupPort函数查询指定网络和服务的（默认）端口。
func LookupPort(network, service string) (port int, err error)
//LookupCNAME函数查询name的规范DNS名（但该域名未必可以访问）
func LookupCNAME(name string) (cname string, err error)
//LookupHost函数查询主机的网络地址序列
func LookupHost(host string) (addrs []string, err error)
//LookupIP函数查询主机的ipv4和ipv6地址序列。
func LookupIP(host string) (addrs []IP, err error)
//LookupAddr查询某个地址，返回映射到该地址的主机名序列，本函数和LookupHost不互为反函数
func LookupAddr(addr string) (name []string, err error)
//LookupMX函数返回指定主机的按Pref字段排好序的DNS MX记录。
func LookupMX(name string) (mx []*MX, err error)
//LookupNS函数返回指定主机的DNS NS记录。
func LookupNS(name string) (ns []*NS, err error)
```

### 通用函数的使用实例

```go
package main

import (
	"fmt"
	"net"
	"os"
)

//@Document演示net包中常用的函数使用

func main(){

	//将string类型的ip地址转为IP对象并根据ip获取子网掩码等

	ipStr := "192.168.30.10"

	ip := net.ParseIP(ipStr)

	if ip == nil{
		fmt.Println("无效的地址")
		return
	}

	defaultMask := ip.DefaultMask()
	fmt.Println( "DefaultMask:", defaultMask, defaultMask.String())

	ones, bits := defaultMask.Size()
	fmt.Println("ones: ",ones," bits: " , bits)

	network := ip.Mask(defaultMask)
	fmt.Println(os.Stdout, "network:", network.String())



	//通过域名获取Ip
	domain := "www.baidu.com"
	ipAddr,err := net.ResolveIPAddr("ip",domain)
	if err != nil{
		fmt.Printf("域名解析IP异常",err)
		return
	}
	fmt.Println(domain,"===>",ipAddr)

	//动态dns查询域名对应的所有ip地址
	ns, err := net.LookupHost(domain)
	if err != nil {
		fmt.Println( "Err: %s", err.Error())
		return
	}

	for _, n := range ns {
		fmt.Println(n)
	}

	// 查看telnet服务器使用的端口
	port, err := net.LookupPort("tcp", "telnet")

	if err != nil {
		fmt.Println("未找到指定服务")
		return
	}

	fmt.Println( "telnet port: ", port)

	// 将一个host地址转换为TCPAddr。host=ip:port
	pTCPAddr, err := net.ResolveTCPAddr("tcp", "www.baidu.com:80")
	if err != nil {
		fmt.Println("Err: ", err.Error())
		return
	}
	fmt.Printf( "www.baidu.com:80 IP: %s PORT: %d", pTCPAddr.IP.String(), pTCPAddr.Port)
}

```

### socket编程

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

#### 模拟一个TCP时间服务器

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

#### 模拟一个UDP的时间服务器

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

