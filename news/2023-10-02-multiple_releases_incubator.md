---
layout: news-item
title: 'Multiple incubator libraries released'
author: normanmaurer
---

I am happy to announce the release of a new version of all our incubator libraries. This includes releases for io_uring support, http3 and quic. Please consider upgrading if you use any of these.


The releases include:

 * [netty-incubator-transport-io_uring 0.0.23.Final](https://github.com/netty/netty-incubator-transport-io_uring/milestone/23?closed=1)
 * [netty-incubator-codec-http3 0.0.21.Final](https://github.com/netty/netty-incubator-codec-http3/milestone/19?closed=1)
 * [netty-incubator-codec-quic 0.0.51.Final](https://github.com/netty/netty-incubator-codec-quic/milestone/49?closed=1)

# Important changes:

For more details please check the specific issue tracker for the libraries as listed above.

## netty-incubator-transport-io_uring 0.0.23.Final

 * Update to latest netty version ([#219](https://github.com/netty/netty-incubator-transport-io_uring/pull/219))
 * Use '-Xcheck:jni' during testsuite run to detect JNI bugs ([#218](https://github.com/netty/netty-incubator-transport-io_uring/pull/218))

## netty-incubator-codec-http3 0.0.21.Final

  * Change API of Http3RequestStreamInboundHandler to better handle FIN ([#240](https://github.com/netty/netty-incubator-codec-http3/pull/240))
  * Upgrade to latest netty release ([#244](https://github.com/netty/netty-incubator-codec-http3/pull/244))
  * Upgrade to netty-incubator-codec-quic 0.0.51.Final ([#246](https://github.com/netty/netty-incubator-codec-http3/pull/246))


## netty-incubator-codec-quic 0.0.51.Final

 * Update to latest boringssl chromium-stable commit ([#570](https://github.com/netty/netty-incubator-codec-quic/pull/570))
 * Fixed Android connection not working ([#577](https://github.com/netty/netty-incubator-codec-quic/pull/577))
 * Fix bug related to memoryAddress access when unsafe is not accessible and Datagram extension is used ([#579](https://github.com/netty/netty-incubator-codec-quic/pull/579))
 * Ensure we always delete the local reference used to access the weak reference ([#587](https://github.com/netty/netty-incubator-codec-quic/pull/587))
 * Do not try to delete a global handle with the local handles APIs ([#588](https://github.com/netty/netty-incubator-codec-quic/pull/588))
 * Use '-Xcheck:jni' during testsuite run to detect JNI bugs ([#589](https://github.com/netty/netty-incubator-codec-quic/pull/589))
 * Upgrade to netty 4.1.99.Final ([#590](https://github.com/netty/netty-incubator-codec-quic/pull/590))

