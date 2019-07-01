os包提供了一些与平台无关的接口，虽然错误处理类似于GO，但设计类似与Unix，失败的调用返回类型错误的值而不是错误号。

```go
// 将当期工作目录更改为指定的目录
func Chdir(dir string) error
// 更改文件模式
func Chmod(name string, mode FileMode) error
// 更改指定文件的数字uid和gid
func Chown(name string, uid, gid int) error
// 更改指定文件的访问和修改时间
func Chtimes(name string, atime time.Time, mtime time.Time) error
// 删除所有环境变量
func Clearenv()
// 可执行文件返回启动当期进程的可执行文件的路径名称
func Environ() []string

func Executable() (string, error)
// 退出时会导致当期程序退出并显示给定的状态码
func Exit(code int)
//根据映射函数展开取代字符串中的 $ {var} 或 $ var 。
// 例如，os.ExpandEnv（s） 等同于 os.Expand（s，os.Getenv）
func Expand(s string, mapping func(string) string) string
//ExpandEnv 根据当前环境变量的值替换字符串中的 $ {var} 或 $ var
func ExpandEnv(s string) string
//Getegid 返回调用者的数字有效组 ID
func Getegid() int
//Getenv 检索由密钥命名的环境变量的值。它返回值，如果该变量不存在，该值将为空
func Getenv(key string) string
//Geteuid 返回调用者的数字有效用户标识
func Geteuid() int

//Getgroups 返回调用者所属组的数字 ID 列表
func Getgroups() ([]int, error)

//Getpid 返回调用者的进程 ID 
func Getpid() int
//Getppid 返回调用者父进程的 ID
func Getppid() int
//Getuid 返回调用者的数字用户标识
func Getuid() int
//Getwd 返回与当前目录对应的根路径名称
func Getwd() (dir string, err error)
//主机名返回内核报告的主机名
func Hostname() (name string, err error)
//IsExist 返回一个布尔值，指示是否已知错误报告文件或目录已存在
func IsExist(err error) bool
//IsNotExist 返回一个布尔值，指示是否已知错误报告文件或目录不存在
func IsNotExist(err error) bool

//IsPermission 返回一个布尔值，指示是否已知错误报告许可被拒绝
func IsPermission(err error) bool

//链接创建新名称作为旧名称文件的硬链接
func Link(oldname, newname string) error

func LookupEnv(key string) (string, bool)
//Mkdir 使用指定的名称和权限位创建一个新目录
func Mkdir(name string, perm FileMode) error
//MkdirAll 会创建一个名为 path 的目录以及任何必要的父项，并返回 nil ，否则返回错误
func MkdirAll(path string, perm FileMode) error

//Readlink 返回指定符号链接的目的地
func Readlink(name string) (string, error)
//删除将删除指定的文件或目录
func Remove(name string) error
//RemoveAll 移除路径及其包含的任何子项
func RemoveAll(path string) error
//重命名（移动）旧路径到新路径
func Rename(oldpath, newpath string) error
//SameFile 报告 fi1 和 fi2 是否描述相同的文件
func SameFile(fi1, fi2 FileInfo) bool
//Setenv 设置由密钥命名的环境变量的值
func Setenv(key, value string) error
//符号链接创建新名称作为旧名称的符号链接
func Symlink(oldname, newname string) error
//TempDir 返回用于临时文件的默认目录
func TempDir() string
//截断更改指定文件的大小
func Truncate(name string, size int64) error

func Unsetenv(key string) error

type File
//Create 使用模式0666（在 umask 之前）创建命名文件，如果它已经存在，则截断它
func Create(name string) (*File, error)
//NewFile 使用给定的文件描述符和名称返回一个新的 File
func NewFile(fd uintptr, name string) *File
//打开打开指定文件以供阅读
func Open(name string) (*File, error)
//OpenFile 是广义的公开呼叫；大多数用户将使用“打开”或“创建”
func OpenFile(name string, flag int, perm FileMode) (*File, error)
//管道返回一对连接的文件; 从写入w的r个返回字节中读取
func Pipe() (r *File, w *File, err error)
//Chdir 将当前工作目录更改为文件，该文件必须是目录
func (f *File) Chdir() error
//Chmod将文件的模式更改为模式
func (f *File) Chmod(mode FileMode) error
//Chown 更改指定文件的数字 uid 和 gid
func (f *File) Chown(uid, gid int) error
//关闭关闭文件，使其不能用于 I/O
func (f *File) Close() error
//Fd 返回引用打开文件的整数 Unix 文件描述符
func (f *File) Fd() uintptr
//Name 返回提供给 Open 的文件的名称
func (f *File) Name() string
//Read 从文件读取 len（b） 个字节
func (f *File) Read(b []byte) (n int, err error)
//ReadAt 从文件开始以字节偏移关闭读取 len（b） 个字节
func (f *File) ReadAt(b []byte, off int64) (n int, err error)
//Readdir 读取与文件关联的目录的内容，并以目录顺序返回最多 n 个 FileInfo 值的片段，Lstat 将返回该片段
func (f *File) Readdir(n int) ([]FileInfo, error)
//
func (f *File) Readdirnames(n int) (names []string, err error)
//Seek 将下一个 Read 或 Write on 文件的偏移量设置为偏移量，
//根据此解释：0表示相对于文件原点，1表示相对于当前偏移量，2表示相对于结束。
func (f *File) Seek(offset int64, whence int) (ret int64, err error)
//Stat 返回描述文件的 FileInfo 结构
func (f *File) Stat() (FileInfo, error)
//同步将文件的当前内容提交到稳定存储
func (f *File) Sync() error
//截断更改文件的大小。它不会更改 I/O 偏移量
func (f *File) Truncate(size int64) error

func (f *File) Write(b []byte) (n int, err error)

func (f *File) WriteAt(b []byte, off int64) (n int, err error)

func (f *File) WriteString(s string) (n int, err error)

type FileInfo

func Lstat(name string) (FileInfo, error)
//Stat 返回一个描述指定文件的 FileInfo
func Stat(name string) (FileInfo, error)

type FileMode
//IsDir 报告 m 是否描述目录
func (m FileMode) IsDir() bool
//IsRegular 报告 m 是否描述常规文件
func (m FileMode) IsRegular() bool
//Perm 以 m 为单位返回 Unix 权限位
func (m FileMode) Perm() FileMode

func (m FileMode) String() string

type LinkError

func (e *LinkError) Error() string

type PathError

func (e *PathError) Error() string

type ProcAttr

type Process
//FindProcess 通过它的 pid 查找正在运行的进程
func FindProcess(pid int) (*Process, error)
//StartProcess 使用由 name ，argv 和 attr 指定的程序，参数和属性启动一个新进程
func StartProcess(name string, argv []string, attr *ProcAttr) (*Process, error)
//杀死导致进程立即退出
func (p *Process) Kill() error
//释放将释放与进程 p 关联的任何资源，以便将来无法使用。只有等待时才需要调用 Release
func (p *Process) Release() error
//信号向过程发送信号。未在Windows上发送中断
func (p *Process) Signal(sig Signal) error
//等待进程退出，然后返回描述其状态和错误（如果有的话）的 ProcessState
func (p *Process) Wait() (*ProcessState, error)

type ProcessState

func (p *ProcessState) Exited() bool

func (p *ProcessState) Pid() int

func (p *ProcessState) String() string

func (p *ProcessState) Success() bool
//Sys 返回有关该过程的系统相关退出信息
func (p *ProcessState) Sys() interface{}
//SysUsage 返回有关退出进程的系统相关资源使用信息
func (p *ProcessState) SysUsage() interface{}
//SystemTime 返回退出进程及其子进程的系统 CPU 时间
func (p *ProcessState) SystemTime() time.Duration
//UserTime 返回退出进程及其子进程的用户 CPU 时间
func (p *ProcessState) UserTime() time.Duration
```

