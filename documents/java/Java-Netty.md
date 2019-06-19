title: netty简单入门
date: 2016-10-24 16:49:54
tags: 
	- Java
	- netty
categories: Java
---
## 服务端程序开发
Netty为了向使用者屏蔽NIO通信的底层细节,在和用户交互的边界做了封装，目的就是为了减少用户开发工作量，降低开发难度.通过ServerBootstrap能快速的创建socket服务端。下面是使用Netty服务端创建的基本步骤
>* 1.创建ServerBootstrap实例
>* 2.设置并绑定Reacotr线程池。Netty的Reactor线程池是EventLoopGroup。
>*   EventLoop会处理所有注册到本线程多路复用器Selector上Channel。
>* 3.设置并绑定服务端的Channel.
>* 4.链接建立的时候创建并初始化ChannelPipeline。(一个负责处理网络时间的职责链,负责变量和执行ChanelHandler)
>*   网络事件以事件流的形式在ChannelPipeline中流转，有ChannelPipeline根据ChannelHnadler的执行策略调用ChannelHandler执行
>* 5.添加并绑定ChannelHandler。该类是Netty提供给用户定制和扩展的关键接口。利用该接口,用户客户完成大多数的功能定制
>*   例如消息解码、心跳、安全认证、TSL/SSL认证、流量控制等。
>* 6.绑并启动端口监听
>* 7.selector轮询。由Reactor线程的NioEventLoop负责调度和执行Selector轮询，选择准备就绪的Channel集合
>* 8.当轮询掉准备就绪的Channel之后,就由Reactor线程NioEventLoop执行ChannelPipeline的相应方法,最终调用并执行ChannelHandler

下面是一个完整的服务端实例程序的实例
```java
package netty.demo;

import com.opslab.util.DateUtil;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;

import java.net.InetSocketAddress;

/**
 *使用netty开发Time Server
 */
public class TimeServer {
    public void bind(String host,int port) throws InterruptedException {
        //配置俩组NIO线程组,一组用于数据传输,一组用于接受请求
        //NioEventLoopGroup实际上就是Reactor线程池,负责调度和执行客户端的介入
        //网络读写事件的处理、用户自定义方法和定时任务的执行
        EventLoopGroup bossGroup = new NioEventLoopGroup();
        EventLoopGroup workerGroup =  new NioEventLoopGroup();

        try {
            //启动并绑定监听
            ServerBootstrap boot = new ServerBootstrap();
            boot.group(bossGroup, workerGroup)
                    //绑定服务端的类型
                    .channel(NioServerSocketChannel.class)
                    //设定套接字参数
                    //backlog表示为此套接字排队的最大连接数
                    .option(ChannelOption.SO_BACKLOG, 1024)
                    //绑定真正的请求处理类
                    .childHandler(new ChannelInitializer<SocketChannel>(){
                        @Override
                        protected void initChannel(SocketChannel channel) throws Exception {
                            channel.pipeline().addLast(new TimeServerHandler());
                        }
                    });
            //事实端口绑定,并等待同步成功
            ChannelFuture future = boot.bind(new InetSocketAddress(host, port)).sync();

            System.out.println("TimeServer is started in port:"+port);
            //等待服务器端口监听关闭
            future.channel().closeFuture().sync();

        }finally {
            //是否线程资源
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }
    }

    private class TimeServerHandler extends ChannelHandlerAdapter{
        @Override
        public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
            //读取信息
            ByteBuf buf = (ByteBuf)msg;
            byte[] bytes = new byte[buf.readableBytes()];
            buf.readBytes(bytes);
            String content = new String(bytes,"UTF-8");
            System.out.println("server receive:"+content);


            //给客户端响应
            ByteBuf result  = Unpooled.copiedBuffer(DateUtil.currentDateTime().getBytes());
            ctx.write(result);
            //ctx.writeAndFlush(result);

        }
        @Override
        public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {
            //当读操作完成后不刷新的话,客户端是收不到响应结果的
            ctx.flush();
        }

        @Override
        public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
            ctx.close();
        }
    }

    public static void main(String[] args) throws InterruptedException {
        new TimeServer().bind("127.0.0.1",4567);
    }
}

```
### 服务端编码最佳实践
#### 时间可控的简单业务直接在Handler中处理
时间可控的简单业务直接在I/O线程上处理,如果业务非常简单，执行非常短，不需要与外部网元交互、访问数据库和磁盘、不需要等待其他资源，直接在ChannelHandler中执行.
#### 复杂和时间不可控业务投递到后端业务线程池
复杂和时间不可的业务建议将不同的业务封装成Task然后投递到后台业务线程池中进行处理。同时一定要避免业务线程直接操作ChannelHandler。

