---
layout: news-item
title: 'Release day for HTTP/3, QUIC and IO_URING'
author: normanmaurer
---

After announcing the release of [netty-4.1.62.Final](https://netty.io/news/2021/03/31/4-1-62-Final.html) earlier today I have more news to share... We did another three releases today.


## Netty/Incubator/Codec/Quic 0.0.10.Final released

The new release of netty-incubator-codec-quic comes with a few small bug-fixes but most importantly with this release we started to also support linux-aarch64, which means you will not only be able to use the quic codec itself on linux-aarch64 but also our [http3 codec](https://github.com/netty/netty-incubator-codec-http3) that depends on it.

For more details about the included changes please check the [issue-tracker](https://github.com/netty/netty-incubator-codec-quic/milestone/9?closed=1)


## Netty/Incubator/Codec/Http3 0.0.3.Final released

As stated above you are now able to run the http3 codec on linux-aarch64 as well, but that's not all. This release also includes a few small bugfixes when it comes to handling CONNECT requests and push streams in general

For more details about the included changes please check the [issue-tracker](https://github.com/netty/netty-incubator-codec-http3/milestone/3?closed=1)

## Netty/Incubator/Native/Transport/IOUring 0.0.5.Final released

The new release of netty-incubator-transport-io_uring contains various interesting changes. First of we now use GCC10 when cross compile and so may be able to make use of LSE when you run on aarch64. Beside this release also add support for UDP_GSO to increase the performance when sending datagrams over the wire. 

For more details about the included changes please check the [issue-tracker](https://github.com/netty/netty-incubator-transport-io_uring/milestone/5?closed=1)


# Thank You

Every idea and bug-report counts and so we thought it is worth mentioning those who helped in this area.

Please report an unintended omission.
     
* [@chrisvest](https://github.com/chrisvest) 
* [@normanmaurer](https://github.com/normanmaurer)
