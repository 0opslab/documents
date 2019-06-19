channel是Go中最核心的Feature之一，因此理解Channel的原来显得十分重要。channel是goroutine之间通信的一种方式，可以类别成Unix中的进程的通信方式管道。

### channel的基本操作

```go
//创建channel
//channel一定要初始化后才能进行读写操作，否则将永久阻塞
ch := make(chan int)

//向channel写数据
ch <- x

//读取数据
x <- ch
x = <- ch

//关闭channel
//关闭一个未初始化nil的channel会产生panic
//重复关闭同一个channel会阐述panic
//向有一个已经关闭的channel中发送消息会阐述panic
close(ch)
```



Channel提供了一种通信机制，通过它一个Goroutine可以向另一个GoRoutine发送消息。Channel本身还需要关联了一个类型，也就是channel可以发送的数据类型。

```go
func testSimple(){
	intChan := make(chan int)
	go func() {
		intChan <- 1
	}()

	value := <- intChan
	fmt.Println("value : ", value)
}
```

### channel类型

Channel是一种特殊的类型，在任何时候，同时只能有一个Goroutine访问通道并进行发送和获取数据。Channel像一个传送带或者队列，总是遵循先进先出的规则，保证手法数据额顺序。channel分为不带缓存channel和带缓存的channel。

#### 无缓存的channel

无缓存的channel中读取消息会阻塞，直到有gorounite向该channel中发送消息，同理向无缓存的channel中发送消息也会阻塞，直到有goroutine从channel中读取消息。

* 通道的收发操作在不同的俩个goroutine间进行。由于通道的数据在没有就接收放处理时，数据发送发放防会吃香阻塞，因此通道的接收必定在另一个goroutine中进行。
* 接收将持续阻塞直到发送方发送数据。
* 每次接收一个元素

#### 有缓存的channel

有缓存的channel的声明方式为指定make函数的第二个参数，该参数为channel缓存的容量,有缓存的channel类似于一个阻塞的队列(采用环形数组实现)。当缓存未满时，向channel中发送消息时不会阻塞，当缓存满时，发送操作将被阻塞，直到有其他goroutine从中读取消息，相应的当channel中消息不为空是，读取消息也不会出现阻塞，当channel为空时，读取操作会造成阻塞，直到也有goroutine向channel中写入消息。

#### 通道的数据接收方式

```go
//阻塞模式接收数据时,将接收变量作为<-操作符的左值
//执行该语句时将阻塞，直到接收到数据并复制给data
data := <-ch

//非阻塞接收数据
//使用非阻塞方式从通道接收数据是，语句不会发生阻塞，data表示接收到数据,ok表示是否接收到数据
data,ok := <-ch

//接收任意数据，忽略接收的数据
<-ch

//循环接收
for data := range ch{}

```

#### 多路复用

在Go语言中提供了select关键字，可以同时响应多个通道的操作。select的每个case都会对应一个通道的收发过程。当收发完成时，就会触发case中响应的语句，多个操作在每次select中挑选也有一个进行响应

```go
select {
    case <- ch1:
    	code
    case <-ch2：
    	code
    ...
    default:
    	code
}
```

下面是使用实例

```go
package main

import (
	"fmt"
	"strconv"
	"time"
)

func main() {
	ch1 := make(chan int)
	ch2 := make(chan string)

	go pump1(ch1)
	go pump2(ch2)
	go suck(ch1, ch2)

	time.Sleep(1e9)
}

//产生数据
func pump1(ch chan int) {
	for i := 0; ; i++ {
		ch <- i * 2
	}
}
func pump2(ch chan string) {
	for i := 0; ; i++ {
		ch <- "Strings" + strconv.Itoa(i)
	}
}

//消费数据
func suck(ch1 chan int, ch2 chan string) {
	for {
		select {
		case v := <-ch1:
			fmt.Println("Received on channel 1: ", v)
		case v := <-ch2:
			fmt.Println("Received on channel 2: ", v)
		}
	}
}
```

### 单向通道的声明格式

只能发送的通道类型为chan<-,只能接收的通道类型为<-chan，格式如下

```go
var 通道实例 chan<- 元素类型	//只能发送数据的通道
var 通道实例 <-chan 元素类型	//只能接收通道


write := make(chan<- int)
read := make(<-chan string)
```

使用实例

```go
package main

import (
	"fmt"
	"time"
)

//通过jobs来接收任务，通过result返回结果
func worker(id int, jobs <-chan int, results chan <- int) {
	for j := range jobs {
		fmt.Println("worker", id, "pricessing job", j)
		time.Sleep(time.Second)
		results <- j * 2
	}
}

func main() {
	jobs := make(chan int, 100)
	results := make(chan int, 100)

	//启用工作池
	for w := 1; w < 10; w++ {
		go worker(w, jobs, results)
	}

	//派送任务
	for i := 0; i < 20; i++ {
		jobs <- i
	}
	//通过close表示任务派送完成
	close(jobs)

	//收集任务的返回值
	for i := 0; i < 20; i++ {
		<-results
	}

}

```



























