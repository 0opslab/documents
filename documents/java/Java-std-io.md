title: Java IO
date: 2016-10-2Java中的2 22:17:23
tags: Java
categories: Java
---
[本文内容源于网络,谢谢原作者的分享]Java中的IO主要源自与网络和本地文件.IO的方式通常分为：**同步阻塞的BIO**、**同步非阻塞的NIO**、**异步非阻塞的AIO**几种。他们有各自的优缺点,只有掌握了其本质,才能选择适合当前环境类型，从而进行编码！

#### 同步与异步
同步和异步是针对应用程序而言的。同步值的是用户进程触发IO操作并等待或者轮询的娶查看IO操作是否就绪。而异步是指用户进程触发IO操作以后变开始做别的事情，而当IO操作已经完成的时候才会得到IO完成的通知。

#### 阻塞和非阻塞
阻塞和非阻塞关注的是程序在等待调用结果（消息，返回值）时的状态.阻塞调用是指调用结果返回之前，当前线程会被挂起，调用线程只有在得到结果之后才会返回。非阻塞调用指在不能立即得到结果之前，该调用不会阻塞当前线程。

#### Java对BIO、NIO、AIO的支持
#####BIO
同步并阻塞，服务器实现模式为一个连接一个线程，即客户端有连接请求时服务器端就需要启动一个线程进行处理，如果这个连接不做任何事情会造成不必要的线程开销，当然可以通过线程池机制改善。
#####NIO
同步非阻塞，服务器实现模式为一个请求一个线程，即客户端发送的连接请求都会注册到多路复用器上，多路复用器轮询到连接有I/O请求时才启动一个线程进行处理。
#####AIO
异步非阻塞，服务器实现模式为一个有效请求一个线程，客户端的I/O请求都是由OS先完成了再通知服务器应用去启动线程进行处理


#### TCP/IP + BIO
Socket和ServerSocket实现，ServerSocket实现Server端端口监听，Socket用于建立网络IO连接。不适用于处理多个请求.。BIO情况下，能支持的连接数有限，一般都采取accept获取Socket以后采用一个thread来处理，one connection one thread。无论连接是否有真正数据请求，都需要独占一个thread。可以通过设立Socket池来一定程度上解决问题。
```java
//非线程池方式实现
public class TimeServer {
    private static int port = 4567;

    public static void main(String[] args) {
        try (ServerSocket serverSocket = new ServerSocket(port)) {
            System.out.println("Time server start!");
            while (true) {
                Socket socket = serverSocket.accept();
                new Thread(new TimeServerHandler(socket)).start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
//线程池方式实现
public class TimeServerPool {
    public static void main(String[] args) {
        //创建一个固定数量的线程池
        ExecutorService executorService = Executors.newFixedThreadPool(10);

        try (ServerSocket serverSocket = new ServerSocket(4567)) {
            System.out.println("Time server start!");
            while (true) {
                Socket socket = serverSocket.accept();
                executorService.execute(new TimeServerHandler(socket));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
/**
 * 处理客户端请求
 */
public class TimeServerHandler implements Runnable{

    private Socket socket;

    public TimeServerHandler(Socket socket) {
        this.socket = socket;
    }

    @Override
    public void run() {
        BufferedReader in = null;
        PrintWriter out = null;
        try {
            in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            out = new PrintWriter(this.socket.getOutputStream(), true);
            String body = null;
            while (true) {
                body = in.readLine();
                if (body == null)
                    break;
                String temp = "QUERY TIME ORDER".equals(body) ? (new Date()).toString() : "BAD ORDER";
                out.println(temp);
                System.out.println(temp);
            }

        } catch (Exception e) {

        } finally {
            try {
                if (in != null) {
                    in.close();
                }
                if (out != null) {
                    out.close();
                }
                if (this.socket != null) {
                    socket.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
//客户端
public class TimeClient {
    public static void main(String[] args) {
        for (int i = 0; i < 1000; i++) {
            new Thread(new TimeClientHandler("127.0.0.1", 4567)).start();
        }
    }

    public static class TimeClientHandler implements Runnable {
        private String ip;
        private int port;

        public TimeClientHandler(String ip, int port) {
            this.ip = ip;
            this.port = port;
        }

        @Override
        public void run() {
            BufferedReader in = null;
            PrintWriter out = null;
            try (Socket socket = new Socket(ip, port)) {
                in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                out = new PrintWriter(socket.getOutputStream(), true);
                out.println("QUERY TIME ORDER");
                System.out.println(Thread.currentThread().getName() + "=> time:" + in.readLine());
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (in != null) {
                        in.close();
                    }
                    if (out != null) {
                        out.close();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```
