title: Java ClassLoader
date: 2016-01-03 20:01:17
tags: Java
categories: Java
---
大家都知道，当我们写好一个Java程序之后，不是管是CS还是BS应用，都是由若干个.
class文件组织而成的一个完整的Java应用程序，当程序在运行时，即会调用该程序的一个入口函数来调用系统的相关功能
，而这些功能都被封装在不同的class文件当中，所以经常要从这个class文件中要调用另外一个class文件中的方法，
如果另外一个文件不存在的，则会引发系统异常。而程序在启动的时候，并不会一次性加载程序所要用的所有class文件，
而是根据程序的需要，通过Java的类加载机制（ClassLoader）来动态加载某个class文件到内存当中的，
从而只有class文件被载入到了内存之后，才能被其它class所引用。所以ClassLoader就是用来动态加载class文件到内存当中用的。

类加载器负责读取Java字节码，并转换成java.lang.Class类的一个实例，每个这样的实例用来表示一个Java类。
通过此实例的newInstance()方法就可以创建出该类的一个对象，实际的情况可能会更加复杂，
Java字节码是通过工具动态生成，也可能是来自网络。

# ClassLoader class
基本上所有的类加载器都是java.lang.ClassLoader类的一个实例（除bootstrap classloader）。

Classloader类的基本职责就是根据一个指定的类的名称，找到或者生成其对应的字节码，
然后从这些字节码中定义出一个Java类，即Java.lang.Class类的实例，
除此之外ClassLoader还负责加载Java应用所需的资源，如图像和配置文件。

为了完成类加载的功能，Class提供一系列的方法(如下)，每个Class对象都包含一个对应的ClassLoader的引用：
```java
    //返回该类加载器的父类加载器
    ·getParent

    //加载名称为name的类，返回的结果是java.lang.Class的实例
    ·loadClass(Stringname)

    查找名称为name的类，返回的结果是java.lang.Class类的实例
    ·findClass(Stringname)

    查找名称为name的已经被加载过的类，返回的结果是java.lang.Class类的实例
    ·findLoadedClass(Stringname)

    把字节数组b中的内容转换成java类，返回的结果是java.lang.Class类的实例，这个方法被声明为final的
    ·defineClass(Stringname,byte[].int off,int len)

    连接指定的Java类
    ·resolveClass(Class<?>c)
```

# The type of ClassLoader
    Java中一个工有四种类加载器BootstrapClassLoader、Extension ClassLoader、AppClassLoader、URLClassLoader。
    其中AppClassLoader在很多地方称为SystemClassLoader。

## BootStrap ClassLoader
    是在JVM开始运行的时候加载Java的核心类。是用C++编写的。它用来加载核心类库，在JVM中以如下方式实现：
```java
static const char classpathFormat[] =

     "%/lib/rt.jar:"

     "%/lib/i18n.jar:"

     "%/lib/sunrsasign.jar:"

     "%/lib/jsse.jar:"

     "%/lib/jce.jar:"

     "%/lib/charsets.jar:"

     "%/classes";
```
可以如下的Java代码测试：
```java
package JavaSec.classLoader;
import java.net.URL;

/**

 * BootStrap ClassLoader：称为启动类加载器，是Java类加载层次中最顶层的类加载器，

 * 负责加载JDK中的核心类库，如：rt.jar、resources.jar、charsets.jar等

 *

 */

public class BootStrapClassLoader {

    public static void main(String[] args) {

        /*

         * 罗列当前程序所加载的JDK

         */

        URL[] urls = sun.misc.Launcher.getBootstrapClassPath().getURLs();

        for (int i = 0; i < urls.length; i++) {

            System.out.println(urls[i].toExternalForm());

        }



        //也可以通过sun.boot.class.path环境变了获取

        System.out.println(System.getProperty("sun.boot.class.path"));

    }

}
```
## Extension ClassLoader
ExtendedClassLoader对应的是sun.misc.Launcher$ExtClassLoader.它是扩展类加载器，它是用Java编写的。它负责加载JRE的扩展目录，
（JAVA_HOME/jre/ext或者java.ext.dirs系统属性指定的）中的JAR包。这是为引入除Java核心类以外的新功能提供了一个标准机制。
因为默认的扩展目录对所有从同一个JRE中启动的JVM都是通用的。所以放入这个目录中的JAR类包对所有的JVM和AppClassLoader都是可见的。
```java
public class ExtensionClassLoader {

    public static void main(String[] args){

        System.out.println(System.getProperty("java.ext.dirs"));

        ClassLoader extClassLoader = ClassLoader.getSystemClassLoader().getParent();

        System.out.println(extClassLoader.getClass());

    }

}
```
### AppClassLoader
该类加载器，也称为系统加载器，它负责在JVM被启动时。加载来自命令Java中的-classpath
或这Java.class.ptah系统属性或者CLASSPATH系统环境变量中的类包。

