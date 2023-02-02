---
layout: news-item
title: 'Multiple incubator libraries released'
author: normanmaurer
---

I am happy to announce the release of a new version of all our incubator libraries.


The releases include:

 * [netty-incubator-transport-io_uring 0.0.17.Final](https://github.com/netty/netty-incubator-transport-io_uring/milestone/18?closed=1)
 * [netty-incubator-codec-quic 0.0.36.Final](https://github.com/netty/netty-incubator-codec-quic/milestone/34?closed=1)
 * [netty-incubator-codec-http3 0.0.16.Final](https://github.com/netty/netty-incubator-codec-http3/milestone/14?closed=1)
 * [netty-incubator-bom 0.0.6.Final](https://github.com/netty/netty-incubator-bom/milestone/2?closed=1)

# Important changes:

For more details please check the specific issue tracker for the libraries as listed above.

## netty-incubator-transport-io_uring 0.0.17.Final

 * Replace stdlib write/read with send/recv ([#188](https://github.com/netty/netty-incubator-transport-io_uring/pull/188))
 * Correctly handle nextHdr() so we not return null to early ([#184](https://github.com/netty/netty-incubator-transport-io_uring/pull/184))
 * Correctly handle unresolvable InetSocketAddress when using IOUringDatagramChannel ([#185](https://github.com/netty/netty-incubator-transport-io_uring/pull/185))
 * Add support for client / server side TCP_FAST_OPEN ([#183](https://github.com/netty/netty-incubator-transport-io_uring/pull/183))
 * Upgrade to latest netty and netty-tcnative versions ([#182](https://github.com/netty/netty-incubator-transport-io_uring/pull/182))


## netty-incubator-codec-http3 0.0.16.Final

  * Upgrade netty and netty quic ([#210](https://github.com/netty/netty-incubator-codec-http3/pull/210))
  * Complete write promise in Http3FrameToHttpObjectCodec ([#211](https://github.com/netty/netty-incubator-codec-http3/pull/211))
  * Fix Host->:authority translation when URI is in origin-form ([#213](https://github.com/netty/netty-incubator-codec-http3/pull/213))


## netty-incubator-codec-quic 0.0.36.Final

 * Ensure we produce and send window update frames all the times when data is read by stream ([#471](https://github.com/netty/netty-incubator-codec-quic/pull/471))
 * Upgrade to netty 4.1.87.Final ([#466](https://github.com/netty/netty-incubator-codec-quic/pull/466))

## netty-incubator-bom-0.0.6.Final
 * Update to latest incubator releases ([#3](https://github.com/netty/netty-incubator-bom/pull/3))


