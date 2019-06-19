---
title: Java-sec-serializable
date: 2016-12-11 20:40:21
tags: Java
---

对象序列化就是把一个对象变为二进制的数据流的一种方法，通过对象序列化可以方便地实现对象的传递或存储，因此其应用前景还是相当多的。在Java中如果一个类要被序列化，必须实现java.io.Serializable,并且如果要完成对象的输如或输出，还必须依靠对象输出流（ObjectOutputStream）和对象输入流（ObjectInputStream）。使用对象输出流输出序列化对象的过程也称为序列化，而使用对象输入流读入对象的过程被称为对象反序列化。

#### Java标准的序列化和反序列化

定义一个对象,并实现序列化接口java.io.Serializable。

```java
package JavaIO.Serilizable;

import java.io.Serializable;

public class Person implements Serializable {

    private static final long serialVersionUID = 1L;

    private String name;
    private int age;

    public Person() {
    }

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    @Override
    public String toString() {
        return "Person [name=" + name + ", age=" + age + "]";
    }
}
```

实现序列化和反序列

```java
package JavaIO.Serilizable;

import java.io.*;
public class Seriliz {

    public static void main(String[] args) throws IOException, Exception {
        File file = new File("/tmp/seri.txt");
        ObjectOutputStream oos = new ObjectOutputStream(
                new FileOutputStream(file));
        Person per = new Person("Names", 20);

        //对象序列化
        oos.writeObject(per);

        oos.close();

        ObjectInputStream ois = new ObjectInputStream(
                new FileInputStream(file));
        //反序列化
        Person per1 = (Person) ois.readObject();
        System.out.println(per1);
        ois.close();
    }

}

//seri.txt的文件内容为
��srJavaIO.Serilizable.PersonIageLnametLjava/lang/String;xptNames
// 注意序列化的数据通常以AC ED开始
$ hexdump /tmp/seri.txt
0000000 ac ed 00 05 73 72 00 19 4a 61 76 61 49 4f 2e 53
0000010 65 72 69 6c 69 7a 61 62 6c 65 2e 50 65 72 73 6f
0000020 6e 00 00 00 00 00 00 00 01 02 00 02 49 00 03 61
0000030 67 65 4c 00 04 6e 61 6d 65 74 00 12 4c 6a 61 76
0000040 61 2f 6c 61 6e 67 2f 53 74 72 69 6e 67 3b 78 70
0000050 00 00 00 14 74 00 05 4e 61 6d 65 73
000005c
```

#### 自定义序列化内容

java.io.Serializable接口是一个空接口，它只是表示对象有序列化的内容。但不指定其序列化的内容，如果需要定制类的序列化内容，则可以实现java.io.Externalizable接口，该接口的定义如下

```java
public  interface Externalizable extends Serializable{
	//在方法中指定要保存的属性信息.对象序列化时调用
	public void writeExternal(ObjectOutput out); 
	//在此方法中读取被保存的信息.对象反序列化时调用
	public void readExternal(ObjectInput in); 
}

public class Person implements Externalizable {

    private String name;
    private int age;

    public Person() {
    }

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    @Override
    public String toString() {
        return String.format("My name is %s, and I'm %d years old.",
                name, age);
    }

    @Override
    public void writeExternal(ObjectOutput out) throws IOException {
        int strLen = (name == null) ? -1 : name.length();
        out.writeInt(strLen);

        if (strLen > 0) {
            out.write(name.getBytes(Charset.forName("UTF-8")));
        }

        out.writeInt(age);
    }

    @Override
    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
        int strLen = in.readInt();
        if (strLen <= -1) {
            name = null;
        } else if (strLen == 0) {
            name = "";
        } else {
            byte[] strBytes = new byte[strLen];
            in.readFully(strBytes);
            name = new String(strBytes, Charset.forName("UTF-8"));
        }

        age = in.readInt();
    }
}
```

如上通过实现Externalizable接口可以完成自定义内容的序列化。另外查阅java.io.ObjectInputStream和java.io.ObjectOutputStream的核心方法，不难发现另一种方式。

