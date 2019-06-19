title: Java IO
date: 2016-01-12 22:17:23
tags: Java
categories: Java
---
Java IO操作主要是指使用于Java进行输入、输出操做。在Java中所有的操作类（不包括java.nio）都存放在java.io包中，
在使用时只需要倒入该包即可。
在整个java.io包中最重要的就是5个类和一个借口。五个类之的是**File**、**OutputStream**、**InputStream**、**Writer**、**Reader**
一个借口指的是**Serializeble**.下面是一个简要的说明

```java
抽象积累:InputStream(**字节输入**)/OutputStream(**字节输出**)/Reader(**字字符输入**)/Writer(**字符输出**)
访问文件:FileInputStream/FileOutputStream/FileReader/FileWriter
访问内存数组:ByteArrayInputStream/ByteArrayOutputStream/CharArrayReader/CharArrayWriter
管道:PipedInputStream/PipedOutputStream/PiepedReader/PipedWriter
缓冲流:BufferedInputStream/BufferedOutputStream/BufferedReader/BufferedWriter
字符串转换流:StringReaderInputStreamReader/OutputStreamWriter
对象流:ObjectInputStream/ObjectOutputStream
抽象类:FilterInputStream/FilterOutStream/FilterRader/FilterWriterPrintWriter
打印流:PrintStream/PrintWriter
退回流:PushbackInputStream/PushbackReader
数据操作流:DataInputStream/DataOutputStream
```



## 文件操作类File

在整个io包中,唯一与文件本身有关的类就是File类.适用File类可以进行创建或删除文件等常用的操作.要适用File类,则首先要观察File类的构造方法,此类的常用
构造方法如下:
```java
public File(String  pathname)         //实例化File类时,必须设置好路径
```
即必须向File类的构造方法中传递一个文件路径.要操作文件,还需要适用File类中定义的若干方法,File类中的主要方法如下:
```java
static final String pathSeparator        //常量路径的分隔符号
static final String separator //常量表示路径的分隔符
public File(String  pathname ) //构造:创建File类对象
boolean createNewFile() //创建新文件
boolean delete() //删除文件
boolean exists() //判断文件是否存在
boolean isDirectory() //判断给定的路径是否是一个目录
long  length() //返回文件的大小
String[] list() //列出指定目录的全部内容,只列出了名称
File[]  listFiles() //列出指定目录的全部内容,会列出路径
boolean mkdir() //创建一个目录
boolean renameTo(File dest) //为已有的文件重新命令
```

### 文件过滤器

在File类的list()方法中可以接收一个FilenameFilter参数,通过该参数可以只列出符合条件的文件.
FilenameFilter接口里包含了一个accept(File dir,String  name)方法.该方法将一次对指定的File的所有子目录或文件进行迭代,如果
该方法返回true,则list()方法会列出该子目录或者文件.
```java
public class FilenameFilterTest{
public static void main(String[] args){
File file= new File(".");
String[] list = file.list(new MyFilenameFilter());
for(String name:list){
System.out.print(name);
}

}
}
class MyFilenameFilter implements FilenameFilter{
public boolean accept(File dir,String name){
//如果文件名以.java结尾.或者文件名对应一个路径返回true
return name.endsWith(".java")
|| new File(name).isDriectory();
}
}
```

### RandomAccessFile类

File类只是针对文件本身进行操作,而如果要对内容进行操作,则可以适用RandomAccessFile类.此类属于随机读取类,可以随机地读取一个文件中指定位置的数据.

注意:
如果要实现随机方法,则每个数据项的长度应该保持一致.
例如有如下的数据项:
zhangsan : 30
lisi:31
wangwu:32


要实现功能,则必须依靠RandomAccess中的几种设置模式,然后在构造方法中传递此模式.此类常用的方法如下:
```java
RandomAccessFile(File file,String mode)	//	接收File类的对象,指定操作路径,模式有r 指定 w只写 rw为读写
RnadomAccessFile(String name,String mode)	//	直接传入一个文件路径
void  close()	//	关闭
int  read(byte[] b)	//	将内容读取到一个byte数组中
final byte readByte()	//	读取一个字节
final int readInt()	//	从文件中读取整型数据
void seek(long pos)	//	设置读指针的位置
fianl void writeBytes(String  s)	//	将一个字符串写入到文件中,按字节的方式处理
final void writeInt(int v)	//	将一个int类型数据写入文件,长度为4位
int skipBytes(int n)	//	指针跳过多少个字节
```


例子:
```java
package classfile;
import java.io.File;
import java.io.RandomAccessFile;

public class RandomFile{
public static void main(String[] args) throws Exception{

File f = new File("d:"+File.separator+"test.txt");
RandomAccessFile rdf = null;
rdf = new RandomAccessFile(f,"rw");

String name=null;
int age = 0;
name ="zhangsan";
age =30;
rdf.writeBytes(name);
rdf.writeInt(age);
name="lisi    ";
age =31;
rdf.writeBytes(name);
rdf.writeInt(age);
name="wangwu  ";
age =32;
rdf.writeBytes(name);
rdf.writeInt(age);


rdf.close();


RandomAccessFile red = null;
red = new RandomAccessFile(f,"rw");
byte b[] = new byte[8];
red.skipBytes(12);
for(int i = 0;i<b.length;i++){
b[i] = red.readByte();
}
System.out.println(new String(b));
System.out.println(red.readInt());

}
}
```
### 文件锁