总能通过静态方法ClassLoader.getSystemClassLoader()找到该类加载器。
```java
   public static void main(String[] args){

        System.out.println(System.getProperty("java.class.path"));

         ClassLoader appClassLoader = ClassLoader.getSystemClassLoader();

        System.out.println(appClassLoader.getClass());

    }
```
## URLClassLoader

URLClassLoader提供了动态加载类或JAR。它可以通过以下集中方式进行加载:

·文件（从文家系统目录加载）

·jar包(从jar包进行加载)

·网络(从远程http服务器进行加载)
```java
           public static void main(String[] args) throws Exception {


            URL urls[] = new URL[1];

            urls[0] = new URL("file:e:/program/java/Api.jar");

            URLClassLoader loader = new URLClassLoader(urls);

            //如果用于WEB应用，则需要使用以下构造方法

            //URLClassLoader loader = new URLClassLoader(urls, Thread.currentThread().getContextClassLoader());

            Class<?> api = loader.loadClass("com.wogu.Api");

            Constructor<?> constructors[] = api.getDeclaredConstructors();

            Object obj = constructors[0].newInstance();

            Method method = api.getMethod("test");

            method.invoke(obj);

        }
```
除了引导类加载器之外，所有的类加载器都有一个父类加载器。通过 getParent() 方法可以得到。对于系统提供的类加载器来说，
系统类加载器的父 类加载器是扩展类加载器，而扩展类加载器的父类加载器是引导类加载器；对于开发人员编写的类加载器来说，
其父类加载器是加载此类加载器 Java 类的类加载器。因为类加载器 Java 类如同其它的 Java 类一样，也是要由类加载器来加载的。
一般来说，开发人员编写的类加载器的父类加载器是系统类加载器。类加载器通过这种方式组织起来，形成树状结构。树的根节点就是引导类加载器。
下图中给出了一个典型的类加载器树状组织结构示意图，其中的箭头指向的是父类加载器。


# class loading mechanisms
classloader加载类用的是全盘责任委托机制，也被称为双亲委托模型。所谓的全盘负责，即当一个Classloader加载一个Class的时候，
这个class及其所依赖的类也有这个classloader负责加载，除非显示的指定另一个类加载器，所谓的委托加载，
则是在该classloader加载该类之前先会把这个任务委托给自己的父类加载。这个过程是由上之下依次检查，
首先由最顶层的类加载器BootStrap ClassLoader视图加载，如果没有加载到则把任务转交给Extension ClassLoader加载，
如果它也没有加载到，则转交给System ClassLoader进行加载，如果它也没有加载到得到的话，则返回给发起者，
由它到指定的文件系统或网络等URL中加载该类。如果它也没有加载到则抛出异常ClassNotFoundException。
否则将这个找到的类生成一个类定义，并将它加载到内存当中。最后返回这个类在内存中class实例对象。
同时类加载还采用cache机制，也就是如果cache中保存了这个Class就直接返回它，如果没有才从文件读取和转换成Class，
并存入cache。这就是为什么修个class必须重启JVM才能生效的原因



至所以这样设置类的加载机制是了避免重复加载，同时也是了安全因素考虑。当父类已经加载了该类，
那么子ClassLoader没必要再加载依次。同时这样也可以避免替换Java的核心类，比如String。



# JVM是如何判断俩个Class是相同的？

JVM在判断俩个Class是否相同时，不仅要判断俩个类名是否相同，而其要判断是否由同一个类加载器实例加载的。
只有俩者同时满足的情况下，JVM才任务这俩个class是相同的。

