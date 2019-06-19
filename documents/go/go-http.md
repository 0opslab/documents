### http

在改包中定义了Client、Response、Header、Request、Cookie、ResponseWriter、Handler、HandlerFunc、Server、ServeMux组件，用于完成HTTP中的各个部分。

```go
func CanonicalHeaderKey(s string) string

func DetectContentType(data []byte) string

func Error(w ResponseWriter, error string, code int)

func Handle(pattern string, handler Handler)

func HandleFunc(pattern string, handler func(ResponseWriter, *Request))

func ListenAndServe(addr string, handler Handler) error

func ListenAndServeTLS(addr, certFile, keyFile string, handler Handler) error

func MaxBytesReader(w ResponseWriter, r io.ReadCloser, n int64) io.ReadCloser

func NotFound(w ResponseWriter, r *Request)

func ParseHTTPVersion(vers string) (major, minor int, ok bool)

func ParseTime(text string) (t time.Time, err error)

func ProxyFromEnvironment(req *Request) (*url.URL, error)

func ProxyURL(fixedURL *url.URL) func(*Request) (*url.URL, error)

func Redirect(w ResponseWriter, r *Request, url string, code int)

func Serve(l net.Listener, handler Handler) error

func ServeContent(w ResponseWriter, req *Request, name string, modtime time.Time, content io.ReadSeeker)

func ServeFile(w ResponseWriter, r *Request, name string)

func ServeTLS(l net.Listener, handler Handler, certFile, keyFile string) error

func SetCookie(w ResponseWriter, cookie *Cookie)

func StatusText(code int) string

type Client

func (c *Client) Do(req *Request) (*Response, error)

func (c *Client) Get(url string) (resp *Response, err error)

func (c *Client) Head(url string) (resp *Response, err error)

func (c *Client) Post(url string, contentType string, body io.Reader) (resp *Response, err error)

func (c *Client) PostForm(url string, data url.Values) (resp *Response, err error)

type CloseNotifier

type ConnState

func (c ConnState) String() string

type Cookie

func (c *Cookie) String() string

type CookieJar

type Dir

func (d Dir) Open(name string) (File, error)

type File

type FileSystem

type Flusher

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
//Hijacker接口由ResponseWriters实现，它允许HTTP处理程序接管连接
type Hijacker

type ProtocolError

func (pe *ProtocolError) Error() string

type PushOptions

type Pusher

type Request

func NewRequest(method, url string, body io.Reader) (*Request, error)

func ReadRequest(b *bufio.Reader) (*Request, error)

func (r *Request) AddCookie(c *Cookie)

func (r *Request) BasicAuth() (username, password string, ok bool)

func (r *Request) Context() context.Context

func (r *Request) Cookie(name string) (*Cookie, error)

func (r *Request) Cookies() []*Cookie

func (r *Request) FormFile(key string) (multipart.File, *multipart.FileHeader, error)

func (r *Request) FormValue(key string) string

func (r *Request) MultipartReader() (*multipart.Reader, error)

func (r *Request) ParseForm() error

func (r *Request) ParseMultipartForm(maxMemory int64) error

func (r *Request) PostFormValue(key string) string

func (r *Request) ProtoAtLeast(major, minor int) bool

func (r *Request) Referer() string

func (r *Request) SetBasicAuth(username, password string)

func (r *Request) UserAgent() string

func (r *Request) WithContext(ctx context.Context) *Request

func (r *Request) Write(w io.Writer) error

func (r *Request) WriteProxy(w io.Writer) error

type Response

func Get(url string) (resp *Response, err error)

func Head(url string) (resp *Response, err error)

func Post(url string, contentType string, body io.Reader) (resp *Response, err error)

func PostForm(url string, data url.Values) (resp *Response, err error)

func ReadResponse(r *bufio.Reader, req *Request) (*Response, error)

func (r *Response) Cookies() []*Cookie

func (r *Response) Location() (*url.URL, error)

func (r *Response) ProtoAtLeast(major, minor int) bool

func (r *Response) Write(w io.Writer) error

type ResponseWriter

type RoundTripper

func NewFileTransport(fs FileSystem) RoundTripper

type ServeMux

func NewServeMux() *ServeMux

func (mux *ServeMux) Handle(pattern string, handler Handler)

func (mux *ServeMux) HandleFunc(pattern string, handler func(ResponseWriter, *Request))

func (mux *ServeMux) Handler(r *Request) (h Handler, pattern string)

func (mux *ServeMux) ServeHTTP(w ResponseWriter, r *Request)

type Server

func (srv *Server) Close() error

func (srv *Server) ListenAndServe() error

func (srv *Server) ListenAndServeTLS(certFile, keyFile string) error

func (srv *Server) RegisterOnShutdown(f func())

func (srv *Server) Serve(l net.Listener) error

func (srv *Server) ServeTLS(l net.Listener, certFile, keyFile string) error

func (srv *Server) SetKeepAlivesEnabled(v bool)

func (srv *Server) Shutdown(ctx context.Context) error

type Transport

func (t *Transport) CancelRequest(req *Request)

func (t *Transport) CloseIdleConnections()

func (t *Transport) RegisterProtocol(scheme string, rt RoundTripper)

func (t *Transport) RoundTrip(req *Request) (*Response, error)
```





### httputil

```go
// DumpRequestOut is like DumpRequest but for outgoing client requests. It
// includes any headers that the standard http.Transport adds, such as
// User-Agent.
//DumpRequestOut就像DumpRequest，但是用于传出客户端请求。
//它包括标准http.Transport添加的任何标题，例如User-Agent
func DumpRequestOut(req *http.Request, body bool) ([]byte, error)


// The documentation for http.Request.Write details which fields
// of req are included in the dump.
// DumpRequest以HTTP/1.x线表示形式返回给定的请求。它只能被服务器用来调试客户端请求。
// 返回的表示只是一个近似值; 解析为http.Request时，初始请求的某些细节会丢失。
// 特别是头字段名称的顺序和大小写会丢失。多值头中值的顺序保持不变。
// HTTP/2请求以HTTP/1.x形式转储，而不是以其原始二进制表示
func DumpRequest(req *http.Request, body bool) ([]byte, error)


```