适用文件锁可以有效的阻止多个进程并发的修改同一个文件.从JDK  1.4开始支持文件锁.在NIO中,java提供了FileLock来支持文件锁功能.在FileChannel中提供了
lock()/tryLock()方法,可以获得文件锁FileLock对象.从而锁定文件.
lock方法在视图锁定某个文件时,如果无法锁定将一直阻塞.
tryLock是尝试锁定文件,它将直接返回,如果获得文件锁就返回文件锁,否则返回null.
该类提供了如下方法:
+lock() //获取对此通道的文件的独占锁定。
+abstract  FileLock  lock(long position, long size, boolean shared)  //获取此通道的文件给定区域上的锁定。
+tryLock() //试图获取对此通道的文件的独占锁定。
+abstract  FileLock tryLock(long position, long size, boolean shared) //试图获取对此通道的文件给定区域的锁定。
当shared为true时,表明该锁是一个共享锁.它将允许多个进程来读取该文件.但阻止其他进程获取对该文件的排它锁.
当shared为false时,表明该锁是一个排它锁.它将锁住对该文件的读写.
程序可以通过调用FileLock的isShared来判断它获得的锁是否为共享锁.
处理完文件后通过FileLock的release()方法释放文件锁.

## 字节流和字符流

Java的IO流是实现输入/输出的基础.它可以方便地实现数据的输入/输出操作.java中把不同的输入/输出源抽象成"流(Stream)".通过流的方式运行Java程序使用
相同的方式访问不同的输入/输出源.
在程序中所有的数据都是以流的方式进行传输或保存的.程序需要数据时要适用输入流读取数据,而当程序需要将一些数据保存起来时,就要适用输出流.
在java.io包中流的操作主要有字节流,字符流俩大类,俩类都有输入和输出操作.在字节流中输出数据主要适用OutputStream类完成.输入适用的是InputStream类.
在字符流中输出主要是适用Writer类完成,输入主要使用Reader类完成.

在java中IO操作也是有相应步骤的.以文件的操作为列,主要的操作流程如下:
+ 使用File类打开一个文件
+ 通过字节流或字符流的子类指定输出的位置
+ 进行读/写操作
+ 关闭输入/输出
### 字节输出流OutputStream

OutputStream是整个IO包中字节输出流的最大父类.此类的定义如下:

public abstract class OutputStream extends Object implements Closeable,Flushable
从定义上可以发现,此类是抽象类.如果要使用此类,则首先必须通过子类实例化对象,如果现在要操作的是一个文件,则可以使用FileOutputStream类.通过向上转型后
可以为OutputStream实例化,在OutputStream类中的主要操作方法如下:
```java
方法	类型	描述
void close()	普通	关闭输出流
void flush()	普通	刷新缓冲区
void write(byte[] b)	普通	将一个byte数组写入数据流
void write(byte[] b,int off,int len)	普通	将一个指定范围的byte数组写入数据流
abstract void write(int b)	普通	将一个字节数据写入数据流
```
将一个字节数据写入数据流
```java
package classfile;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;

public class writeStrFile{
public static void main(String[] agrs) throws Exception {
File f = new File("d:"+File.separator+"test.txt");
OutputStream out = null;
out = new FileOutputStream(f);

String str = "hello World";
byte b[] = str.getBytes();
out.write(b);
out.close();
}
}
```

### 字节输入流InputStream

通过InputStream从文件中把内容读取进来.该类的定义如下:
public  abstract class InputStream extends Object implements Closeable
该类同样也是抽象类.要想使用需要使用子类类实例化.例如操作文件可以使用FileInputStream类.该类中主要的方法有:
```java
int available()	普通	可以取得输出文件的大小
void close()	普通	关闭输入流
abstract int read()	普通	读取内容,以数字的方式读取
int read(byte[] b)	普通	将内容读到byte数组中,同时返回读入的个数
```

将内容读到byte数组中,同时返回读入的个数


```java
package classfile;
import java.io.File;
import java.io.InputStream;
import java.io.FileInputStream;

public class readStrFile{
public static void main(String[] args)throws Exception{
File f = new File("d:"+File.separator+"test.txt");
InputStream input = null;
input = new FileInputStream(f);

int len = 0;
byte b[] = new byte[1024];
int temp = 0;
while((temp = input.read())  != -1 ){
b[len] = (byte)temp;
len++;
}
input.close();
System.out.println("content:"+new String(b,0,len));
}
}
```
### 字符流

在程序中一个字符等于俩个字节,所以java提供了Reader和Writer俩个专门操作字符流的类.
字符输出流Writer

Writer本身是一个字符流的输出流,此类的定义如下:
```java
public abstract class Writer extends Object implements Appendable,Closeabe,Flushable
本类本身也是一个抽象类.如果要使用此类,则肯定要使用其子类.此时如果要想文件中写入内容,应该使用FileWriter的子类.Wirter类的常用方法如下:
abstract void close()	普通	关闭输出流
void write(String str)	普通	将字符串输出
void write(char[] cbuf)	普通	将字符数组输出
abstract void flush()	普通	强制性清空缓存
```


### 字符输入流Reader

Reader是使用字符的方式从文件中取出数据.该类的定义如下:
public abstract class Reader extends Object  implements Readable,Closeable
同样该类也是抽象类.如果从文件中读取内容可以直接使用FileReader子类.该类的常用方法如下:
```java
abstract void close()	普通	关闭
int read()	普通	读取单个字符
int read(char[]  cbuf)	普通	将内容读到字符数组中,返回读入的长度
```