# Process of  Loadingclass

    1.检测此Class是否载入过（即在cache中是否有此Class），如果有到8,如果没有到2
    2.如果parentclassloader不存在（没有parent，那parent一定是bootstrap classloader了），到4
    3.请求parentclassloader载入，如果成功到8，不成功到5
    4.请求jvm从bootstrap classloader中载入，如果成功到8
    5.寻找Class文件（从与此classloader相关的类路径中寻找）。如果找不到则到7.
    6.从文件中载入Class，到8.
    7.抛出ClassNotFoundException.
    8.返回Class.
```java
protected Class<?> loadClass(String name, boolean resolve)   throws ClassNotFoundException {

        synchronized (getClassLoadingLock(name)) {

        // First, check if the class has already been loaded

        Class c = findLoadedClass(name);

        ////如果没有被加载，就委托给父类加载或者委派给启动类加载器加载

        if (c == null) {

            long t0 = System.nanoTime();

            try {

                ////如果存在父类加载器，就委派给父类加载器加载

                if (parent != null) {

                   c = parent.loadClass(name, false);

                } else {

                    ////如果不存在父类加载器，就检查是否是由启动类加载器加载的类，

                    //通过调用本地方法native Class findBootstrapClass(String name)

                    c = findBootstrapClassOrNull(name);

                }

            } catch (ClassNotFoundException e) {

                // ClassNotFoundException thrown if class not found

                // from the non-null parent class loader

                }

               if (c == null) {

                    // If still not found, then invoke findClass in order to find the class.

                    // 如果父类加载器和启动类加载器都不能完成加载任务，才调用自身的加载功能

                    long t1 = System.nanoTime();

                    c = findClass(name);

                    // this is the defining class loader; record the stats

                sun.misc.PerfCounter.getParentDelegationTime().addTime(t1 - t0);

                sun.misc.PerfCounter.getFindClassTime().addElapsedTimeFrom(t1);

                sun.misc.PerfCounter.getFindClasses().increment();

            }

        }

        if (resolve) {

            resolveClass(c);

        }

        return c;

    }

}
```

其中5，6步可以通过重写ClassLoader的findClass方法来实现自己的载入策略。甚至可以覆盖loadClass方法来实现自己的载入过程。

真正完成类的加载工作的是defineClass来实现的，而启动类的加载过程是通过调用loadClass来实现的。
前者被称为defining load类的定义加载器，后者称为initiating load类的初始化加载器。
在JVM中判断俩个类是否相同的时候，使用的类的定义加载器。

俩个类加载器的关联：

         一个类的定义加载器是它引用的其它类的初始化加载器。

         如类example.outer引用了example.inner则类example.outer的定义加载器负责启动类example.Inner的加载过程

方法 loadClass() 抛出的是 java.lang.ClassNotFoundException 异常；

方法defineClass() 抛出的是 java.lang.NoClassDefFoundError 异常。

类加载器在成功加载某个类之后，会把得到的 java.lang.Class 类的实例缓存起来。
下次再请求加载该类的时候，类加载器会直接使用缓存的类的实例，而不会尝试再次加载。
也就是说，对于一个类加载器实例来说，相同全名的类只加载一次，即loadClass 方法不会被重复调用。



# 类加载的顺序是：

         先是bootstrapclassloader然后是extsion classloader最后才是system classloader，
         加载的class越是重要的越在靠前面。这样做的原因是处于安全性的考虑。
         试想如果system classloader亲自加载一个java.lang.System类会怎样的结果？
         所以这种委托机制在理论是可靠的，这样这个类总会是有bootstrap classloader来加载的。

下面的测试代码都能说这个问题。这些都表明Java的基础类型和核心类库都是bootStrap classloader加载，
因此bootstrap classloader不是一个真正的ClassLoader类的实例，而是JVM层面的实现，所以输出为null;
```java
public class ClassLoaderTest {

    public static void main(String[] args) throws Exception{



        //每个class都包含一个对应的Classloader的引用

        //当然Java基础类型的getClassLoader返回为null

        String strs = "string";

        System.out.println(strs.getClass().getClassLoader());



        System.out.println(System.class.getClassLoader());



        System.out.println(Integer.class.getClassLoader());



        System.out.println(Date.class.getClassLoader());



    }

}
```
# Structureof ClassLoader
sun.misc.Launcher当之下Java命令的时候，JVM会先使用bootstrapclassLoader载入并初始化一个Launcher，可以用下面的代码进行验证
```java
System.out.println("Launcher's classLoader -> "

                +sun.misc.Launcher.getLauncher().getClass().getClassLoader());
```
Launcher会根据系统和命令设定初始化好classloader结构，JVM就用它来获取得到extension classLoader和
system classLoader并载入所有需要的载入的class。最后之下java命令指定的带有静态的main方法的class。

