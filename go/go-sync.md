Go推荐通过channel进行通信和同步，但是在实际开发中sync包用的也非常多。Go的sync包提供了Mutex，RMuetx,Once，Cond,Waitgourp，atomic等，用来完成不同场景下的同步。简单的来说sync是通过提供互斥锁着类基本的同步原语，来实现同步的。

sync包含了一个Locker interface

```go
type Locker interface{
    Lock()
    Unlock()
}
```

一个互斥锁只能同时被一个goroutine锁定，其他goroutine将阻塞直到互斥锁被接收，之后再重新争抢对互斥锁的锁定。对一个未锁定的互斥锁解锁将会产生运算时错误。

```go
package main

import (
	"fmt"
	"time"
	"sync"
)

func main(){
	a := 0

	//通过锁控制并发资源的访问
	var lock  sync.Mutex
	for i := 0;i<100;i++{
		go func(i int){
			//获取锁
			lock.Lock()
			defer lock.Unlock()

			
			a += i
		}(i)
	}

	time.Sleep(time.Second)
	fmt.Println(a)
}
```

### 读写锁RWMutex

读写锁是针对读写操作的互斥锁，读写锁语与互斥锁最大的不同就是可以分贝对 读、写进行锁定，一般用于大量读操作，少量写操作的情况。当有一个 goroutine 获得写锁定，其它无论是读锁定还是写锁定都将阻塞直到写解锁；当有一个 goroutine 获得读锁定，其它读锁定仍然可以继续；当有一个或任意多个读锁定，写锁定将等待所有读锁定解锁之后才能够进行写锁定。所以说这里的读锁定（RLock）目的其实是告诉写锁定：有很多人正在读取数据，需等它们读（读解锁）完再来写（写锁定）。

```go
//写锁定
func (rw *RWMutex) Lock()
//写解锁
func (rw *RWMutex) Unlock()
//读锁定
func (rw *RWMutex) RLock()
//读解锁
func (rw *RWMutex) RUnlock()
```

下面就是有一个写少读多的例子

```go
package main

import (
	"fmt"
	"math/rand"
	"sync"
)

var count int
var rw sync.RWMutex


func read(n int,ch chan struct{}){
	rw.RLock()
    v := count
    fmt.Printf("进入读操作...值为：%d\n", v)
    rw.RUnlock()
    ch <- struct{}{}
}

func write(n int, ch chan struct{}) {
    rw.Lock()
    v := rand.Intn(1000)
    count = v
    fmt.Printf("===>进入写操作 新值为：%d\n", v)
    rw.Unlock()
    ch <- struct{}{}
}


func main(){
	ch := make(chan struct{},10)
    for i := 0; i < 10; i++ {
        go read(i, ch)
    }
    for i := 0; i < 5; i++ {
        go write(i, ch)
    }

    for i := 0; i < 10; i++ {
        <-ch
    }

}
```

### WaitGroup 

WaitGroup用于等待一组goroutine结束，用法很简单，它拥有如下算个方法

```go
//用来添加goroutine的个数
func (wg *WaitGroup) Add(delta int)
//执行一次数量减1
func (wg *WaitGroup) Done()
//用来等待结束
func (wg *WaitGroup) Wait()

```

下面是一个简单的实例

```go
package main

import (
	"fmt"
	"sync"
)

func main(){
	var wg  sync.WaitGroup

	for i := 0;i< 100;i++ {
		wg.Add(1)

		go func(i int){
			defer wg.Done()
			fmt.Printf("goroutine end   %d \n",i)

		}(i)
	}

	//等待执行结果
	wg.Wait()
	fmt.Println("所有的goroutine执行完毕")
}
```

### Once对象

once对象可以被多次调用，但是只执行一次，若每次调用do是传入参数不同,但是只要有第一个才回被执行。

```go
package main

import (
	"fmt"
	"sync"
)

func main(){
	var once sync.Once
	onceBody := func(){
		fmt.Println("Run only once")
	}
	done := make(chan bool)

	for i:=0;i<10;i++{
		//虽然这段代码执行了10遍，但是onceBody只会执行一遍
		go func(){
			once.Do(onceBody)
			done <- true
		}()
		
	}

	for i:=0;i<10;i++{
		<-done
	}
}
```

