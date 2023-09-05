---
layout: news-item
title: 'Netty/Incubator/Codec/Quic 0.0.50.Final and Netty/Incubator/Codec/HTTP3 0.0.20.Final released'
author: normanmaurer
---

We are happy to announce the release of netty-incubator-codec-quic 0.0.50.Final and netty-incubator-codec-http3 0.0.20.Final.

The most important changes for the quic codec are:

* Correctly handle optional client auth on the client([#567](https://github.com/netty/netty-incubator-codec-quic/pull/567))
* Update to netty 4.1.97.Final ([#569](https://github.com/netty/netty-incubator-codec-quic/pull/569))
* Update to quiche 0.18.0 ([#571](https://github.com/netty/netty-incubator-codec-quic/pull/571))

For more details related to this release see our [bug-tracker](https://github.com/netty/netty-incubator-codec-quic/issues?q=is%3Aclosed+milestone%3A0.0.50.Final). 

The most important changes for the http3 codec are:


* Correctly handle optional client auth on the client([#236](hhttps://github.com/netty/netty-incubator-codec-http3/pull/236))
* Upgrade to latest quic release ([73196d01cd5644ba0517ce9cfa8a5f586f95af5c](https://github.com/netty/netty-incubator-codec-http3/commit/73196d01cd5644ba0517ce9cfa8a5f586f95af5c))
* Upgrade to netty 4.1.97.Final  ([#237](https://github.com/netty/netty-incubator-codec-http3/pull/237))

For more details related to this release see our [bug-tracker](https://github.com/netty/netty-incubator-codec-http3/issues?q=is%3Aclosed+milestone%3A0.0.20.Final). 