### 字节流与字符流的区别

字节流与字符流的使用非常相似,但还是存在这本质的区别.
实际上字节流在操作时本身不会用到缓冲区.是文件本身直接操作的.而字符流在操作时使用了缓冲区.

### 转换流OutputStreamWriter与InputStreamReader

整个IO包实际上分为字节流和字符流,但是除了这个俩个流之外,还存在一组字节流-字符流的转换类.
OutputStreamWriter: 是Writer的子类.将输出的字符流变为字节流,即将一个字符流的输出对象变为字节流输出对象
InputStreamReader: 是Reader的子类.将输入的字节流变为字符流,即将一个字节流的输入对象变为字符流的输入对象.
如果以文件操作为列.则在内存中的字符数据需要通过OutputStreamWriter变为字节流才能保存在文件中,读取时需要将读入的字节流通过InputStreamReader变为字符流.

将字节输出流变为字符输出流:
```java
package classfile;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;

public class OutputStreamWrite{
public static void main(String[] args)throws Exception{
File f = new File("D:"+File.separator+"test.txt");
Writer out = null;
//字节流变为字符流
out = new OutputStreamWriter(new FileOutputStream(f));
out.write("hello world");
out.write("禅师");
out.close();
}
}


将字节输入流变为字符输入流
package classfile;
import java.io.*;
public class InputStreamReade{
public static void main(String[] args)throws Exception{
File f = new File("d:"+File.separator+"test.txt");
Reader read = new InputStreamReader(new FileInputStream(f));
char[] c= new char[1024];
int len = read.read(c);
read.close();
System.out.println(new String(c,0,len));
}
}
```

### 内存操作流

输出和输入可以是从文件,也可以是来自内存,此时就要使用ByteArrayInputStream. ByteArrayOuputStream来完成输入和输出功能.
其中ByteArrayInputStream主要完成将内容写入到内存中,而ByteArrayOutputStream的功能主要是将内存中的数据输出.

ByteArrayInputStream类

该类的主要方法有:
构造方法:
```java
ByteArrayInputStream(byte[]  buf) //将全部的内容写入内存中
ByteArrayInputStream(byte[] buf,int offset,int length) //将指定范围的内容写入到内存中
该类主要使用构造方法将全部的内容读取到内存中,如果要想把内容从内存中取出,则可以使用ByteArrayOutputStream类.
ByteArrayOuputStream类

//构造
ByteArrayOutputStream() //创建对象
//方法
void write() //将内容从内存中输出
```
下面是个例子
```java
import java.io.*;
public class ByteArrayStream{
public static void main(String[] args)throws Exception{
String str="HELLOWORLD";
ByteArrayInputStream bis = null;
ByteArrayOutputStream bos = null;

bis = new ByteArrayInputStream(str.getBytes());
bos = new ByteArrayOutputStream();

int temp = 0;
while((temp = bis.read()) != -1){
char c = (char)temp;
bos.write(Character.toLowerCase(c));
}
String newStr = bos.toString();

bis.close();
bos.close();
System.out.println(newStr);
}
}
```


内存操作流一般在生成一些临时信息时才会使用,而这些临时信息如果要保存在文件中的话,运行完后还要删除文件,此时使用内存操作流是最合适的.

### 管道流


管道流的主要作用是可以进行俩个线程间的通信,管道流分为输出流(PipedOutputStream)和管道输入流(PipedInputStream).如果要想进行管道输出,则必须把输出流连在输入流上.在PipedOutputStream类上有如下方法用于管道连接:
```java
public  void connect(PipedInputStream snk) throws IOException
package classfile;
import java.io.*;
class Send implements Runnable{
private PipedOutputStream pos = null;
public Send(){
this.pos = new PipedOutputStream();
}
public void run(){
String str = "hello ";
try{
this.pos.write(str.getBytes());
this.pos.close();
}catch(IOException e){
e.printStackTrace();
}
}
public PipedOutputStream getPos(){
return this.pos;
}
}
class Receive implements Runnable{
private PipedInputStream pis = null;
public Receive(){
this.pis = new PipedInputStream();
}
public void run(){
byte b[] = new byte[1024];
int len = 0;

try{
len= this.pis.read(b);
this.pis.close();
} catch(IOException e){
e.printStackTrace();
}
System.out.println("Receive:" + new String(b,0,len));
}

public PipedInputStream getPis(){
return pis;
}
}
public class piped{
public static void main(String[] args){
Send s = new Send();
Receive r = new Receive();
try{
s.getPos().connect(r.getPis());
}catch(IOException e){
e.printStackTrace();
}
new Thread(s).start();
new Thread(r).start();
}
}
```


### 打印流


在整个IO包中,打印流是输出信息最方便的类,主要包含字节流打印流(PrintStream)和字符打印流(PrintWriter).打印流提供了非常方便的打印功能.可以打印任何的数据类型.
PrintStream是OutputStream的子类.PrintStream类的常用方法:

```java
构造方法:
PrintStream(File  file) //通过一个File对象实例化PrintStream类
PrintStream(OutputStream  out) //接收OutputStream对象.实例化PrintStream对象
方法:
PrintStream printf(Locale l,String format,Object ... args); //根据指定的Locale进行格式化输出
PrintStream  printf(String format,Object ... args) //根据本地环境格式化输出
void  print(boolean  b) //次方被重载很多次,输出任意数据
void println(boolean b) //此方法被重载很多此.
```
### System类对IO的支持

