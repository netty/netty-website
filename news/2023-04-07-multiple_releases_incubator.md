---
layout: news-item
title: 'Multiple incubator libraries released'
author: normanmaurer
---

I am happy to announce the release of a new version of all our incubator libraries.


The releases include:

 * [netty-incubator-transport-io_uring 0.0.21.Final](https://github.com/netty/netty-incubator-transport-io_uring/milestone/21?closed=1)
 * [netty-incubator-codec-quic 0.0.40.Final](https://github.com/netty/netty-incubator-codec-quic/milestone/38?closed=1)
 * [netty-incubator-codec-http3 0.0.18.Final](https://github.com/netty/netty-incubator-codec-http3/milestone/16?closed=1)

# Important changes:

For more details please check the specific issue tracker for the libraries as listed above.

## netty-incubator-transport-io_uring 0.0.17.Final

 * Upgrade netty and netty-tcnative to latest releases  ([#203](https://github.com/netty/netty-incubator-transport-io_uring/pull/203))


## netty-incubator-codec-http3 0.0.18.Final

  * Ensure FIN will only sent after all data was written ([#222](https://github.com/netty/netty-incubator-codec-http3/pull/222))
  * Don't set a default MAX_HEADER_LIST_SIZE ([#221](https://github.com/netty/netty-incubator-codec-http3/pull/221))
  * Disable dynamic qpack table by default ([#223](https://github.com/netty/netty-incubator-codec-http3/pull/223))


## netty-incubator-codec-quic 0.0.36.Final

 * Upgrade to latest quiche sha ([#502](https://github.com/netty/netty-incubator-codec-quic/pull/502))
 * Upgrade to netty 4.1.92.Final ([#501](https://github.com/netty/netty-incubator-codec-quic/pull/501))


