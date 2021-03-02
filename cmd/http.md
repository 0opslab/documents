# title{http - 一款命令行下的http工具}

```bash
# Custom HTTP method HTTP headers and JSON data:
#自定义HTTP方法HTTP标头和JSON数据：
http PUT example.org X-API-Token:123 name=John

# Submitting forms:
#提交表格：
http -f POST example.org hello=World

# See the request that is being sent using one of the output options:
#请参阅使用以下输出选项之一发送的请求：
http -v example.org

# Use Github API to post a comment on an issue with authentication:
#使用Github API对身份验证问题发表评论：
http -a USERNAME POST https://api.github.com/repos/jkbrzt/httpie/issues/83/comments body='HTTPie is awesome!'

# Upload a file using redirected input:
#使用重定向输入上传文件：
http example.org < file.json

# Download a file and save it via redirected output:
#下载文件并通过重定向输出保存：
http example.org/file > file

# Download a file wget style:
#下载文件wget样式：
http --download example.org/file

# Use named sessions_ to make certain aspects or the communication
#使用命名的sessions_来进行某些方面或沟通
# persistent between requests to the same host:
#在对同一主机的请求之间持久化：
# http --session=logged-in -a username:password httpbin.org/get API-Key:123
#http --session =登录 - 用户名：密码httpbin.org/get API-Key：123
http --session=logged-in httpbin.org/headers

# Set a custom Host header to work around missing DNS records:
#设置自定义主机标头以解决丢失的DNS记录：
http localhost:8000 Host:example.com

# Simple JSON example:
#简单的JSON示例：
http PUT example.org name=John email=john@example.org

# Non-string fields use the := separator, which allows you to embed raw
#非字符串字段使用：=分隔符，允许您嵌入raw
# JSON into the resulting object. Text and raw JSON files can also be
#JSON进入结果对象。文本和原始JSON文件也可以
# embedded into fields using =@ and :=@:
#使用= @和：= @嵌入到字段中：
http PUT api.example.com/person/1 name=John age:=29 married:=false hobbies:='["http", "pies"]' description=@about-john.txt bookmarks:=@bookmarks.json

# Send JSON data stored in a file:
#发送存储在文件中的JSON数据：
http POST api.example.com/person/1 < person.json

# Regular Forms
#常规表格
http --form POST api.example.org/person/1 name='John Smith' email=john@example.org cv=@~/Documents/cv.txt

# File Upload Forms
#文件上传表格
# If one or more file fields is present, the serialization and content
#如果存在一个或多个文件字段，则为序列化和内容
# type is multipart/form-data:
#type是multipart / form-data：
http -f POST example.com/jobs name='John Smith' cv@~/Documents/cv.pdf

# To set custom headers you can use the Header:Value notation:
#要设置自定义标头，您可以使用标头：值表示法：
http example.org  User-Agent:Bacon/1.0  'Cookie:valued-visitor=yes;foo=bar' X-Foo:Bar  Referer:http://httpie.org/

# Basic auth:
#基本认证：
http -a username:password example.org

# Digest auth:
#摘要身份验证：
http --auth-type=digest -a username:password example.org

# With password prompt:
#使用密码提示：
http -a username example.org

# Authorization information from your ~/.netrc file is honored as well:
#来自〜/ .netrc文件的授权信息也受到尊重：
cat ~/.netrc
    machine httpbin.org
    login httpie
    # password test
http httpbin.org/basic-auth/httpie/test

# You can specify proxies to be used through the --proxy argument for each
#您可以通过每个的--proxy参数指定要使用的代理
# protocol (which is included in the value in case of redirects across
#协议（在重定向的情况下包含在值中
# protocols):
#协议）：
http --proxy=http:http://10.10.1.10:3128 --proxy=https:https://10.10.1.10:1080 example.org

# With Basic authentication:
#使用基本认证：
http --proxy=http:http://user:pass@10.10.1.10:3128 example.org

# To skip the HOST'S SSL CERTIFICATE VERIFICATION, you can pass
#要跳过主机的SSL证书验证，您可以通过
# --verify=no (default is yes):
#--verify = no（默认为是）：
http --verify=no https://example.org

# You can also use --verify=<CA_BUNDLE_PATH> to set a CUSTOM CA BUNDLE path:
#您还可以使用--verify = <CA_BUNDLE_PATH>来设置CUSTOM CA BUNDLE路径：
http --verify=/ssl/custom_ca_bundle https://example.org

# To use a CLIENT SIDE CERTIFICATE for the SSL communication, you can pass
#要使用CLIENT SIDE CERTIFICATE进行SSL通信，您可以通过
# the path of the cert file with --cert:
#使用--cert的cert文件的路径：
http --cert=client.pem https://example.org

# If the PRIVATE KEY is not contained in the cert file you may pass the
#如果证书文件中没有包含私钥，您可以通过
# path of the key file with --cert-key:
#使用--cert-key的密钥文件的路径：
http --cert=client.crt --cert-key=client.key https://example.org

# You can control what should be printed via several options:
#您可以通过以下几个选项控制应该打印的内容：
  # --headers, -h   Only the response headers are printed.
  # --body, -b      Only the response body is printed.
  # --verbose, -v   Print the whole HTTP exchange (request and response).
  # --print, -p     Selects parts of the HTTP exchange.
http --verbose PUT httpbin.org/put hello=world

# Print request and response headers:
#打印请求和响应标头：
  # Character   Stands for
  # ----------- -------------------
  # H           Request headers.
  # B           Request body.
  # h           Response headers.
  # b           Response body.
http --print=Hh PUT httpbin.org/put hello=world

# Let's say that there is an API that returns the whole resource when it
#假设有一个API可以在返回时返回整个资源
# is updated, but you are only interested in the response headers to see
#已更新，但您只对要查看的响应标头感兴趣
# the status code after an update:
#更新后的状态代码：
http --headers PATCH example.org/Really-Huge-Resource name='New Name'

# Redirect from a file:
#从文件重定向：
http PUT example.com/person/1 X-API-Token:123 < person.json

# Or the output of another program:
#或者另一个程序的输出：
grep '401 Unauthorized' /var/log/httpd/error_log | http POST example.org/intruders

# You can use echo for simple data:
#您可以将echo用于简单数据：
echo '{"name": "John"}' | http PATCH example.com/person/1 X-API-Token:123

# You can even pipe web services together using HTTPie:
#您甚至可以使用HTTPie将Web服务连接在一起：
http GET https://api.github.com/repos/jkbrzt/httpie | http POST httpbin.org/post

# You can use cat to enter multiline data on the terminal:
#您可以使用cat在终端上输入多行数据：
cat | http POST example.com
    <paste>
    # ^D
cat | http POST example.com/todos Content-Type:text/plain
    - buy milk
    - call parents
    ^D

# On OS X, you can send the contents of the clipboard with pbpaste:
#在OS X上，您可以使用pbpaste发送剪贴板的内容：
pbpaste | http PUT example.com

# Passing data through stdin cannot be combined with data fields specified
#通过stdin传递数据不能与指定的数据字段组合
# on the command line:
#在命令行上：
echo 'data' | http POST example.org more=data   # This is invalid


# AN ALTERNATIVE TO REDIRECTED stdin is specifying a filename (as
#重定向stdin的替代方法是指定文件名（如
# @/path/to/file) whose content is used as if it came from stdin.
#@ / path / to / file）其内容被用作来自stdin的内容。

# It has the advantage that THE Content-Type HEADER IS AUTOMATICALLY SET
#它的优点是内容类型标题是自动设置的
# to the appropriate value based on the filename extension. For example,
#基于文件扩展名的适当值。例如，
# the following request sends the verbatim contents of that XML file with
#以下请求发送该XML文件的逐字内容
# Content-Type: application/xml:
#Content-Type：application / xml：
http PUT httpbin.org/put @/data/file.xml

# Download a file:
#下载文件：
http example.org/Movie.mov > Movie.mov

# Download an image of Octocat, resize it using ImageMagick, upload it
#下载Octocat的图像，使用ImageMagick调整大小，上传
# elsewhere:
#别处：
http octodex.github.com/images/original.jpg | convert - -resize 25% -  | http example.org/Octocats

# Force colorizing and formatting, and show both the request and the
#强制着色和格式化，并显示请求和
# response in less pager:
#响应更少的寻呼机：
http --pretty=all --verbose example.org | less -R

# When enabled using the --download, -d flag, response headers are printed
#使用--download，-d标志启用时，将打印响应标头
# to the terminal (stderr), and a progress bar is shown while the response
#到终端（stderr），响应时显示进度条
# body is being saved to a file.
#正在将正文保存到文件中。
http --download https://github.com/jkbrzt/httpie/tarball/master

# You can also redirect the response body to another program while the
#您还可以将响应正文重定向到另一个程序
# response headers and progress are still shown in the terminal:
#响应标头和进度仍显示在终端中：
http -d https://github.com/jkbrzt/httpie/tarball/master |  tar zxf -

# If --output, -o is specified, you can resume a partial download using
#如果指定了--output，-o，则可以使用恢复部分下载
# the --continue, -c option. This only works with servers that support
#--continue，-c选项。这仅适用于支持的服务器
# Range requests and 206 Partial Content responses. If the server doesn't
#范围请求和206部分内容响应。如果服务器没有
# support that, the whole file will simply be downloaded:
#支持，只需下载整个文件：
http -dco file.zip example.org/file

# Prettified streamed response:
#Prettified流媒体响应：
http --stream -f -a YOUR-TWITTER-NAME https://stream.twitter.com/1/statuses/filter.json track='Justin Bieber'

# Send each new tweet (JSON object) mentioning "Apple" to another
#将每个提及“Apple”的新推文（JSON对象）发送给另一个
# server as soon as it arrives from the Twitter streaming API:
#服务器一旦从Twitter流媒体API到达：
http --stream -f -a YOUR-TWITTER-NAME https://stream.twitter.com/1/statuses/filter.json track=Apple | while read tweet; do echo "$tweet" | http POST example.org/tweets ; done

# Create a new session named user1 for example.org:
#为example.org创建一个名为user1的新会话：
http --session=user1 -a user1:password example.org X-Foo:Bar

# Now you can refer to the session by its name, and the previously used
#现在，您可以按名称和之前使用的方式引用会话
# authorization and HTTP headers will automatically be set:
#将自动设置授权和HTTP标头：
http --session=user1 example.org

# To create or reuse a different session, simple specify a different name:
#要创建或重用其他会话，只需指定其他名称：
http --session=user2 -a user2:password example.org X-Bar:Foo

# Instead of a name, you can also directly specify a path to a session
#您也可以直接指定会话的路径，而不是名称
# file. This allows for sessions to be re-used across multiple hosts:
#文件。这允许跨多个主机重用会话：
http --session=/tmp/session.json example.orghttp --session=/tmp/session.json admin.example.orghttp --session=~/.httpie/sessions/another.example.org/test.json example.orghttp --session-read-only=/tmp/session.json example.org
```