#### TCP/IP+NIO
NIO提供了与传统BIO模型中的Socket和ServerSocket相对应的SocketChannel和ServerSocketChannel两种不同的套接字通道实现。新增的着两种通道都支持阻塞和非阻塞两种模式。阻塞模式使用就像传统中的支持一样，比较简单，但是性能和可靠性都不好；非阻塞模式正好与之相反。对于低负载、低并发的应用程序，可以使用同步阻塞I/O来提升开发速率和更好的维护性；对于高负载、高并发的（网络）应用，应使用NIO的非阻塞模式来开发。
下面是一个使用NIO的服务端实现
```java
package netty.jdknio;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.Iterator;
import java.util.Set;

/**
 * 与Socket类和ServerSocket类相对应的NIO也提供了SocketChannel和ServetSokcetChannel俩个不同的套机字通道
 * 他们都支持阻塞和非阻塞俩种模式
 */
public class TimeServer implements Runnable {
    private ServerSocketChannel serverSocketChannel;

    private Selector selector;

    private volatile boolean IS_STARTED = false;

    public TimeServer(int port) throws IOException {
        //创建箭筒通道并设置通道为非阻塞模式
        serverSocketChannel = ServerSocketChannel.open();
        serverSocketChannel.configureBlocking(false);

        //绑定端口(backlog为1024)
        serverSocketChannel.socket().bind(new InetSocketAddress(port), 1024);

        //创建选择器
        selector = Selector.open();

        //将选择器注册到监听服务上
        serverSocketChannel.register(selector, SelectionKey.OP_ACCEPT);
        IS_STARTED = true;
        System.out.println("服务启动成功");
    }


    @Override
    public void run() {
        //循环遍历selector
        while (IS_STARTED) {
            try {
                //无论是否有读写事件发生，selector每隔1s被唤醒一次
                selector.select(1000);
                //阻塞,只有当至少一个注册的事件发生的时候才会继续.
//              selector.select();
                Set<SelectionKey> keys = selector.selectedKeys();
                Iterator<SelectionKey> it = keys.iterator();
                SelectionKey key = null;
                while (it.hasNext()) {
                    key = it.next();
                    it.remove();
                    try {
                        handleInput(key);
                    } catch (Exception e) {
                        if (key != null) {
                            key.cancel();
                            if (key.channel() != null) {
                                key.channel().close();
                            }
                        }
                    }
                }
            } catch (Throwable t) {
                t.printStackTrace();
            }
        }
        //selector关闭后会自动释放里面管理的资源
        if (selector != null)
            try {
                selector.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
    }

    private void handleInput(SelectionKey key) throws IOException {
        if (key.isValid()) {
            //处理新接入的请求消息
            if (key.isAcceptable()) {
                ServerSocketChannel ssc = (ServerSocketChannel) key.channel();
                //通过ServerSocketChannel的accept创建SocketChannel实例
                //完成该操作意味着完成TCP三次握手，TCP物理链路正式建立
                SocketChannel sc = ssc.accept();
                //设置为非阻塞的
                sc.configureBlocking(false);
                //注册为读
                sc.register(selector, SelectionKey.OP_READ);
            }
            //读消息
            if (key.isReadable()) {
                SocketChannel sc = (SocketChannel) key.channel();
                //创建ByteBuffer，并开辟一个1M的缓冲区
                ByteBuffer buffer = ByteBuffer.allocate(1024);
                //读取请求码流，返回读取到的字节数
                int readBytes = sc.read(buffer);
                //读取到字节，对字节进行编解码
                if (readBytes > 0) {
                    //将缓冲区当前的limit设置为position=0，用于后续对缓冲区的读取操作
                    buffer.flip();
                    //根据缓冲区可读字节数创建字节数组
                    byte[] bytes = new byte[buffer.remaining()];
                    //将缓冲区可读字节数组复制到新建的数组中
                    buffer.get(bytes);
                    String msg = new String(bytes, "UTF-8");
                    System.out.println("服务器收到消息：" + msg);
                    //发送应答消息
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    doWrite(sc, "服务器响应:" + msg);
                }
                //没有读取到字节 忽略
//              else if(readBytes==0);
                //链路已经关闭，释放资源
                else if (readBytes < 0) {
                    key.cancel();
                    sc.close();
                }
            }
        }
    }

    //异步发送应答消息
    private void doWrite(SocketChannel channel, String response) throws IOException {
        //将消息编码为字节数组
        byte[] bytes = response.getBytes();
        //根据数组容量创建ByteBuffer
        ByteBuffer writeBuffer = ByteBuffer.allocate(bytes.length);
        //将字节数组复制到缓冲区
        writeBuffer.put(bytes);
        //flip操作
        writeBuffer.flip();
        //发送缓冲区的字节数组
        channel.write(writeBuffer);
        //****此处不含处理“写半包”的代码
    }

    public static void main(String[] args) throws IOException {

        new Thread(new TimeServer(4567)).start();


    }
}

```

