go中有context包，专门用来简化对于处理单个请求的多个goroutine之间与请求域的数据、取消信号、截止时间等相关的操作。context包定义了Context接口类型，它可以具有生命周期、取消/关闭的channel信号等请求域范围的健值存储功能。因此可以用它来管理goroutine 的生命周期、或者与一个请求关联，在functions之间传递等。

```go
// Context 的实现应该设计为多例程安全的
type Context interface{
    //deadline returns the time when work done on behalf of this context should be canceld.
    //returns ok == false when on deadline is set
    //返回该context过期的时间和表示dealine是否被设置的bool值
 	//多次调用返回相同的过期时间值
    Deadline()(deadline time.Time, ok bool)
    
    //returns a channel that's closed when work done on behalf of this context 
    //should be canceld
    //返回一个channel,关闭该channel就代表关闭该Context,返回nil代表该Context不需被关闭
    Done() <-chan struct{}
    
    
    //returns a non-nil error value after done is closed
    //如果Context未关闭，则返回nil。
    //否则如果正常关闭,则返回Canceled，过期关闭则返回DeadlineExceeded
    //发生错误则返回对应的error。
    Err() error
    
    
    //returns the value associated with this context for key
    //根据key从Context中获取一个value，如果没有关联的值则返回nil
    Value(key interface{}) interface{}
}
```

在context包中定义了许多Context接口的实现，其中最简单的就是emptyCtx，并且通过该实现定义了俩个函数应用于获取context。

```go
var (
    //通常用作初始的Context、测试、最基层的根Context
	background = new(emptyCtx)
    //通常用作不清楚作用的Context，或者还未实现功能的场景
	todo       = new(emptyCtx)
)
```

有了根Context后可以通过如下主要方法实现自定义的用途

```go
//返回一个继承的context，这个context在父contex被关闭时关闭自己的done通道
//或者在自己被Cancel的时候关闭自己的Done。WithCancel同时还返回一个取消函数cancel
//这个cancel用于取消当前的Context。
func WithCancel(parent Context) (ctx Context, cancel CancelFunc)
//deadline保存了超时的时间，当超过这个时间，会触发cancel, 如果超过了过期时间，会自动撤销它的子context
func WithDeadline(parent Context, deadline time.Time) (Context, CancelFunc)
//可以用来控制goroutine超时
func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc)
// 可以把需要的信息放到context中，需要时把变量取出来
func WithValue(parent Context, key interface{}, val interface{}) Context

```

```go
package main

import (
    "context"
    "fmt"
    "math/rand"
    "time"
)

//Slow function
func sleepRandom(fromFunction string, ch chan int) {
    //defer cleanup
    defer func() { fmt.Println(fromFunction, "sleepRandom complete") }()
    //Perform a slow task
    //For illustration purpose,
    //Sleep here for random ms
    seed := time.Now().UnixNano()
    r := rand.New(rand.NewSource(seed))
    randomNumber := r.Intn(100)
    sleeptime := randomNumber + 100
    fmt.Println(fromFunction, "Starting sleep for", sleeptime, "ms")
    time.Sleep(time.Duration(sleeptime) * time.Millisecond)
    fmt.Println(fromFunction, "Waking up, slept for ", sleeptime, "ms")
    //write on the channel if it was passed in
    if ch != nil {
        ch <- sleeptime
    }
}

//Function that does slow processing with a context
//Note that context is the first argument
func sleepRandomContext(ctx context.Context, ch chan bool) {
    //Cleanup tasks
    //There are no contexts being created here
    //Hence, no canceling needed
    defer func() {
        fmt.Println("sleepRandomContext complete")
        ch <- true
    }()
    //Make a channel
    sleeptimeChan := make(chan int)
    //Start slow processing in a goroutine
    //Send a channel for communication
    go sleepRandom("sleepRandomContext", sleeptimeChan)
    //Use a select statement to exit out if context expires
    select {
    case <-ctx.Done():
        //If context is cancelled, this case is selected
        //This can happen if the timeout doWorkContext expires or
        //doWorkContext calls cancelFunction or main calls cancelFunction
        //Free up resources that may no longer be needed because of aborting the work
        //Signal all the goroutines that should stop work (use channels)
        //Usually, you would send something on channel,
        //wait for goroutines to exit and then return
        //Or, use wait groups instead of channels for synchronization
        fmt.Println("sleepRandomContext: Time to return")
    case sleeptime := <-sleeptimeChan:
        //This case is selected when processing finishes before the context is cancelled
        fmt.Println("Slept for ", sleeptime, "ms")
    }
}

//A helper function, this can, in the real world do various things.
//In this example, it is just calling one function.
//Here, this could have just lived in main
func doWorkContext(ctx context.Context) {
    //Derive a timeout context from context with cancel
    //Timeout in 150 ms
    //All the contexts derived from this will returns in 150 ms
    ctxWithTimeout, cancelFunction := context.WithTimeout(ctx, time.Duration(150)*time.Millisecond)
    //Cancel to release resources once the function is complete
    defer func() {
        fmt.Println("doWorkContext complete")
        cancelFunction()
    }()
    //Make channel and call context function
    //Can use wait groups as well for this particular case
    //As we do not use the return value sent on channel
    ch := make(chan bool)
    go sleepRandomContext(ctxWithTimeout, ch)
    //Use a select statement to exit out if context expires
    select {
    case <-ctx.Done():
        //This case is selected when the passed in context notifies to stop work
        //In this example, it will be notified when main calls cancelFunction
        fmt.Println("doWorkContext: Time to return")
    case <-ch:
        //This case is selected when processing finishes before the context is cancelled
        fmt.Println("sleepRandomContext returned")
    }
}
func main() {
    //Make a background context
    ctx := context.Background()
    //Derive a context with cancel
    ctxWithCancel, cancelFunction := context.WithCancel(ctx)
    //defer canceling so that all the resources are freed up
    //For this and the derived contexts
    defer func() {
        fmt.Println("Main Defer: canceling context")
        cancelFunction()
    }()
    //Cancel context after a random time
    //This cancels the request after a random timeout
    //If this happens, all the contexts derived from this should return
    go func() {
        sleepRandom("Main", nil)
        cancelFunction()
        fmt.Println("Main Sleep complete. canceling context")
    }()
    //Do work
    doWorkContext(ctxWithCancel)
}


```