## Channel/ChannelHandler/ChanelPipeline
在netty中channel相对更多的面向于编程者,因此对其掌握的掌握更加显得重要.Channel是通讯的载体，而ChannelHandler负责处理Channel中的数据。Channel是有状态的,当其状态发生变化就会触发对应的事件,而ChannelPipeline中的ChannelHandler中的相应的事件处理方法就会呗触发！
### Channel
Channel的状态与ChannelInboundHandler密切相关，下面是Channel的状态
```bava
channellUnregistered//channel已经创建但未注册到EventLoop上
channelRegistered//channel注册到一个EventLoop
channelActive//channel处于活跃状态(已经连接到了远程主机).现在可以接受/发送数据了
channelInactive//channel处于非活跃状态，没有连接到远程主机
```
### ChannelPipeline
查阅其源码可以发现ChannelPipeline实现Iterable接口,因此可以将其看成一个列表，事实上它就是ChannelHandler实例的一个列表，用于处理或拦截通道的接收和发送数据。ChannelPipeline提供了一种高级的截取过滤器模式，让编码者可以在ChannelPipeline中完全控制一个事件及如何处理ChannelHandler与channelPipeline的交互。每一个新的通道都会创建一个新的ChannelPipeline并附加至通道。一旦连接Channel和ChannelPipeline之间的耦合就是永久的。Channel不能附加其他的ChannelPipeline或从ChannelPipeline分离。

与其说ChannelPipeline是一个列表不如说其就是类似于JavaWeb中Filter,一个有ChannelHandler组成的fliter。如果一个入站I/O事件被触发，这个事件会从第一个开始依次通过ChannelPipeline中的ChannelHandler；若是一个入站I/O事件，则会从最后一个开始依次通过ChannelPipeline中的ChannelHandler。ChannelHandler可以处理事件并检查类型，如果某个ChannelHandler不能处理则会跳过，并将事件传递到下一个ChannelHandler。ChannelPipeline可以动态添加、删除、替换其中的ChannelHandler，这样的机制可以提高灵活性。因此该接口中有大量类似add/remove/before/after之类的方法用于操作该列表的元素以及元素的位置。

### ChannelHandler 与 ChannelHandlerContext
ChannelHandler可以说是一种编程模型，基于ChannelHandler开发业务逻辑，基本不需要关心网络通讯方面的事情，专注于编码/解码/逻辑处理就可以了。每个ChannelHandler被添加到ChannelPipeline后都会创建一个ChannelHandlerContext并与之关联绑定。ChannelHandlerContext允许ChannelHandler与其他的ChannelHandler实现进行交互，这是相同ChannelPipeline的一部分。ChannelHandlerContext不会改变添加到其中的ChannelHandler，因此它是安全的。
另外Netty还提供了一个实现了ChannelHandler的抽象类：ChannelHandlerAdapter。ChannelHandlerAdapter实现了父类的所有方法，基本上就是传递事件到ChannelPipeline中的下一个ChannelHandler直到结束。一般编码制只要集成ChannelHandlerAdapter类并只实现自己关心的事件处理即可。在老版本的Netty中还是俩个接口ChannelInboundHandler(处理进站数据和所有状态更改事件) 和ChannelOutboundHandler (处理出站数据，允许拦截各种操作)在一些业务系统中使用的比较多,但是新版本中已经移除该接口。

#### 编码器/解码器
因为ChannelHandler更加面向编码者，为了你我他少加班,Netty提供了些不错的ChannelHandler实现类。它们以适配器adapter命名。
其中编码器和解码器就是其中的一种(编码器/解码器 如果想自己实现一个加密聊天系统采用这种方式是个不错的选择哦)。
不同类型的抽象类用于提供编码器和解码器的，这取决于手头的任务。例如，应用程序可能并不需要马上将消息转为字节。相反，该​​消息将被转换 一些其他格式。一个编码器将仍然可以使用，但它也将衍生自不同的超类，
在一般情况下，基类将有一个名字类似 ByteToMessageDecoder 或 MessageToByteEncoder。在一种特殊类型的情况下，你可能会发现类似 ProtobufEncoder 和 ProtobufDecoder，用于支持谷歌的 protocol buffer。

##### 粘包问题的解决策略
由于底层的TCP无法理解上层业务数据，所以在底层是无法保证数据包不被拆分和重组，这个问题只能通过上层的应用协议栈设计来解决，一般都有如下几种解决方案:
1.消息定长.例如每个报文的大小为固定长度200字节，如果不够，空位补空格
2.在包尾增加回车换行符进行分割，例如FTP协议
3.将消息分为消息头和消息体，消息头中包含表示消息总长度或者消息体长度的字段。更复杂的应用层协议。
在Netty中提供了默认的解码器LineBasedFrameDecoder、DelimiterBasedFrameDecoder、FixedLengthFrameDecoder