```java
//ObjectInputStream 
//主义enableOverride部分
public final Object readObject()
        throws IOException, ClassNotFoundException
    {
        if (enableOverride) {
            return readObjectOverride();
        }

        // if nested read, passHandle contains handle of enclosing object
        int outerHandle = passHandle;
        try {
            Object obj = readObject0(false);
            handles.markDependency(outerHandle, passHandle);
            ClassNotFoundException ex = handles.lookupException(passHandle);
            if (ex != null) {
                throw ex;
            }
            if (depth == 0) {
                vlist.doCallbacks();
            }
            return obj;
        } finally {
            passHandle = outerHandle;
            if (closed && depth == 0) {
                clear();
            }
        }
    }
    
// java.io.ObjectOutputStream
// 主义enableOverride部分
    public final void writeObject(Object obj) throws IOException {
        if (enableOverride) {
            writeObjectOverride(obj);
            return;
        }
        try {
            writeObject0(obj, false);
        } catch (IOException ex) {
            if (depth == 0) {
                writeFatalException(ex);
            }
            throw ex;
        }
    }
```

从上述的JDK的实现中不难发现，处理实现Externalizable外，还有在序列化对象中实现readObject()和writeObject()方法同样也能实现自动以序列化和发序列化。并且相对使用接口的方式进行序列化，直接实现readObject()和writeObject()方法更加可控些。

```java
public class Person implements Serializable {

    private String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    @Override
    public String toString() {
        return String.format("My name is %s, and I'm %d years old.",
                name, age);
    }

    private void writeObject(ObjectOutputStream out) throws IOException {
        int strLen = (name == null) ? -1 : name.length();
        out.writeInt(strLen);

        if (strLen > 0) {
            out.write(name.getBytes(Charset.forName("UTF-8")));
        }

        out.writeInt(age);
    }

    private void readObject(ObjectInputStream in) throws
            ClassNotFoundException, IOException {
        int strLen = in.readInt();
        if (strLen <= -1) {
            name = null;
        } else if (strLen == 0) {
            name = "";
        } else {
            byte[] strBytes = new byte[strLen];
            in.readFully(strBytes);
            name = new String(strBytes, Charset.forName("UTF-8"));
        }

        age = in.readInt();
    }
}
```

#### 反序列漏洞产生的原因

反序列化漏洞的产生的原因就在于enableOverride这个控制项上，它除了给程序编程带来更加丰富和实用的功能外，同时也打破了数据和对象的边界，导致利用者可以将注入任意序列化数据在反序列化的过程中。下面是一个简单的Demo

```java
package JavaIO.Serilizable;

import java.io.IOException;
import java.io.Serializable;

/**
 * Created by 0opslab
 */
public class SomeObject implements Serializable{
    public String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    //override
    private void readObject(java.io.ObjectInputStream in) 
      throws IOException, ClassNotFoundException{
        //执行默认的readObject()方法
        in.defaultReadObject();
        //执行命令
        Runtime.getRuntime().exec("touch /tmp/1.txt");
    }
  
  
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        SomeObject object = new SomeObject();
        object.setName("evilC0de");

        File file = new File("/tmp/2.obj");
        FileOutputStream fos = new FileOutputStream(file);
        ObjectOutputStream os = new ObjectOutputStream(fos);
        //writeObject()方法将Unsafe对象写入object文件
        os.writeObject(object);
        os.close();
        //从文件中反序列化obj对象
        FileInputStream fis = new FileInputStream(file);
        ObjectInputStream ois = new ObjectInputStream(fis);
        //恢复对象
        SomeObject objectFromDisk = (SomeObject) ois.readObject();
        System.out.println(objectFromDisk.name);
        ois.close();
    }
  
}

```

如上程序执行完后会创建一个文件/tmp/1.txt。这就是一个简单的安全的问题。

参考:

http://wouter.coekaerts.be/2015/annotationinvocationhandler



