在System中也对IO给予了一定的支持.System类中定义了3个常量.这3个常量在IO操作中有着非常大的作用.
```java
public static final PrinStream   out	对应系统标准输出,一般是显示器
public static final PrintStream   err	错误信息输出
public static final InputStream   in	对应着标准输入,一般是键盘
```


System.out

该常量是PrintStream的对象,在该类中常用的方法有print()和println()方法.而PrintStream类有是OutputStream类的子类.也就是说OutputStream的那个子类为其实例化,就具备了向那里输出的能力.
System.err

该常量标识的是错误信息输出,如果程序错误,则可以直接使用System.err进行输出
System.in

System.in实际上是一个键盘的输入流.其本身是InputStream类型的对象.那么此时就可以利用System.in完成从键盘读入数据的功能.

```java
import java.io.InputStream;
public class input{
public static void main(String[] args) throws Exception{
InputStream in = System.in;
byte[]  b = new byte[1024];
System.out.print("please input:");
int len = in.read(b);
System.out.println("content:"+ new String(b,0,len));

in.close();
}
}
```


### 输入/输出重定向

System.out  System.err System.in 3个常量的比较常用,但是也可以通过System类也可以改变System.in的输入流来源以及System.out和System.err俩个输出流的位置.
System类提供的重定向方法:
```java
public static void setOut(PrintStream  out) //重定向标准输出流
public static void setErr(PrintStream err) //重定向标准错误输出流
public static void setIn(InputStream  in) //重定向标准输入流
```
### 键盘输入Scanner

包:java.util.Scanner
使用Scanner类可以很方便的获取用户的键盘输入,Scanner是一个基于正则表达式的文件扫描器.它可以从文件,输入流,字符串中解析出基本类型和字符串值.
Scanner类提供了多个构造器,不同的构造器可以接收文件,输入流,字符串作为数据源.用于从文件,输入流,字符串中解析数据.
Scanner主要提供了俩个方法用来扫描输入:
```java
+ hasNextXXX(): 是否还有下一个输入项.XXX可以标识Int long等基本数据类型.如果需要判断是否有下一个字符串,则可以省略XXX
+ nextXXX() : 获取下一个输入项.默认清空下使用空白作为多个输入项之间的分隔符:
+ boolean   hasNextLine() //返回输入源中是否存在下一行
+ String nextLine() //返回输入源中下一行的字符串
```
实例
```java
import java.util.Scanner;
public class scann{
public static void main(String[] args){
Scanner sc = new Scanner(System.in);
sc.useDelimiter("\n");
while(sc.hasNext()){
System.out.println("content:"+sc.next());
}
}
}
```

Scanner的读取操作可能被阻塞.
为Scanner设置分隔符使用useDelimiter(String pattern)方法即可.
BufferedReader

该类用于从缓冲区中读取内容.所有的输入字节数据都将放在缓冲区中.常用的方法有:
```java
+ public BufferedReader(Reader in) //构造
+ public String readLine() //一次性从缓冲区中将内容全部读取进来
```
BufferedReader中定义的构造方法只能接收字符输入流的实例,所需必须使用输入流和字节输入流的转化率InputStreamReader将字节输入流System,int变为字符流.
```java
import java.io.*;
public class inputKEY{
public static void main(String[] args){
BufferedReader buf = null;
buf = new BufferedReader(new InputStreamReader(System.in));

String str = null;
System.out.print("content:");
try{
str = buf.readLine();
}catch(Exception e ){
e.printStackTrace();
}
System.out.print(str);
}
}
```

### 数据操作流

在IO包中,提供了俩个与平台无关的数据操作流,分别为数据输出流(DataOutputStream)和数据输入流(DataInputStream).通常数据输出流会按照一定的格式将数据输出,再通过
数据输入流按照一定的格式将数据读入,这样可以方便的对数据进行处理.


DataOutputStream是OutputStream的子类.此类的定义如下:
```java
public class  DataOutputStream  extends FilterOutputStream  implements DataOutput
此类继承自FilterOutputStream类(FilterOutputStream是OutputStream的子类).同时实现了DataOutput接口.在DataOutput接口定义了一系列的写入各种数据的方法:

DataOutput接口的作用
该接口数数据的输出接口.其中定义了各种数据的输出操作方法.但在是数据输出时一般都会直接使用DataOutputStream..只有在对象序列化时才有可能直接使用此接口.
```
DataOutputStream类的常用方法如下:
```java
public  DataOutputStream(OutputStream   out) //实例化对象
public  final void writeInt(int  v) //将一个int值以4-byte值形式写入基础输出流中
public  final void writeDouble(double v) //写入一个double类型.该值以8-byte值形式写入基础输出流中
public  final void writeChars(String  s) //将一个字符串写入到输出流中
public  final void writeChar(int v) //将一个字符写入到输出流中.
```
```java
import java.io.*;
public class inputKEY{
public static void main(String[] args){
BufferedReader buf = null;
buf = new BufferedReader(new InputStreamReader(System.in));

String str = null;
System.out.print("content:");
try{
str = buf.readLine();
}catch(Exception e ){
e.printStackTrace();
}
System.out.print(str);
}
}
```

DataInputStream

