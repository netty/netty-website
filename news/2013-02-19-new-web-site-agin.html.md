---
layout: news-item
title: 'Announcing the new web site (again)'
author: trustin
---

Somebody might already know my history of rebuilding the web site [over](#{page.site_url}/news/2011/11/04/new-web-site.html) and [over again](#{page.site_url}/news/2012/06/25/new-web-site-and-3-5-1-final.html).  I hope this is the last time, at least until Github is superced by something else.

Previously, I was hosting 'netty.io' using [XWiki](http://www.xwiki.org/) on AWS EC2, RDS, and S3.  It was in general very satisfactory, but there were a couple things that needed to sort out:

* To run XWiki on EC2, I had to run a large instance which costed me quite a bit.
* It takes time and energy to manage and run a web application even if it is stable.

Although the WYSIWYG editing experice provided by XWiki was extraordinarily superb and it was one of the biggest reason we moved to XWiki, we didn't get as much documentation contribution as we wished.  Given the amount of contribution we got so far, I concluded that the cost of running a full web application doesn't worth enough.  I think this is not necessarily because of the technology we adopted but because of where we are at as a relatively small project.

Consequently, I rebuilt our web site using [Awestruct](http://awestruct.org/) again.  This time, it was much easier to build the web site because I was already familiar with Awestruct and thanks to great toolkits like [Twitter Bootstrap](http://twitter.github.com/bootstrap/) and [Font Awesome](http://fortawesome.github.com/Font-Awesome/).

Does this mean we went completely backward and our documentation is unmodifiable?  Not at all.  If you browse [the documentation page](#{page.site_url}/docs/index.html), you will find that all documentation pages are periodically auto-generated from [the Github Wiki](https://github.com/netty/netty/wiki).  You can just visit the wiki to submit your changes and they will be deployed automatically.  As usual, your contribution to our documentation will make us very excited, even if it is such a tiny thing as fixing typos and grammar.

I hope you like the new web site.  Please let us know what you think about it and what would make it better.