### Cond

Cond实现了一个条件变量，一个线程集合地，供线程等待或者宣布某时间的发生。每个Cond实例都有也有一个相关的锁（一般是*Mutex或*RWMutex类型的值），它必须在改变条件时或者调用Wait方法时保持锁定。Cond可以创建为其他结构体的字段，Cond在开始使用后不能被拷贝。

```go
func NewCond(l Locker) *Cond
//广播通知
func (c *Cond) Broadcast()
//单发通知
func (c *Cond) Signal()
//等待通知
func (c *Cond) Wait()
```

下面是使用cond的一个实例

```go
package main

import (
	"fmt"
	"sync"
	"time"
)

var locker = new(sync.Mutex)
var cond = sync.NewCond(locker)


func test(x int) {
	//获取锁
	cond.L.Lock() 
	fmt.Println("aaa: ", x)
	//等待通知  暂时阻塞
	cond.Wait()
	fmt.Println("bbb: ", x)
	time.Sleep(time.Second * 2)
	//释放锁
	cond.L.Unlock()
}


func main() {
	for i := 0; i < 5; i++ {
		go test(i)
	}

	fmt.Println("start all")
	time.Sleep(time.Second * 1)
	fmt.Println("broadcast")
	// 下发一个通知给已经获取锁的goroutine
	cond.Signal()
	time.Sleep(time.Second * 1)
	// 3秒之后 下发一个通知给已经获取锁的goroutine
	cond.Signal()

	time.Sleep(time.Second * 1)
	//3秒之后 下发广播给所有等待的goroutine
	cond.Broadcast()
	time.Sleep(time.Second * 10)
	fmt.Println("finish all")

}

```

### pool

GC永远是性能的大杀器，因此在Go中为了减少GC带来的影响，提供了对象重用的机制，也就是sync.Pool对象池。不要看到Pool就想到数据库连接池哦，此次的池和你认为的那个池有区别的。sync.Pool是可伸缩的，并发安全的，可以被看作是一个存放可重用对象的值的容器，设计的目的是存放暂时的可重复使用的对象，在需要使用的时候直接从Pool中取出。因此将Pool放到sync包中有点迷惑。

__sync.Pool就是围绕New字段，Get和Put方法来使用。__ sync.Pool为每个P(对应CPU)都分配一个本地池，当执行Get或Put操作的时候，会先将Goroutine和某个P的子池关联，再对该池将进行操作,每个P的子池分为私有对象和共享对象，私有对象只能被特定的P访问，共享列表对象可以被任何P访问。因为同一时刻一个P只能执行一个goroutine，所以无需加锁，但是对共享列表对象进行操作时，因为可能有多个goroutine同时操作，所以需要加锁。下面是一个使用实例

```go
package main

import (
	"fmt"
	"runtime"
	"sync"
)

//sync.Pool是一个可以存或取的临时对象集合
//sync.Pool可以安全被多个线程同时使用，保证线程安全
//注意、注意、注意，sync.Pool中保存的任何项都可能随时不做通知的释放掉，所以不适合用于像socket长连接或数据库连接池。
//sync.Pool主要用途是增加临时对象的重用率，减少GC负担。

func main(){
	p := &sync.Pool{
		//New()函数的作用是当从Pool中Get对象时，如果pool为空，则先先通过New创建一个，插入pool中，然后返回对象
		New:func() interface{}{
			return make([]int, 16)
		},
	}

	s := p.Get().([]int)
	s[0]=1
	s[1]=2
	fmt.Printf("%p ===> %v\n",&s,s)
	//将一个对象存入到pool中
	p.Put(s)

	//存pool中取出一个对象
	c := p.Get().([]int)
	c[2] = 3
	fmt.Printf("%p ===> %v\n",&c,c)

	//强制GC
	runtime.GC()
	d := p.Get().([]int)
	fmt.Printf("%p ===> %v\n",&d,d)
}

```



至此go的sync包的基础使用都这些了，哎老了！API和源码翻了不下三遍连三分之一的没记住，一周后完全没印象不得不重新翻阅一遍。