DataInputStream是InputStream的子类.专门负责读取使用DataOutputStream输出的数据.此类的定义如下:
```java
public class DataInputStream  extends FilterInputStream implements DataInput
此类继承自FilterInputStream类.FilterInputStream是InputStream的子类.同时实现DataInput接口.在DataInput接口中定义了一系列读入各种数据的方法.
```
该类地提供的常用方法有:
```java
public DataInputStream(InputStream  in) //构造
public final int readInt() //从输入流中读取整数
public final float readFloat() //从输入流中读取小数
public final char readChar() //从输入流中读取一个字符
```
```java
import java.io.*;
public class DataRead{
public static void main(String[] args)throws Exception{
DataInputStream dis = null;
File f = new File("d:"+File.separator+"test.txt");

dis = new DataInputStream(new FileInputStream(f));
String name = null;
float price = 0.0f;
int num = 0;
char temp[] = null;
char c=0;
int len = 0;
try{
while(true){
temp = new char[200];
len = 0;
while( (c = dis.readChar() ) != '\t'){
temp[len] = c;
len++;
}
name = new String(temp,0,len);
price = dis.readFloat();
dis.readChar();
num = dis.readInt();
dis.readChar();
System.out.printf("name:%s \tprice:%5.2f\tnums:%d\n",name,price,num);
}
}catch(Exception e){
e.printStackTrace();
}
dis.close();
}
}
```
### 合并流

合并流的主要功能是将俩个文件的内容合并成一个文件.
如果要实现合并流,则必须使用SequenceInputStream类.此类的常用方法如下:
```java
public SequenceInputStream(InputStream  s1,InputStream s2) //构造
public int available() //返回文件大小
```
```java
import java.io.*;

public class Sequence{
public static void main(String[] args)throws Exception{
InputStream s1 = null;
InputStream s2 = null;
OutputStream os = null;
SequenceInputStream sis = null;
s1 = new FileInputStream("d:"+File.separator+"a.txt");
s2 = new FileInputStream("d:"+File.separator+"b.txt");
os = new FileOutputStream("d:"+File.separator+"ab.txt");
sis = new SequenceInputStream(s1,s2);
int temp =0;
while((temp = sis.read())  != -1){
os.write(temp);
}
sis.close();
s1.close();
s2.close();
os.close();

}
}
```

### 压缩流

在Java中为了减少传输时的数据量也提供了专门的压缩流.可以就爱你个文件或文件夹压缩成zie.jar,gzip等文件形式.
ZIP压缩输入/输出流

zip是一种较为常见的压缩形式,在Java中需要实现ZIP的压缩需要导入java.util.zip包.可以使用此包中的ZipFile. ZipOutputStream. ZipInputStream和ZipeEntry几个类完成操作.
ZipEntry类

在每一个压缩文件中都会存在多个子文件,那么每一个子文件在java中使用ZipEntry标识.其常用的方法:
```java
public ZipEntry(String  name)  //构造 创建对象并指定要创建的ZipEntry名称
public boolean isDirectory() //判断此ZipEntry是否是目录
```
ZipOutputStream类

如果要完成一个文件或文件夹的压缩,则要使用ZipOutputStream类.ZipOutputStream是OutputStream的子类.常用的操作方法有:
```java
public  ZipOutputStream(OutputStream  out) //构造 创建新的Zip输出流
public  void putNextEntry(ZipEntry  e) //设置每一个ZipEntry对象
public  void setComment(String  comment) //设置ZIP文件的注释
```

```java

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.zip.*;

public class zipdemo{
public static void main(String[] args)throws Exception{
File file= new File("d:"+File.separator+"text.txt");

File zipFile= new File("d:"+File.separator+"text.zip");

InputStream input = new FileInputStream(file);
ZipOutputStream zipOut = null;

zipOut = new ZipOutputStream(new FileOutputStream(zipFile));
zipOut.putNextEntry(new ZipEntry(file.getName()));
zipOut.setComment("test zip util");
int temp = 0;
while((temp = input.read()) != -1){
zipOut.write(temp);
}
input.close();
zipOut.close();
}
}
```


ZipFile类

在java中.每一个压缩文件都可以使用ZipFile标识.还可使用ZipFile根据压缩后的文件名称找到每一个压缩文件的ZipEntry并将其进行解压缩操作.ZipFile类的常用方法
```java
public ZipFile(File  file)	构造	根据File类实例化ZipFile对象
public ZipEntry getEntry(String name)	根据名称找到其对应的ZipEntry
public InputStream  getInputStream(ZipEntry entry)	根据ZipEntry取得I南普陀Stream实例
public String getName()	得到压缩文件的路径名称
```


```java
import java.io.*;
import java.util.zip.*;
public class zipdemo1{
public static void main(String[] args)throws Exception{
File file = new File("d:"+File.separator+"text.zip");
ZipFile zipFile = new ZipFile(file);
System.out.println("zipfile-name:"+zipFile.getName());
}
}
```


解压文件:

```java
import java.io.*;
import java.util.zip.*;

public class zipdemo2{
public static void main(String[] args)throws Exception{
File file = new File("d:"+File.separator+"text.zip");
File newfile = new File("d:"+File.separator+"text_unzip.txt");

ZipFile zipFile = new ZipFile(file);
ZipEntry entry = zipFile.getEntry("text.txt");
InputStream input = zipFile.getInputStream(entry);
OutputStream out = new FileOutputStream(newfile);

int temp= 0;
while((temp = input.read()) != -1){
out.write(temp);
}
input.close();
out.close();
}
}
```


