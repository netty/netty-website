---
layout: news-item
title: 'Release day!'
author: normanmaurer
---

I'm happy to announce the release of Netty 4.0.19.Final, 3.9.1.Final, 3.8.2.Final, 3.7.1.Final and 3.6.9.Final. Beside providing you with various new features and bugfixes all of these releases have one in common; they fix a resource usage problem in the `WebSocket08FrameDecoder`. 

Before we aggregated the full text in the WebSocket08FrameDecoder just to fill in the ContinuationWebSocketFrame.aggregatedText(). The problem was that there was no upper-limit and so it would be possible to see an OOME if the remote peer sends a TextWebSocketFrame + a never ending stream of ContinuationWebSocketFrames. The aggregation of WebSocketFrames can be done with the WebSocketFrameAggregator, which allows to set an upper limit.
Because there was no other "sane" way to fix the problem we decided to also remove the ContinuationWebSocketFrame.aggregatedText() method, even in a bugfix release because just changing its behaviour would even be more confusing. We never saw a usage of this method in the wild so far, so we hope
this will not affect many users.

So if you using the stock WebSockets codec provided by Netty you should update ASAP! Special thanks to [James Roper](https://github.com/jroper) ([Typesafe](http://www.typesafe.com)) for finding the flaw and notify us in a timely manner. 

For more details on the fixes for these various releases please see the following sections.

## Netty 4.0.19.Final 

### Most important changes / fixes
* Fix a resource usage problem in the WebSocket08FrameDecoder
* Not cause busy loop when interrupt Thread of NioEventLoop 
* Various fixed in the native transport
* Support for TCP_REUSEPORT in the native transport
* Add Datagram support in native transport
* Improve release of unused memory out of the buffer pool cache


Visit [here](https://github.com/netty/netty/issues?milestone=88&page=1&state=closed) for the complete list of the changes and all the details.

As always please let us know if you find any issues. We love feedback!

## Netty 3.9.1.Final 

### Most important changes / fixes
* Fix a resource usage problem in the WebSocket08FrameDecoder
* Various SSL fixes
* SPDY improvements

Visit [here](https://github.com/netty/netty/issues?milestone=81&page=1&state=closed) for the complete list of the changes and all the details.

## Netty 3.8.2.Final 

### Most important changes / fixes
* Fix a resource usage problem in the WebSocket08FrameDecoder
* Various SSL fixes

Visit [here](https://github.com/netty/netty/issues?milestone=93&page=1&state=closed) for the complete list of the changes and all the details.

## Netty 3.7.1.Final 

### Most important changes / fixes
* Fix a resource usage problem in the WebSocket08FrameDecoder
* Various SSL fixes

Visit [here](https://github.com/netty/netty/issues?milestone=94&state=closed) for the complete list of the changes and all the details.

## Netty 3.6.9.Final 

### Most important changes / fixes
* Fix a resource usage problem in the WebSocket08FrameDecoder

Visit [here](https://github.com/netty/netty/issues?milestone=89&state=closed) for the complete list of the changes and all the details.



As always please let us know if you find any issues. We love feedback!






