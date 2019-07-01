---
title: go网络编程之url
date: 2018-02-04 20:41:07
tags: GO
---

上一篇文章中已经总结了SOCKET和HTTP编程的一些基本方法、这一篇讲总结下GO中关于url的操作的部分。

统一资源定位符（url）,是互联网上定位和访问一个资源的一种简洁而有效的表示，可以说是有无数个url共同组成了互联网。当然这里的一般是指中心化的互联网，url指向那个主机资源就在台主机上。原本这种方式是没问题的，但是资源嘛肯定千奇白怪了，肯定有些某些不能公示的信息，因此某些手就触动了。干掉中心大家都别开。这就有了最近比较流行的去中心化的应用，就是大家都能通过统一的访问方式获取到资源，而没人知道资源再那台主机上。这就是去中心化的价值所在。扯多了，还是说GO（其实利用几百行GO就实现去中心化的应用）。下面是GO中关于net/url的操作的封装

```GO
// URL结构体
// scheme://[userinfo@]host/path[?query][#fragment]
type URL struct { 
    Scheme string 
    Opaque string // 编码后的不透明数据
    User *Userinfo // 用户名和密码信息 
    Host string // host或host:port
    Path string
    RawPath    string // encoded path hint (Go 1.5 and later only; see EscapedPath method)
    ForceQuery bool   // append a query ('?') even if RawQuery is empty
    RawQuery string // 编码后的查询字符串，没有'?' 
    Fragment string // 引用的片段（文档位置），没有'#' 
}


//对字符串进行安全编码(url编码)
func QueryEscape(s string) string
//对编码的字符串进行解码
func QueryUnescape(s string)(string,error)
//解析url
func (*URL) Parse(ref string)(*URL,error)
//
func ParseRequestURI(url string)(url *URL,err error)
// 函数在url为绝对地址是才返回真
func (u *URL) IsAbs() bool
// 解析RawQuery字段并返回其表示的Values类型键值对
func (u *URL) Query() Values
// 返回编码好的path?query或opaque?query字符串
func (*URL) RequestURI() string
// ParseQuery函数解析一个URL编码的查询字符串，并返回可以表示该查询的Values
func ParseQuery(query string) (m Values, err error)
// Encode方法将v编码为url编码格式(“bar=baz&foo=quux”)，编码时会以键进行排序
func (v Values) Encode() string

// Get会获取key对应的值集的第一个值。如果没有对应key的值集会返回空字符串
func (v Values) Get(key string) string 

func (v Values) Set(key, value string) 
func (v Values) Add(key, value string) 
func (v Values) Del(key string)

```

下面是一些编程的实例

```go
package main

import (
	"net/url"
	"log"
	"fmt"
)

func main() {

	u,err := url.Parse("http://bing.com/search?q=go-url")
	if err != nil{
		log.Fatal(err)
	}
	fmt.Println(u)

	u.Scheme = "https"
	u.Host = "google.com"
	q := u.Query()
	q.Set("q", "golang")
	q.Set("s","编程")
	u.RawQuery = q.Encode()
	// https://google.com/search?q=golang&s=%E7%BC%96%E7%A8%8B
	fmt.Println(u)

	fmt.Println(u.Path)
	fmt.Println(u.RawPath)
	fmt.Println(u.String())


	u1, err := url.Parse("../../..//search?q=dotnet")
	if err != nil {
		log.Fatal(err)
	}
	base, err := url.Parse("http://example.com/directory/")
	if err != nil {
		log.Fatal(err)
	}
	//http://example.com/search?q=dotnet
	fmt.Println(base.ResolveReference(u1))


	v := url.Values{}
	v.Set("name", "Ava")
	v.Add("friend", "Jess")
	v.Add("friend", "Sarah")
	v.Add("friend", "Zoe")
	// v.Encode() == "name=Ava&friend=Jess&friend=Sarah&friend=Zoe"

	//Ava
	fmt.Println(v.Get("name"))
	//Jess
	fmt.Println(v.Get("friend"))
	//[Jess Sarah Zoe]
	fmt.Println(v["friend"])
}

```

虽然说python编写爬虫很过瘾，但是利用GO编写一些固话的爬去任务还是相当过瘾的。