Extension classloader实际上是sun.misc.Launcher$ExtClassLoader类的一个实例，
SystemClassLoader实际上是sun.misc.Launcher$AppClassLoader类的一个实例。并且它们都是java.net.URLClassLoader的子类。

下面是Launcher的部分实现
```java
public Launcher()

{

  ExtClassLoader localExtClassLoader;

  try

  {

    //初始化ExtClassLoader

    localExtClassLoader = ExtClassLoader.getExtClassLoader();

  }

  catch (IOException localIOException1)

  {

    throw new InternalError("Could not create extension class loader");

  }

  try

  {

    //初始化System ClassLoader

    this.loader = AppClassLoader.getAppClassLoader(localExtClassLoader);

  }

  catch (IOException localIOException2)

  {

    throw new InternalError("Could not create application class loader");

  }

  //设置ContextClassLoader

  Thread.currentThread().setContextClassLoader(this.loader);

  String str = System.getProperty("java.security.manager");

  //code for security.manager

  //….

 }
```
ExtClassLoader的实现
```java
static class ExtClassLoader extends URLClassLoader {

    public static ExtClassLoader getExtClassLoader() throws IOException

    {

      File[] arrayOfFile = getExtDirs();

      try

      {

        (ExtClassLoader)AccessController.doPrivileged(newPrivilegedExceptionAction()

        {

          public Launcher.ExtClassLoader run()

            throws IOException

          {

            int i = this.val$dirs.length;

            for (int j = 0; j < i; j++) {

              MetaIndex.registerDirectory(this.val$dirs[j]);

            }

            return new Launcher.ExtClassLoader(this.val$dirs);

          }

        });

      }

      catch (PrivilegedActionException localPrivilegedActionException)

      {

        throw ((IOException)localPrivilegedActionException.getException());

      }

    }



    void addExtURL(URL paramURL) {

        super.addURL(paramURL);

    }



    public ExtClassLoader(File[] paramArrayOfFile) throws IOException {

        super(null, Launcher.factory);

    }



    private static File[] getExtDirs() {

        String str = System.getProperty("java.ext.dirs");

        File[] arrayOfFile;

        if (str != null) {

            StringTokenizer localStringTokenizer = new StringTokenizer(str, File.pathSeparator);

            int i = localStringTokenizer.countTokens();

            arrayOfFile = new File[i];

            for (int j = 0; j < i; j++) {

                arrayOfFile[j] = new File(localStringTokenizer.nextToken());

            }

        } else {

            arrayOfFile = new File[0];

        }

        return arrayOfFile;

    }
```
System ClassLoader的部分实现
```java
static class AppClassLoader extends URLClassLoader {

    public static ClassLoader getAppClassLoader(final ClassLoader paramClassLoader)

  throws IOException

{

  String str = System.getProperty("java.class.path");

  final File[] arrayOfFile = str == null ? new File[0] : Launcher.getClassPath(str);

  (ClassLoader)AccessController.doPrivileged(new PrivilegedAction()

  {

    public Launcher.AppClassLoader run()

    {

      URL[] arrayOfURL = this.val$s == null ? new URL[0] : Launcher.pathToURLs(arrayOfFile);

      return new Launcher.AppClassLoader(arrayOfURL, paramClassLoader);

    }

  });

}
```

Context ClassLoader从源码上可以看到extension 和 system classloader都是静态内部类，
同时都继承了URLClassLoader。Extension ClassLoader是使用系统属性java.ext.dirs设置搜索路径，
并且没有parent.System Classloader是使用Java.class.path设置类搜索路径，并且有一个parentclassloader.