#### TCP/IP + AIO
NIO 2.0引入了新的异步通道的概念，并提供了异步文件通道和异步套接字通道的实现。异步的套接字通道时真正的异步非阻塞I/O，实现了正真以上的网络编程中的事件驱动I/O（AIO）。他不需要过多的Selector对注册的通道进行轮询即可实现异步读写，从而简化了NIO的编程模型。
在JDK1.7中，这部分内容被称作NIO.2，主要在java.nio.channels包下增加了下面四个异步通道：
```java
	AsynchronousSocketChannel
	AsynchronousServerSocketChannel
	AsynchronousFileChannel
	AsynchronousDatagramChannel
```	
其中的read/write方法，会返回一个带回调函数的对象，当执行完读取/写入操作后，直接调用回调函数。
```java
public class PlainNio2EchoServer {
  public void serve(int port) throws IOException {
    System.out.println("Listening for connections on port " + port);
    final AsynchronousServerSocketChannel serverChannel = AsynchronousServerSocketChannel.open();
    InetSocketAddress address = new InetSocketAddress(port);
    // Bind Server to port
    serverChannel.bind(address);
    final CountDownLatch latch = new CountDownLatch(1);
    // Start to accept new Client connections. Once one is accepted the CompletionHandler will get called.
    serverChannel.accept(null, new CompletionHandler<AsynchronousSocketChannel, Object>() {
      @Override
      public void completed(final AsynchronousSocketChannel channel, Object attachment) {
        // Again accept new Client connections
        serverChannel.accept(null, this);
        ByteBuffer buffer = ByteBuffer.allocate(100);
        // Trigger a read operation on the Channel, the given CompletionHandler will be notified once something was read
        channel.read(buffer, buffer, new EchoCompletionHandler(channel));
      }

      @Override
      public void failed(Throwable throwable, Object attachment) {
        try {
          // Close the socket on error
          serverChannel.close();
        } catch (IOException e) {
          // ingnore on close
        } finally {
          latch.countDown();
        }
      }
    });
    try {
      latch.await();
    } catch (InterruptedException e) {
      Thread.currentThread().interrupt();
    }
  }

  private final class EchoCompletionHandler implements CompletionHandler<Integer, ByteBuffer> {
    private final AsynchronousSocketChannel channel;

    EchoCompletionHandler(AsynchronousSocketChannel channel) {
      this.channel = channel;
    }

    @Override
    public void completed(Integer result, ByteBuffer buffer) {
      buffer.flip();
      // Trigger a write operation on the Channel, the given CompletionHandler will be notified once something was written
      channel.write(buffer, buffer, new CompletionHandler<Integer, ByteBuffer>() {
        @Override
        public void completed(Integer result, ByteBuffer buffer) {
          if (buffer.hasRemaining()) {
            // Trigger again a write operation if something is left in the ByteBuffer
            channel.write(buffer, buffer, this);
          } else {
            buffer.compact();
            // Trigger a read operation on the Channel, the given CompletionHandler will be notified once something was read
            channel.read(buffer, buffer, EchoCompletionHandler.this);
          }
        }

        @Override
        public void failed(Throwable exc, ByteBuffer attachment) {
          try {
            channel.close();
          } catch (IOException e) {
            // ingnore on close
          }
        }
      });
    }

    @Override
    public void failed(Throwable exc, ByteBuffer attachment) {
      try {
        channel.close();
      } catch (IOException e) {
        // ingnore on close
      }
    }
  }
}
```