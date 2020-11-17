---
layout: news-item
title: 'Netty/Incubator/Transport/Native/io_uring 0.0.1.Final released'
author: normanmaurer
---

After multiple months of development I am happy to announce the first incubator release of our native io_uring based transport. 
If you don't know about io_uring I highly recommend getting up to speed by reading [Efficient IO with io_uring](https://kernel.dk/io_uring.pdf) and
[Lord of the io_ring](https://unixism.net/loti/what_is_io_uring.html). To make it short, it is a new way how programs can talk to the kernel (and be notified back) via memory mapped ring-buffers. This way it is possible to almost eliminate all syscalls that are usually needed for network I/O. 

# Incubator, what does this mean ?

To be able to work on new exciting features without "affecting" the core of netty we decided to start development of such features in the "incubator". This means these features will be developed in a seperate repository and only be merged back into the core netty repository once we feel that we can guarantee we not need to break the API anymore and consider these production ready. This hopefully helps to clarify expections and stability of the code and so people should be fully aware that APIs may change. Beside this it also allows to use different release schedules.

# How can I use the io_uring based transport?

First of you need to run on x86_64 linux and have a recent kernel. To be able to use io_uring without encountering "slowdowns" and "bugs" you need at least using [Linux Kernel](https://www.kernel.org) 5.9.0, any newer kernel will be fine as well. After this requirement is fullfilled it's just a matter of adding the right jar to your classpath and bootstrap using the right `EventLoopGroup` and `Channel` implementation.

An example for maven would be:

```
<dependency>
    <groupId>io.netty.incubator</groupId>
    <artifactId>netty-incubator-transport-native-io_uring</artifactId>
    <version>0.0.1.Final</version>
    <classifier>linux-x86_64</classifier>
</dependency>
```

Bootstrapping a server is as easy as:

```java
EventLoopGroup group = new IOUringEventLoopGroup();
try {
    final ChannelHandler serverHandler = ...;

    ServerBootstrap b = new ServerBootstrap();
    b.group(bossGroup, workerGroup)
     .channel(IOUringServerSocketChannel.class)
     .childHandler(new ChannelInitializer<SocketChannel>() {
        @Override
        public void initChannel(SocketChannel ch) throws Exception {
            ChannelPipeline p = ch.pipeline();
            p.addLast(serverHandler);
        }
    });

    // Start the server.
    ChannelFuture f = b.bind(PORT).sync();

    // Wait until the server socket is closed.
    f.channel().closeFuture().sync();
} finally {
    // Shut down all event loops to terminate all threads.
    group.shutdownGracefully();
}
```

The same is true for the client as well, just be sure you use the correct `Channel` and `EventLoop` implementation.

# What features are supported at the moment ?

At the moment we support `IOUringServerChannel`, `IOUringChannel` and `IOUringDatagramChannel`, which basically means TCP and UDP. One gotcha is that `FileRegion` is currently not supported, but will be added in the future.

# Where can I find the issue tracker / code etc ?

As stated before this feature is developed outside of the "normal" netty tree. You can find it in the [netty-incubator-transport-io_uring](https://github.com/netty/netty-incubator-transport-io_uring) repository.

# Are there any performance numbers?

While we plan to run some more advanced and real performance benchmarks in the future what we saw so far is really promising. To give you an idea let's have a look...

__epoll__:

```
./tcpkali  -m xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  --connect-rate=200 -c 500 -T 30 127.0.0.1:8088
Destination: [127.0.0.1]:8088
Interface lo address [127.0.0.1]:0
Using interface lo to connect to [127.0.0.1]:8088
Ramped up to 500 connections.
Total data sent:     35254.6 MiB (36967084668 bytes)
Total data received: 35725.3 MiB (37460714661 bytes)
Bandwidth per channel: 39.688⇅ Mbps (4961.0 kBps)
Aggregate bandwidth: 9987.847↓, 9856.234↑ Mbps
Packet rate estimate: 861701.3↓, 851472.0↑ (11↓, 43↑ TCP MSS/op)
Test duration: 30.005 s.

Running `target/release/echo_bench --address 'localhost:8088' --number 500 --duration 30 --length 128`
Benchmarking: localhost:8088
500 clients, running 128 bytes, 30 sec.

Speed: 80820 request/sec, 80820 response/sec
Requests: 2424626
Responses: 2424625
```

__io_uring__

```
./tcpkali  -m xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  --connect-rate=200 -c 500 -T 30 127.0.0.1:8081
Destination: [127.0.0.1]:8081
Interface lo address [127.0.0.1]:0
Using interface lo to connect to [127.0.0.1]:8081
Ramped up to 500 connections.
Total data sent:     74653.1 MiB (78279409944 bytes)
Total data received: 75180.9 MiB (78832885977 bytes)
Bandwidth per channel: 83.793⇅ Mbps (10474.1 kBps)
Aggregate bandwidth: 21021.980↓, 20874.387↑ Mbps
Packet rate estimate: 1932417.0↓, 1793964.8↑ (11↓, 39↑ TCP MSS/op)
Test duration: 30.0002 s.

Running `target/release/echo_bench --address 'localhost:8081' --number 500 --duration 30 --length 128`
Benchmarking: localhost:8081
500 clients, running 128 bytes, 30 sec.

Speed: 267371 request/sec, 267370 response/sec
Requests: 8021137
Responses: 8021128
```


This benchmark is basically sending data and expect the data to be echoed back. The server itself uses 1 thread to handle all of this. Please be aware this is only a quick benchmark on localhost and a "real" benchmark over the network with real hardware should be done to full understand the wins and gains.

```java
@Sharable
public class EchoServerHandler extends ChannelInboundHandlerAdapter {

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) {
        ctx.write(msg);
    }

    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) {
        ctx.flush();
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        // Close the connection when an exception is raised.
        ctx.close();
    }

    @Override
    public void channelWritabilityChanged(ChannelHandlerContext ctx) throws Exception {
        // Ensure we are not writing to fast by stop reading if we can not flush out data fast enough.
        if (ctx.channel().isWritable()) {
            ctx.channel().config().setAutoRead(true);
        } else {
            ctx.flush();
            if (!ctx.channel().isWritable()) {
                ctx.channel().config().setAutoRead(false);
            }
        }
    }
}

// This is using io_uring
public class EchoIOUringServer {
    private static final int PORT = Integer.parseInt(System.getProperty("port", "8081"));

    public static void main(String []args) {
        EventLoopGroup group = new IOUringEventLoopGroup(1);
        final EchoServerHandler serverHandler = new EchoServerHandler();
        try {
            ServerBootstrap b = new ServerBootstrap();
            b.group(bossGroup, workerGroup)
                    .option(ChannelOption.SO_REUSEADDR, true)
                    .channel(IOUringServerSocketChannel.class)
                    .childHandler(new ChannelInitializer<SocketChannel>() {
                        @Override
                        public void initChannel(SocketChannel ch) throws Exception {
                            ChannelPipeline p = ch.pipeline();
                            //p.addLast(new LoggingHandler(LogLevel.INFO));
                            p.addLast(serverHandler);
                        }
                    });

            // Start the server.
            ChannelFuture f = b.bind(PORT).sync();

            // Wait until the server socket is closed.
            f.channel().closeFuture().sync();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            // Shut down all event loops to terminate all threads.
            group.shutdownGracefully();
        }
    }
}

// This is using epoll / syscalls 
public class EchoNioServer {
    private static final int PORT = Integer.parseInt(System.getProperty("port", "8088"));

    public static void main(String []args) {
        EventLoopGroup group = new NioEventLoopGroup(1);
        final EchoServerHandler serverHandler = new EchoServerHandler();
        try {
            ServerBootstrap b = new ServerBootstrap();
            b.group(bossGroup, workerGroup)
                    .option(ChannelOption.SO_REUSEADDR, true)
                    .channel(NioServerSocketChannel.class)
                    .childHandler(new ChannelInitializer<SocketChannel>() {
                        @Override
                        public void initChannel(SocketChannel ch) throws Exception {
                            ChannelPipeline p = ch.pipeline();
                            //p.addLast(new LoggingHandler(LogLevel.INFO));
                            p.addLast(serverHandler);
                        }
                    });

            // Start the server.
            ChannelFuture f = b.bind(PORT).sync();

            // Wait until the server socket is closed.
            f.channel().closeFuture().sync();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            // Shut down all event loops to terminate all threads.
            group.shutdownGracefully();
        }
    }
}
```

# Thank You

Big thank you to all the people that were involved so far to make this happen. A special thank you goes out to [Josef Grieb](https://github.com/1Jo1) who did start this project as part of [GSOC 2020](https://github.com/netty/netty/wiki/Google-Summer-of-Code-Ideas-2020#add-io_uring-based-transport). Without Josef this would not have been possible in this short time-frame. Beside Josef I would also like to say "thank you" to [Jens Axboe](https://github.com/axboe), whom is the main author of io_uring. Whenever we had questions or problems he was happy to help. That's what OSS is really about. OSS FTW!.