从上述可以看到一个context classloader。当建立一个线程Thread的时候，
可以为这个线程通过setContextClassLoader方法来指定一个合适的classLoader作为这个线程的
context classloader，当线程运行的时候，可以通过getContextClassLoader方法来获得此context classLoader，
就可以用它来载入所需要的class.默认的是System classLoader。

利用这个特性就可以打破常规的类加载过程，及委托机制，父类的classloader可以获得当前线程的context classloader，
而这个context classloader可以它的子classloader也可以是其他的classloader。那么父classloader就可以从其获得所需要的class。
这就打破了只能向父classloader请求的限制。而这种类加载机制在JDBC的实现和web容器的实现中是很常见的。

在类Thread定义一个属性classLoader，用来供用户保存一个classLoader（默认是App），并公开setter和getter方法，
使得此线程的任何语句都可以得到此classLoader，然后用它来加载类，以此来打破默认的类加载规则。

Dynamic extend ClassLoader
Java允许用户在运行时扩展引用程序，即可以通过当前虚拟机中预定义的加载器加载编译时已知的类或者接口，
同时也允许用户自行定义类加载器。在运行时动态扩展用户的程序。通过用户自定义的类装载器，程序可以装载在编译时
并不知道或者尚不存在的类或接口，并动态连接它们并进行有选择的解析。

运行时动态扩展Java应用程序有调用Class.forName方法和自定义类加载器俩种方法。
```java
Class.forName
Java.lang.Class定义了如下的方法

public static Class<?> forName(String paramString)

public static Class<?> forName(String paramString, booleanparamBoolean, ClassLoader paramClassLoader)
```
class.forName是一个静态方法。同样可以用来加载类，该方法有俩种形式.第一种形式的参数name表示的类的全名。
第二种有三个参数name表示类的全名,initialize表示是否初始化类，loader表示加载时使用的类加载器。
其实第一种形式就是第二种形式initialize设置为true，loader表示当前类的类加载器

class.forName一个很常见的用法就是JDBC时，例如下面的代码
```java
 //加载驱动

        try {

            Class.forName(Drivers);

        } catch (ClassNotFoundException e) {

            System.out.println("加载驱动异常："+Drivers);

            e.printStackTrace();

        }
```
# Custom ClassLoader
一般用户自定义类加载器的工作流程如下：

         1·首先检查请求的类型是否已经被这个类加载加载到命令空间中了，如果已经加载了直接返回，否则进入第二步

         2·委派类加载器的父类加载器，如果父类加载器能够完成，则返回父类加载器加载的class实例，否则进入第三步

         3·调用本类加载的findClass方法，视图获取对应的字节码，如果获取到调用defineClass导入类到内存中，如果获取字节码失败怎返回异常
```java
public class FileSystemClassLoader extends ClassLoader {



    //类路径

    private String rootDir;



    public FileSystemClassLoader(String rootDir){

        this.rootDir = rootDir;

    }



    @Override

    protected Class<?> findClass(String name) throws ClassNotFoundException {

        byte[] classData = getClassData(name);

        if(classData == null){

            throw new ClassNotFoundException();

        }else{

            return defineClass(name,classData,0,classData.length);

        }

    }



    public byte[] getClassData(String className){

        String path = classNameToPath(className);

        try{

            InputStream ins = new FileInputStream(path);

            ByteArrayOutputStream baos = new ByteArrayOutputStream();

            int bufferSize = 4096;

            byte[] buffer = new byte[bufferSize];

            int byteNumRead = 0;

            while((byteNumRead = ins.read(buffer))!= -1){

                baos.write(buffer,0,byteNumRead);

            }

            return baos.toByteArray();

        }catch(IOException e){

            e.printStackTrace();

        }

        return null;

    }



    public String classNameToPath(String className){

        return rootDir + File.separatorChar + className.replace(".", File.separatorChar+".class");

    }

}
```
类FileSystemClassLoader继承自类java.lang.ClassLoader一般来说，
自己开发的类加载器只需要重写findClass方法即可，java.lang.ClassLoader类的loaderClass封装了双亲委托机制。

