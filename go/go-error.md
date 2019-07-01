---
title: GO语言中的错误和异常处理
date: 2018-01-30 22:49:49
tags: GO
---

Go语言中没有想类C中的try/catch异常机制，但是有一套defer-panic-and-recover机制，Go的设计者觉得try/catch机制使用太泛滥了，而且从底层向更高的层级抛异常太消耗资源，因此Go的设计机制也可以捕获异常，但是更轻量，并且只应该作为处理的错误的最后手段。

Go中引入error接口来作为错误处理的标准模式，如果函数和方法中返回错误对象作为它们唯一或最后一个返回值，如果返回nil则没有发生错误，并且主调用者总是应该坚持错误。（有点类似错误码的机制）error可以逐层返回，直到被处理。

Go中引入俩个内置函数panic和recover来触发和中指异常处理流程，同时引入关键字defer来延迟执行defer后面的函数。一直等到包含defer语句的函数执行完毕时，延迟函数（defer后的函数）才会被执行，而不管包含defer语句的函数是通过return的正常结束，还是由于panic导致的异常结束。你可以在一个函数中执行多条defer语句，它们的执行顺序与声明顺序相反。当程序运行时，如果遇到引用空指针、下标越界或显式调用panic函数等情况，则先触发panic函数的执行，然后调用延迟函数。调用者继续传递panic，因此该过程一直在调用栈中重复发生：函数停止执行，调用延迟执行函数等。如果一路在延迟函数中没有recover函数的调用，则会到达该携程的起点，该携程结束，然后终止其他所有携程，包括主携程（类似于C语言中的主线程）。

简单的说当Gol的代码执行时，如果遇到defer的闭包调用，则压入堆栈。当函数返回时，会按照后进先出的顺序调用闭包。

下面代码演示了其工作过程

```go
//defer 需要放在 panic 之前定义，另外recover只有在 defer 调用的函数中才有效。
//recover处理异常后，逻辑并不会恢复到 panic 那个点去，函数跑到 defer 之后的那个点.
//多个 defer 会形成 defer 栈，后定义的 defer 语句会被最先调用
//panic (主动爆出异常) 与 recover （收集异常）
//recover 用来对panic的异常进行捕获. panic 用于向上传递异常，执行顺序是在 defer 之后。

func main() {
	f()
	fmt.Println("end")
}

func f() {
	defer func() {
		//必须要先声明defer，否则不能捕获到panic异常
		fmt.Println(".cc start")
		if err := recover(); err != nil {
			//这里的err其实就是panic传入的内容，"bug"
			fmt.Println(err)
		}
		fmt.Println(".cc end")
	}()
	for {
		fmt.Println("1")
		a := []string{"a", "b"}
		// 越界访问，肯定出现异常
		fmt.Println(a[3])
		// 上面已经出现异常了,所以肯定走不到这里了。
		panic("bug")
		//不会运行的.
		fmt.Println("4")
		time.Sleep(1 * time.Second)
	}
}

# 最终输出
1
.cc start
runtime error: index out of range
.cc end
end
```





https://blog.golang.org/error-handling-and-go

https://blog.golang.org/defer-panic-and-recover