ZipInputStream类

ZipInputStream类.通过此类可以方便的读取ZIP格式的压缩文件.此类常用的方法如下:
```java
public ZipInputStream(InputStream in)	构造	实例对象
public ZipEntry  getNextEntry()	取得下一个ZipEntry
```



### 回退流

在Java IO中所有的数据都采用顺序的读取方式.即对一个输入流来说.都是采用从头到尾的顺序读取的.如果在输入流中某个不需要的内容被读取进来,则只能通过程序将
这些不需要的内容处理掉.为此java中提供了一种回退输入流(PushbackInputStream  PushbackReader) 可以把读取进来的某些数据重新回退的输入流的缓冲区中.
PushbackInputStream

该类的常用方法为:
```java
public  PushbackInputStream(InputStream in)	构造	将输入流放入到回退流中
public int read()	读取数据
public int read(byte[]  b,int off,int len)	读取指定范围的数据
public void unread(int b)	回退一个数据到缓冲去前面
public  void unread(byte[]  b)	回退一个数据列到缓冲区前面
public void unread(byte[] b,int off ,int len)	回退指定范围的一组数据到缓冲区前面
```

```java
package classfile;
import java.io.*;
public class pushback{
public static void main(String[] args)throws Exception{
String str = "www.baidu.com";
PushbackInputStream push = null;
ByteArrayInputStream bai = null;
bai = new ByteArrayInputStream(str.getBytes());
push = new PushbackInputStream(bai);


int temp = 0;
while((temp = push.read()) != -1){ //读取数据
if(temp == '.'){
push.unread(temp); //回退到缓冲区前面
temp = push.read(); //空出此数据

}else{
System.out.print((char)temp);
}
}
}
}
```


### 对象序列化

对象序列化就是把一个对象变为二进制的数据流的一种方法.通过对象序列化可以方便地实现对象的传递或存储.
如果一个类的对象项被序列化.则对象所在的类必须实现java.io.Serializable接口.此接口的定义如下:
+ public  interface  Serializable{}
可以发现在此接口中并没有定义任何的方法.所以此接口是一个标识接口.表示一个类具备了被序列化的能力.
如果要完成对象的输入或输出,还必须依靠对象输出流(ObjectOutputStream)对对象输入流(ObjectInputStream).
使用对象输出流输出序列化对象的步骤有时也称为序列化,而使用对象输入流读入对象的过程有时也称为反序列化.
对象输出流ObjectOutputStream

一个对如果要进行输出,则必须使用ObjectOutputStream类.此类的定义如下:
public class ObjectOutputStream
extends OutputStream
implements ObjectOutput,ObjectStreamConstants
ObjectOutputStream类属于OutputStream的子类.



对象序列化例子:
```java
import java.io.*;
class Person implements Serializable{
private String name;
private int age;

public Person(String name,int age){
this.name = name;
this.age = age;
}
public String toString(){
return "name:"+this.name+"age:"+this.age;
}
}

public class Seriliaztion{
public static void main(String[] args)throws Exception{
File f = new File("d:"+File.separator+"text.txt");
ObjectOutputStream oos = null;
OutputStream out = new FileOutputStream(f);
oos = new ObjectOutputStream(out);
oos.writeObject(new Person("test",30));
oos.close();
}
}
```

对象输入流ObjectInputStream

使用ObjectInputStream可以直接把被序列化好的对象反序列化.ObjectInputStream的定义如下:
public  class ObjectInputStream extends InputStream implements ObjectInput,ObjectStreamConstants
ObjectInputStream类也是InputStream的子类.与PrintStream类的使用类似.此类同样需要接收InputStream类的实例才可以实例化.


对象反序列化:
```java
import java.io.*;
public class unser{
public static void main(String[] args)throws Exception{
File f = new File("d:"+File.separator+"text.txt");
ObjectInputStream ois = null;
InputStream input = new FileInputStream(f);
ois = new ObjectInputStream(input);
Object obj = ois.readObject();
ois.close();
System.out.println(obj);
}
}
```
Externalizable接口

被Serializable接口声明的类的对象的内容都被序列化,如果现在用户希望自己指定的序列化的内容,则可以让一个类实现Externalizable接口.该接口定义如下:
public  interface Externalizable extends Serializable{
public void writeExternal(ObjectOutput out); //在方法中指定要保存的属性信息.对象序列化时调用
public void readExternal(ObjectInput in); //在此方法中读取被保存的信息.对象反序列化时调用
}
这个俩个方法的参数类型是ObjectOutput和ObjectInput.俩个接口的定义如下:
+  public interface ObjectOutput extends DataOutput
+  public interface ObjectInput extends DataInput
可以发现以上俩个接口分别继承DataOutput和DataInput这样在这俩个方法中就可以像DataOutputStream和DataInputStream那样直接输出和读取各种类型的数据.
如果一个类要使用Externalizable实现序列化时,在此类中必须存在一个无参构造方法.因为在反序列化时默认调用无参构造实例化对象.如果没有此无参构造.怎运行时将会出现异常.这一点的实现机制与Serializable接口是不同的.
```java
import java.io.*;
public class Person implements Externalizable{
private String name;
private int age;
public Person(){

}
public Person(String name,int age){
this.name = name;
this.age = age;
}
public String toString(){
return " name :"+this.name +"\t age:"+this.age;

}

public void readExternal(ObjectInput in)throws Exception{
this.name = (String).inreadObject();
this.age = in.readInt();
}
public void writeExternal(ObjectOutput out)throws Exception{
out.writeObject(this.name);
out.writeInt(this.age);
}
}
```

