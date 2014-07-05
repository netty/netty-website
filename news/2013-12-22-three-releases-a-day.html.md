---
layout: news-item
title: 'Three releases a day: 5.0.0.Alpha1, 4.0.14, and 3.9.0'
author: trustin
---
Right before taking my two-week vacation, I decided to release three versions from three different branches for your fun and profit in the holiday season this year.  Please enjoy and make me happy thanks to the amount of bug reports and feature requests I'll see when I'm back. ;-)

### 5.0.0.Alpha1

This is our new attempt to clean up the overall design even more.  Fortunately, the changes are not really big thanks to the many changes we made in 4.x, and you might actually like it due to its simplicity.  I wrote a dedicated page for the list of the notable changes [here](http://netty.io/wiki/new-and-noteworthy-in-5.0.html).

### 4.0.14.Final

* Advanced leak tracking mechanism that enables you find where you leaked a buffer easily. Read [this article](http://netty.io/wiki/reference-counted-objects.html) for more information.
* SPDY/3.1 support
* Support for `charset` property in HTTP multipart request boundary
* [11 bug fixes](https://github.com/netty/netty/issues?milestone=77&state=closed)

### 3.9.0.Final

* Improved `SslHandler` performance (backported from 4.x)
* SPDY/3.1 support
* Faster `ChannelBuffers.EMPTY_BUFFER`
* Support for `charset` property in HTTP multipart request boundary (backported from 4.x)
* [a couple bug fixes](https://github.com/netty/netty/issues?milestone=74&state=closed)