下面是一个使用adapter解码器解决粘包问题实例
```java
//服务端编码实现
package netty.demo;

import com.opslab.util.DateUtil;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.handler.codec.string.StringEncoder;
import io.netty.util.CharsetUtil;
import io.netty.buffer.Unpooled;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.LineBasedFrameDecoder;
import io.netty.handler.codec.string.StringDecoder;

import java.net.InetSocketAddress;

/**
 * 利用LineBasedFrameDecoder和StringDecoder测试TCP的粘包问题
 */
public class LineBasedFrameDecoderServer {
    private static final String CR = System.getProperty("line.separator");

    public void server(String host,int port) throws InterruptedException {
        //配置俩组NIO线程组,一组用于数据传输,一组用于接受请求
        //NioEventLoopGroup实际上就是Reactor线程池,负责调度和执行客户端的介入
        //网络读写事件的处理、用户自定义方法和定时任务的执行
        EventLoopGroup bossGroup = new NioEventLoopGroup();
        EventLoopGroup workerGroup =  new NioEventLoopGroup();

        try {
            //启动并绑定监听
            ServerBootstrap boot = new ServerBootstrap();
            boot.group(bossGroup, workerGroup)
                    //绑定服务端的类型
                    .channel(NioServerSocketChannel.class)
                    //设定套接字参数
                    //backlog表示为此套接字排队的最大连接数
                    .option(ChannelOption.SO_BACKLOG, 1024)
                    //绑定真正的请求处理类
                    .childHandler(new ChannelInitializer<SocketChannel>(){
                        @Override
                        protected void initChannel(SocketChannel channel) throws Exception {
                            //添加行解码器
                            channel.pipeline().addLast(new LineBasedFrameDecoder(2048));
                            //添加字符编码器
                            channel.pipeline().addLast(new StringEncoder(CharsetUtil.UTF_8));
                            //添加字符解码器
                            channel.pipeline().addLast(new StringDecoder(CharsetUtil.UTF_8));
                            //添加业务处理类
                            channel.pipeline().addLast( new DecoderServerHandler());
                        }
                    });
            //事实端口绑定,并等待同步成功
            ChannelFuture future = boot.bind(new InetSocketAddress(host, port)).sync();

            System.out.println("TimeServer is started in port:"+port);
            //等待服务器端口监听关闭
            future.channel().closeFuture().sync();

        }finally {
            //是否线程资源
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }
    }

    private class DecoderServerHandler extends ChannelHandlerAdapter{
        @Override
        public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
            //读取信息
            String content = (String)msg;
            System.out.println("server receive:"+content);


            //给客户端响应
            String result = DateUtil.currentDateTime()+CR;
            ctx.writeAndFlush(Unpooled.copiedBuffer(result.getBytes()));

        }

    }

    public static void main(String[] args) throws InterruptedException {
        new LineBasedFrameDecoderServer().server("127.0.0.1", 1111);
    }
}
//客户端编码实现
package netty.demo;

import io.netty.bootstrap.Bootstrap;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioSocketChannel;
import io.netty.handler.codec.LineBasedFrameDecoder;
import io.netty.handler.codec.string.StringDecoder;
import io.netty.handler.codec.string.StringEncoder;
import io.netty.util.CharsetUtil;

/**
 * 客户端实现解决粘包的问题
 */
public class LineBasedFrameDecoderClient {
    private static final String CR = System.getProperty("line.separator");

    public void connection(String host,int port) throws InterruptedException {
        //配置NIO线程组
        EventLoopGroup group = new NioEventLoopGroup();
        Bootstrap boot = new Bootstrap();
        boot.group(group)
                .channel(NioSocketChannel.class)
                .option(ChannelOption.TCP_NODELAY,true)
                .handler(new ChannelInitializer<SocketChannel>() {
                    @Override
                    protected void initChannel(SocketChannel socketChannel) throws Exception {
                        socketChannel.pipeline().addLast(new LineBasedFrameDecoder(2048));
                        socketChannel.pipeline().addLast(new StringEncoder(CharsetUtil.UTF_8));
                        socketChannel.pipeline().addLast(new StringDecoder(CharsetUtil.UTF_8));
                        socketChannel.pipeline().addLast(new LineBasedFrameDecoder(1024),new DecoderClientHandler());
                    }
                });

        //发起异步链接操作
        ChannelFuture channelFuture = boot.connect(host, port).sync();

        //等待客户端链路关闭
        channelFuture.channel().closeFuture().sync();

        group.shutdownGracefully();

    }

    /**
     * 处理响应结果
     */
    private class DecoderClientHandler extends ChannelHandlerAdapter {

        @Override
        public void channelActive(ChannelHandlerContext ctx) throws Exception {
            //给服务器发送消息
 //           ByteBuf msg  = Unpooled.copiedBuffer("QUERY TIME ORDER\\n".getBytes());
//            ctx.writeAndFlush(msg);
            //下面的操作会出现TCP粘包的情况
            for (int i = 0; i < 100; i++) {
                ByteBuf msg  = Unpooled.copiedBuffer(("QUERY TIME ORDER"+CR).getBytes());
                ctx.writeAndFlush(msg);
            }

        }

        @Override
        public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
            //接受服务器返回的消息
            String content = (String) msg;
            System.out.println("return msg:"+content);
        }
    }



    public static void main(String[] args) throws InterruptedException {
        new LineBasedFrameDecoderClient().connection("127.0.0.1",1111);
    }
}

```

