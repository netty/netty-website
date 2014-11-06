---
layout: news-item
title: 'Netty adopts the modified Semantic Versioning'
author: trustin
---

As you might already have been following [the discussion](https://groups.google.com/forum/#!topic/netty/wZz6BvAqwxc) about adopting [Semantic Versioning](http://semver.org/) in [our discussion group](https://groups.google.com/forum/#!forum/netty), we are adopting the slightly modified Semantic Versioning for all the subsequent releases as of today.

#### What does this really mean?

* No more `.Final` in non-prelease versions. e.g. 4.0.9.Final becomes 4.0.9.  Besides that, version naming rule doesn't change. e.g. 5.0.0.Alpha1 remains unchanged.
* The micro version number (a.k.a. patch number) is increased only when [the binary compatibility](http://docs.oracle.com/javase/specs/jls/se7/html/jls-13.html) (or see [here](http://stackoverflow.com/questions/14973380/what-is-binary-compatibility)) is preserved.
  * This is different from the original Semantic Versioning, which prohibits introducing binary-compatible improvements (i.e. non-bug-fixes) and deprecating the public API.  We are going to introduce reasonably simple yet binary-compatible improvements and to mark the pooly designed API as deprecated when we increase the micro version number.
* The minor version number is increased when new yet backward-compatible functionality is introduced to the public API.  It is not necessarily binary-compatible.  It is usually source-compatible, but you might need to modify your code if you extended the public API (e.g. implementing your own transport.)
* The major version number is increased when the source compatibility is broken even if you did not extend the public API.  It usually means the removal of some features or the rewrites of some or all portions of the public API.
* We obviously don't care about the source or binary compatibility of non-public API, such as the classes in `io.netty.util.internal` and package-private classes and methods.

#### Why do we adopt this changes?

It's because we do not want to surprise anyone who depends on Netty.  In theory, this change should allow you to replace the old Netty JAR with the newer version without recompiling your code at all in most cases.  Also, we do not plan to push non-trivial changes when we bump the micro version number, so it is likely that you'll see less regression than before.

#### Why do we adopt the 'modified' version of the Semantic Versioning?

As to version format, we decided to be OSGi-compatible.  The version format in Semantic Versioning 2.0.0 doesn't conform to OSGi version format.

Although it might be controversial, we believe it is sometimes beneficial to include relatively simple improvements in a micro version bump.  Also, deprecation doesn't really break the binary compatibility, and thus it sounded better for us to give the earliest signal to a user.

#### How will you ensure the binary compatibility between releases?

We are going to integrate the automated binary compatibility checker into our build so that [our CI server](http://clinker.netty.io/jenkins/) warns us whenever we break the binary compatibility.  It is not implemented in our `pom.xml` yet, so you might want to contribute some by [issuing a pull request](https://github.com/netty/netty/pulls) if you have an experience in this area.