### 读写其他进程的数据

可以使用Runtime类的exec()方法可以运行平台上的其他程序.得到一个Process对象.Process对象代表了由java启动的子进程,Process类提供如下3个方法.用于让起与子进程进行通信.
InputStream getErrorStream() 获取标准错误输出流
InputStream getInputStream() 获取标准输流
OutputStream getOutputStream() 获取标准输出流
```java
import java.io.*;
public class RunProcess{
public static void main(String[] args)throws Exception{
Process p = Runtime.getRuntime().exec("javac");
try(
BufferedReader  br = new BufferedReader(
new InputStreamReader(p.getErrorStream())
)
){
String buff = null;
while((buff = br.readLine()) != null){
System.out.println(buff);
}
}
}
}
```
## Java新IO特性

新IO和传统的IO有相同的目的,都是用于进行输入/输出,但新IO使用了不同的方式来处理输入输出.新IO采用内存映射文件的方式来处理输入输出.新IO将文件或文件的一段区域映射到内存中,这样就可以像访问内存一样来访问文件.
java中与新IO相关的包如下:
+ java.nio 主要包各种与Buffer相关的类
+ java.nio.channels: 主要包含与Channel和Selecotr相关的类
+ java.nio.charset : 主要包含与字符集相关的类
+ java.nio.channels.spi: 主要包含与Channel相关的服务提供者编程接口
+ java.nio.charset.spi: 主要包含与字符集相关的服务提供者编程接口

channel(通道)和Buffer(缓冲)是新IO中的俩个核心对象.Channel是对传统的输入/输出系统的模拟.在新IO系统中所有的数据都需要通过通道传输;Channel与传统的InputStream和OutputStream最大的区别在于它提供了一个map()方法,通过该map()方法可以直接将"一块数据"映射到内存中.如果说传统IO是面向流的,那么新IO就是面向块的.
Buffer可以被理解为一个容器.它的本质是一个数组,发送到Channel中的所有对象都必须首先放入Buffer中,而从Channel中读取的数据也必须先放到Buffer中.
使用Buffer

从Buffer内部结构来开,它就像一个数组,它可以保存多个类型相同的数据.Buffer是一个抽象类.其最常用的子类是ByteBuffer.它可以在底层字节数组上进行get/set操作.
除了ByteBuffer之外,对应的还有其他基本数据类型(除boolean外).

除了ByteBuffer之外,其他子类都采用近似相同的方法来管理数据,这些子类都没有提供构造器.可以通过如下方式得到一个Buffer对象
+ static XXXBuffer  allocate(int capacity): 创建一个容量为capacity的XXXBuffer对象.
常用的Buffer子类有:
ByteBuffer 和 CharBuffer.
其中ByteBuffer类还有一个子类MappedByteBuffer.它用于表示Channel将磁盘文件的部分或全部映射到内存后得到结果.MappedByteBuffer对象有Channel的map方法返回.
Buffer中3个重要的概念:
容量(capacity): 缓冲区的容量.
界限(limit): 标识第一个不能读写的内存索引
位置(position): 标识下一个可以被读写的索引
Buffer的主要作用就是装入数据,然后输出数据,开始时候Buffer的Position为0,limit为capacity.程序可以通过put()方法像Buffer中放入一些数据(或从Channel中获取
一些数据).每放入一些数据,Buffer的Position相应的向后移动.当Buffer转入数据结束后,调用Buffer的flip()方法,该方法将limit设置为position所在的位置,并将position置0.这样Buffer就做好了数据输出的准备.当输出结束后,Buffer调用clear()方法,将position置0.将limit置为capacity.这样为再次向Buffer中转入数据.
常用方法:
flip()
clear()
int  capacity() //返回Buffer的capacity大小
boolean  hasRemaining() //判断当前位置position和limit之间是否还有数据可以处理
int   limit() //返回Buffer的limit位置
Buffer limit(int new) //重新设置limit的置.并返回一个具有新的limit的缓冲区对象
Buffer  mark() //设置Buffer的mark位置.
int  position() //返回Buffer中的position值
Buffer position(int  newPS) //重新设置position的位置
int  remaining() //返回当前位置和界限之前的元素个数
Buffer  reset() //将position转到mark所在的位置
Buffer  rewind() //将位置position设置为0.取消mark

Buffer的所有子类都还提供了俩个重要的方法:get() put().用于将数据放入Buffer中.和取出输出.
Buffer支持单个数据的访问,也支持批量数据的访问. 使用put()和get()访问数据时.分为相对和绝对俩中:
相对(Relative):从Buffer的当前position处开始读取或写入数据.然后将位置position的值按照元素个数增加
绝对(Absolute):直接根据索引向Buffer中读写数据.使用绝对方式访问Buffer里的数据不会影响position的值.
```java

import java.nio.*;

public class BufferDemo{
public static void main(String[] args){
CharBuffer buff = CharBuffer.allocate(8);
System.out.println("capacity:"+buff.capacity());
System.out.println("limit:"+buff.limit());
System.out.println("position:"+buff.position());

//put data
buff.put('a');
buff.put('b');
buff.put('c');
System.out.println("put-position:"+buff.position());

buff.flip();
System.out.println("flip-capacity:"+buff.capacity());
System.out.println("flip-limit:"+buff.limit());
System.out.println("flip-position:"+buff.position());

//get data
System.out.println(buff.get());
System.out.println("get-position:"+buff.position());
System.out.println(buff.get());
System.out.println("get-position:"+buff.position());
System.out.println(buff.get());
System.out.println("clear-capacity:"+buff.capacity());
System.out.println("clear-limit:"+buff.limit());
System.out.println("clear-position:"+buff.position());
//get data by Absolute-index
System.out.println(buff.get(2)) ;
System.out.println("get-date-by Absolute-index-capacity:"+buff.capacity());
System.out.println("get-date-by Absolute-index-limit:"+buff.limit());
System.out.println("get-date-by Absolute-index-position:"+buff.position());
}
}
```java