```java
URLClassLoader
 public class URLClassLoaderTest {




    @Test

    public void test_LocalFileSystem() {

        //将将测试的*.class文件放到c:/temp/*.class

        File libDir = new File("c:/temp");



        try{

            System.out.println(libDir.toURL());

            URLClassLoader loader = new URLClassLoader(new URL[]{libDir.toURL()});

            Class cls = loader.loadClass("JavaSec.classLoader.TargetClass");

            Object obj = cls.newInstance();

            //调用TargetClass类的method方法

            Method xMethod = cls.getDeclaredMethod("method");

            xMethod.invoke(obj);

        }catch(Exception e){

            e.printStackTrace();

        }

    }



    @Test

    public void test_HTTP() {

        try{

            //通过http服务器动态加载远程类

            URL[] url = new URL[]{new URL("http://localhost")};

            URLClassLoader loader = new URLClassLoader(url);

            Class cls = loader.loadClass("JavaSec.classLoader.TargetClass");

            Object obj = cls.newInstance();

            //调用TargetClass类的method方法

            Method xMethod = cls.getDeclaredMethod("method");

            xMethod.invoke(obj);

        }catch(Exception e){

            e.printStackTrace();

        }



    }

}
```
# ClassLoader in Tomcat
可以用以下的代码测试Tomcat的类加载器的结构
```java
public class TomcatClassLoaderTest extends HttpServlet {

    private static final long serialVersionUID = 1L;



    @Override

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {



        resp.setContentType("text/html");

        PrintWriter out = resp.getWriter();



        ClassLoader loader = this.getClass().getClassLoader();

        while(loader != null){

            out.println(loader.getClass().getName() +"<br/>");

            loader = loader.getParent();

        }



        out.println(String.valueOf(loader));



    }



    @Override

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        this.doGet(req, resp);

    }



}
```
配置Servlet
```xml
    <!-- 打印Tomcat的classLoader结构 -->

    <servlet>

        <servlet-name>ClassLoader</servlet-name>

        <servlet-class>JavaSec.classLoader.TomcatClassLoaderTest</servlet-class>

    </servlet>

    <servlet-mapping>

        <servlet-name>ClassLoader</servlet-name>

        <url-pattern>/PrintclassLoader</url-pattern>

    </servlet-mapping>
```
 会看到如下输出
```bash
org.apache.catalina.loader.WebappClassLoader
org.apache.catalina.loader.StandardClassLoader
sun.misc.Launcher$AppClassLoader
sun.misc.Launcher$ExtClassLoader
null
```java


# Implicit loading and Indicate loading
Java 运行环境为了优化系统，提高程序的执行速度，在 JRE 运行的开始会将 Java 运行所需要的基本类采用预先加载
（ pre-loading ）的方法全部加载要内存当中，因为这些单元在 Java 程序运行的过程当中经常要使用的，
主要包括 JRE 的 rt.jar 文件里面所有的 .class 文件。

当 java.exe 虚拟机开始运行以后，它会找到安装在机器上的 JRE 环境，然后把控制权交给 JRE ，
 JRE 的类加载器会 将 lib 目录下的 rt.jar 基础类别文件库加载进内存，这些文件是 Java 程序执行所必须的
 ，所以系统在开始就将这些文件加载，避免以后的多次 IO 操作，从而提高程序执行效率。

相对于预先加载，我们在程序中需要使用自己定义的类的时候就要使用依需求加载方法（ load-on-demand ），
就是在 Java 程序需要用到的时候再加载，以减少内存的消耗，因为 Java 语言的设计初衷就是面向嵌入式领域的。

在这里还有一点需要说明的是， JRE 的依需求加载究竟是在什么时候把类加载进入内部的呢？

我们在定义一个类实例的时候，比如 TestClassAtestClassA ，这个时候 testClassA 的值为 null ，
也就是说还没有初始化，没有调用 TestClassA 的构造函数，只有当执行 testClassA= new TestClassA() 以后，
JRE 才正真把 TestClassA 加载进来。

# Implicit loading and Indicate loading
Java 的加载方式分为隐式加载（ implicit ）和显示加载（ explicit ）。
所谓隐式加载就是我们在程序中用 new 关键字来定义一个实例变量， JRE 在执行到 new 关键字的时候就会把对应的实例类加载进入内存
。隐式加载的方法很常见，用的也很多， JRE 系统在后 台自动的帮助用户加载，减少了用户的工作量，也增加了系统的安全性和程序的可读性。

