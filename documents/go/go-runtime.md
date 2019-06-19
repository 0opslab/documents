尽管 Go 编译器产生的是本地可执行代码，这些代码仍旧运行在 Go 的 runtime（这部分的代码可以在 runtime 包中找到）当中。这个 runtime 类似 Java 和 .NET 语言所用到的虚拟机，它负责管理包括内存分配、垃圾回收（第 10.8 节）、栈处理、goroutine、channel、切片（slice）、map 和反射（reflection）等等.

该包中有几个非常有用的函数

```go
//使当前go程放弃处理器，以让其它go程运行。它不会挂起当前go程，因此当前go程未来会恢复执行
func Gosched()
//NumCPU返回本地机器的逻辑CPU个数
func NumCPU() int
//GOMAXPROCS设置可同时执行的最大CPU数，并返回先前的设置。 若 n < 1，它就不会更改当前设置。
//本地机器的逻辑CPU数可通过 NumCPU 查询。本函数在调度程序优化后会去掉
func GOMAXPROCS(n int) int
//GC执行一次垃圾回收
func GC()
//Goexit终止调用它的go程。其它go程不会受影响。Goexit会在终止该go程前执行所有defer的函数
func Goexit()
//NumGoroutine返回当前存在的Go程数
func NumGoroutine() int
// skip如果是0，返回当前调用Caller函数的函数名、文件、程序指针PC，1是上一层函数，以此类推
func Caller(skip int) (pc uintptr, file string, line int, ok bool)
//GoroutineProfile返回活跃go程的堆栈profile中的记录个数
func GoroutineProfile(p []StackRecord) (n int, ok bool)
```

### profile

分析 Go 程序的第一步是启用分析。支持使用标准测试包构建的性能分析基准测试。例如，以下命令在当前目录中运行基准测试并将 CPU 和内存配置文件写入 cpu.prof 和 mem.prof：

```go
go test -cpuprofile cpu.prof -memprofile mem.prof -bench .
```

要为独立程序添加等效分析支持，请将以下代码添加到主函数中：

```go
var cpuprofile = flag.String("cpuprofile", "", "write cpu profile `file`")
var memprofile = flag.String("memprofile", "", "write memory profile to `file`")

func main() {
    flag.Parse()
    if *cpuprofile != "" {
        f, err := os.Create(*cpuprofile)
        if err != nil {
            log.Fatal("could not create CPU profile: ", err)
        }
        if err := pprof.StartCPUProfile(f); err != nil {
            log.Fatal("could not start CPU profile: ", err)
        }
        defer pprof.StopCPUProfile()
    }

    // ... rest of the program ...

    if *memprofile != "" {
        f, err := os.Create(*memprofile)
        if err != nil {
            log.Fatal("could not create memory profile: ", err)
        }
        runtime.GC() // get up-to-date statistics
        if err := pprof.WriteHeapProfile(f); err != nil {
            log.Fatal("could not write memory profile: ", err)
        }
        f.Close()
    }
}
```