通过allocate方法创建的Buffer只是普通的Buffer.在XXXBuffer中还提供了.allocateDirect()方法,该方法可创建效率更高的Buffer.但其创建成本较高.所以只适用于长期适用的Buffer.
适用Channel

### Channel与传统的IO有俩区别.
+ Channel可以直接将指定的文件的部分或全部直接映射到Buffer
+ 程序不能直接访问Channel中的数据.包括读写.必须适用Buffer做空间人.
java中为Channel接口提供了DatagramChannel.FileChannel. Pipe.SourceChannel.SelettableChannel.ServerScoketChannel.SocketChannel等诸多实现类.
所有的Channel都应该通过构造器来直接创建,而是通过传统的节点InputStream,OutputStream的getChannel方法来返回相对应的Channel.
Channel中最常用的3个方法为:map()  read() write().其中map方法用于将channel对应的部分或全部数据映射到内存中ByteBuffer.而read和write有一系列的重载形式,用于从Buffer中读写数据.
map方法的定义为:
map(FileChannel.MapMode mode, long position, long size) 将此通道的文件区域直接映射到内存中。
字符集和Charset

在计算机中所有的东西都是二进制的.之所以看到文字字符的是因为系统将底层的二进制序列转换成字符的缘故.在这个过程中涉及俩个概念.
+ 编码(Encode):通常把字符转换成二进制的过程称为编码
+ 解码(Decode):通常把二进制转换成字符的过程称为解码
java默认适用的是Unicode字符集.但很多操作系统并不适用Unicode字符集.故从系统中读取数据到java程序中很可能就会出现乱码问题.
为此java提供了Charset类来处理字节序列和字符序列之间的转换,该类提供了创建编码器和解码器的方法.还提供了一个availableCharset()静态方法
可以获取到java所支持的所有的字符集.
Demo:获取JDK支持的字符集
```java

import java.nio.charset.Charset;
import java.util.*;

public class getEncoding{
public static void main(String[] args){
SortedMap<String,Charset> map = Charset.availableCharsets();
for(String alias:map.keySet()){
System.out.println(alias);
}
}
}
```

可以适用System类的getProperties()方法获取本地系统的文件编码格式,文件编码格式的属性名为:file.encoding.
一旦知道了字符集的别名之后,程序就可以调用Charset()的forName方法来创建对应的Charset对象.forName方法的参数就是相应的字符集别名.
创建了Charset对象后,就可以通过该对象的newDecoder()  newEncoder()方法这俩个方法分别返回CharsetDecoder和CharsetEncoder对象,代表该
对象的解码器和编码器.
调用CharsetDecoder的decode()方法就可以将ByteBuffer(字节序列)转换成CharBuffer(字符序列).调用CharsetEncoder的encode()方法就可以将CharBuffer或String
转换成ByteBuffer.
在java 7中新增了一个StandardCharsets类.该类包含了ISO_8859-1.UTF-8 UTF-16等静态字段.盖子代表了最常用的字符集对应的charset对象.
```java
import java.nio.*;
import java.nio.charset.*;
public class charsetDemo{
public static void main(String[] args)throws Exception{
Charset set = Charset.forName("GBK");
CharsetEncoder encoder = set.newEncoder();
CharsetDecoder decoder = set.newDecoder();
CharBuffer buff = CharBuffer.allocate(8);
buff.put('t');
buff.put('e');
buff.put('s');
buff.put('t');
buff.flip();
//将字符序列转换成字节序列
ByteBuffer bbuff = encoder.encode(buff);
for(int i = 0;i < bbuff.limit();i++){
System.out.print(bbuff.get(i)+" ");
}
System.out.println("\n"+decoder.decode(bbuff));
}
}
```

实际上Charset类提供如下3个简便的方法:
+ CharBuffer  decode(ByteBuffer  bb);    将ByteBuffer中的字节序列转换成字符序列的简便方法
+ ByteBuffer  encode(CharBuffer  cb);  将CharBuffer中的字符序列转换成字节序列的简便方法
+ ByteBuffer  encode(String  str);  将字符串转换成字节序列的简便方法.
也就是说,获得Charset对象后,如果仅仅需要进行简单的编码,解码操作,其实无需创建编码器和解码器.
Java 7 IO

Java 7 对原有的NIO进行重大的改进.使其功能更强大,适用更方便.Path Paths Files中引入了一个Path接口.Path接口代表一个平台无关的平台路径.除此还提供了Files  Paths俩个工具类.
Files包含了大量静态工具方法来操作文件.Paths报了俩个返回Path的静态工厂方法.