相对于隐式加载的就是我们不经常用到的显示加载。所谓显示加载就是有程序员自己写程序把需要的类加载到内存当中，下面我们看一段程序：
```java
 class TestClass{




    public void method(){

        System.out.println(this.getClass()+"::method");

    }



}

public class DisplayClassLoader {

    public static void main(String[] args){

        //显示加载类 可以用class.forName()或自己实现的ClassLoader

        try {

            Class<?> c = Class.forName("JavaSec.classLoader.TestClass");

            try {

                TestClass obj = (TestClass) c.newInstance();

                obj.method();

            } catch (Exception e) {

                e.printStackTrace();

            }



        } catch (ClassNotFoundException e) {

            e.printStackTrace();

        }

    }

}
```
# Classloader and OSGI
OSGi™是 Java 上的动态模块系统。它为开发人员提供了面向服务和基于组件的运行环境，并提供标准的方式用来管理软件的生命周期。
OSGi 已经被实现和部署在很多产品上，在开源社区也得到了广泛的支持。Eclipse 就是基于 OSGi 技术来构建的。

OSGi中的每个模块（bundle）都包含 Java 包和类。模块可以声明它所依赖的需要导入（import）的其它模块的
Java 包和类（通过 Import-Package），也可以声明导出（export）自己的包和类，供其它模块使用（通过 Export-Package）。
也就是说需要能够隐藏和共享一个模块中的某些 Java 包和类。这是通过 OSGi 特有的类加载器机制来实现的。
OSGi 中的每个模块都有对应的一个类加载器。它负责加载模块自己包含的 Java 包和类。当它需要加载
Java 核心库的类时（以 java 开头的包和类），它会代理给父类加载器（通常是启动类加载器）来完成。
当它需要加载所导入的 Java 类时，它会代理给导出此 Java 类的模块来完成加载。模块也可以显式的声明某些 Java 包和类，
必须由父类加载器来加载。只需要设置系统属性org.osgi.framework.bootdelegation的值即可。

假设有两个模块bundleA 和bundleB，它们都有自己对应的类加载器 classLoaderA 和 classLoaderB。
在 bundleA 中包含类 com.bundleA.Sample，并且该类被声明为导出的，也就是说可以被其它模块所使用的。
bundleB 声明了导入 bundleA 提供的类com.bundleA.Sample，并包含一个类com.bundleB.NewSample继承自
com.bundleA.Sample。在bundleB 启动的时候，其类加载器 classLoaderB 需要加载类 com.bundleB.NewSample，
进而需要加载类com.bundleA.Sample。由于bundleB 声明了类com.bundleA.Sample 是导入的，classLoaderB
把加载类 com.bundleA.Sample 的工作代理给导出该类的 bundleA 的类加载器 classLoaderA。classLoaderA
在其模块内部查找类com.bundleA.Sample 并定义它，所得到的类 com.bundleA.Sample 实例就可以被所有声明导入了此类的模块使用。
对于以java 开头的类，都是由父类加载器来加载的。如果声明了系统属性org.osgi.framework.bootdelegation=com.example.core.*，
那么对于包 com.example.core中的类，都是由父类加载器来完成的。

OSGi模块的这种类加载器结构，使得一个类的不同版本可以共存在Java 虚拟机中，带来了很大的灵活性。不过它的这种不同，
也会给开发人员带来一些麻烦，尤其当模块需要使用第三方提供的库的时候。

如果一个类库被多个模块共用，可以为这个类库单独的创建一个模块，
把其它模块需要用到的 Java 包声明为导出的。其它模块声明导入这些类。

如果类库提供了 SPI 接口，并且利用线程上下文类加载器来加载 SPI实现的 Java 类，有可能会找不到 Java 类。
如果出现了NoClassDefFoundError 异常，首先检查当前线程的上下文类加载器是否正确。
通过Thread.currentThread().getContextClassLoader() 就可以得到该类加载器。
该类加载器应该是该模块对应的类加载器。如果不是的话，可以首先通过
class.getClassLoader()来得到模块对应的类加载器，
再通过Thread.currentThread().setContextClassLoader() 来设置当前线程的上下文类加载器。