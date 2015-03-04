---
layout: news-item
title: 'Three releases a day: 5.0.0.Alpha2, 4.1.0.Beta4, and 4.0.26.Final'
author: normanmaurer
---
After a long time we finally release netty 5.0.0.Alpha2 , 4.1.0.Beta4 and 4.0.26.Final. These releases include a ton of fixes, improvements and new features.

As always, feedback welcome!

### 5.0.0.Alpha2

After more then a year we released another alpha version of netty 5.0.0 which includes 170 fixes issues / tasks. For a complete list of changes please check the [Bugtracker](https://github.com/netty/netty/issues?q=milestone%3A5.0.0.Alpha2).

### 4.1.0.Beta4

Due the high-interest in using http/2 with netty we decided to backport our http/2 support to 4.1.0 and released it as part of 4.1.0.Beta4.
For more details see [#3339](https://github.com/netty/netty/pull/3339).  The release also includes support for UNIX Domain Sockets as stated in [#3344](https://github.com/netty/netty/pull/3344) and [#3345](https://github.com/netty/netty/pull/3345).

For a complete list of all of the 44 fixes please check the [Bugtracker](https://github.com/netty/netty/milestones/4.1.0.Beta4).

### 4.0.26.Final

A new version out of the 4.0 branch was released which fixes almost 70 issues / tasks. These include bug-fixes, performance improvements and new features.

One of bigger new features is support for UNIX Domain Sockets when using the native epoll transport. For more details please see [#3344](https://github.com/netty/netty/pull/3344) and  [#3345](https://github.com/netty/netty/pull/3345).

For a complete list please check the [Bugtracker](https://github.com/netty/netty/issues?q=milestone%3A4.0.26.Final).
