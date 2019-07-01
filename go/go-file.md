---
title: GO文件处理
date: 2018-01-23 21:12:47
tags: GO
---

文件操作是程序常用的操作之一，在go中os.File封装了文件相关操作。File代表一个打开的文件对象。下面是一些提供的操作接口

```java
//返回File的内存地址，错误信息，通过os库调用
func Create(name string)(file *File,err Error)
//返回文件的地址地址，通过OS库调用
func NewFile(df int,name string) *File

//返回File的内存地址，错误信息，通过OS库调用
func Open(name string)(file *File,err Error)
//返回File的内存地址，错误信息，通过OS库调用
func OpneFile(name string,falg int,perm unit32)(file *File,err Error)
  
//写入一个slice，返回写的个数，错误信息，通过File的内存地址调用
func (file *File) Write(b []byte)(n int,err Error)
//从slice的某个文件开始希尔，返回写的个数，错误信息，通过File的内存地址调用
func (file *File) WriteAt(b []byte,off int64)(n int,err Error)
//写入一个字符串，返回写的个数，错误信息，通过File的内存地址调用
func (file *File) WriteString(s string)(ret int,err Error)
  
//读取一个slice返回读的个数，错误信息，通过File的内存地址调用
func (file *File) Read(b []byte)(n int,err Error)
//从slice的某个为止开始读取，返回督导的个数，错误信息，通过File的内存地址调用
  
//传入文件的路径来涮菜文件，返回错误个数
func Remove(name string) Error

```

下面是简单的文件操作

```java
package demo

import (
	"os"
	"fmt"
)

func file_demo(){
	//文件路径
	userFile := "/tmp/test.txt"
	//根据路径创建File的内存地址
	fout,err := os.Create(userFile)
	//延迟关闭资源
	defer fout.Close()
	if err != nil{
		fmt.Println(userFile,err)
		return
	}
	//循环写入数据到文件
	for i:=0;i<10;i++{
		//写入字符串
		fout.WriteString("Hello world!\r\n")
		//强转成byte slice后再写入
		fout.Write([]byte("abcd!\r\n"))
	}

	//打开文件,返回File的内存地址
	fin,err := os.Open(userFile)
	//延迟关闭资源
	defer fin.Close()
	if err != nil{
		fmt.Println(userFile,err)
		return
	}
	//创建一个初始容量为1024的slice,作为缓冲容器
	buf := make([]byte,1024)
	for{
		//循环读取文件数据到缓冲容器中,返回读取到的个数
		n,_ := fin.Read(buf)

		if 0==n{
			break //如果读到个数为0,则读取完毕,跳出循环
		}
		//从缓冲slice中写出数据,从slice下标0到n,通过os.Stdout写出到控制台
		os.Stdout.Write(buf[:n])
	}
}
```

使用bufio库

```java
package demo

import (
	"bufio"
	"io"
	"os"
)

func Bufio_Dmoe(){
	file_name :="/local/workspace/opslabGo/data/tmp/go_file.txt"
	file_out_name := "/local/workspace/opslabGo/data/tmp/go_file_buf_out.txt"
	fi,err := os.Open(file_name)
	if err != nil{
		panic(err)
	}
	defer fi.Close()
	//创建一个读取缓冲流
	r := bufio.NewReader(fi)

	fo,err := os.Create(file_out_name)
	if err != nil{
		panic(err)
	}
	//创建输出缓冲流
	w := bufio.NewWriter(fo)

	buf := make([]byte,1024)
	for{
		n,err := r.Read(buf)
		if err != nil && err != io.EOF{
			panic(err)
		}
		if n == 0{break}

		if n2,err := w.Write(buf[:n]);err != nil{
			panic(err)
		}else if n2 != n{
			panic("error in writing")
		}
	}
	if err = w.Flush(); err != nil{
		panic(err)
	}

}
```

使用ioutil

```java
package demo

import (
	"io/ioutil"
	"fmt"
)

func IOUtil_Demo()  {
	file_name :="/local/workspace/opslabGo/data/tmp/go_file.txt"
	file_iout_name := "/local/workspace/opslabGo/data/tmp/go_file_ioutil_out.txt"

	//文件读取
	b,err := ioutil.ReadFile(file_name)
	if err != nil{
		fmt.Print(err)
	}
	str := string(b)
	fmt.Println("file-content:",str)

	//文件写入
	err = ioutil.WriteFile(file_iout_name,[]byte(str),0644)
	if err != nil{
		panic(err)
	}
}

```

