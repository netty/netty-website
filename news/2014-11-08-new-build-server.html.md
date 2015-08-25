---
layout: news-item
title: 'New build server, powered by Clinker'
author: trustin
---

About a week ago, we experienced the outage of our CI server.  It was a dedicated hosting server maintained by myself, which as well costed me about $80/month.

Fortunately, [Twitter, Inc.](https://engineering.twitter.com/) was very generous to cover its hosting cost for 12 months, which has been great relief for me.

However, maintaining a server always takes energy; making sure the system up-to-date and fully operational often require manual intervention.  We tried to switch to other CI-as-a-service providers, but our build didn't fit very well into them, mainly because of the following issues:

* Our tests sometimes take a lot of RAM, and the build process was often OOM-killed by the container.
* Some of our tests are CPU intensive, and they take long time when the CPU is not powerful enough.
* We find having a dedicated instance often increases the chance of discovering tricky concurrency issues, although it might be just an anecdotal observation.

Today, I'm very happy to announce that [Clinker](http://clinkerhq.com/) donated their server instance to us and that it simply solved most of our CI issues.  It took only about a couple days to migrate our build jobs, thanks to their exceptional support.

After a little bit of exploration, I also realized Clinker is more than just a CI server.  It provides:

* [SonarQube](http://www.sonarqube.org/) for publishing our static analysis reports, including:
  * [PMD](http://pmd.sourceforge.net/)
  * [FindBugs](http://findbugs.sourceforge.net/)
  * [Checkstyle](http://checkstyle.sourceforge.net/)
  * [JaCoCo](http://www.eclemma.org/jacoco/)
* [Nexus](http://www.sonatype.org/nexus/) for deployment of our snapshot artifacts
* Almost infinite customizability of our Jenkins instance

Especially, the daily Sonar report provides very useful information that could raise our quality bar even higher.  Please take your time to browse it, you'll find many low-hanging fruits that could be translated into a new pull request fairly easily.

I'd like to say huge thanks to the folks at Clinker again for their support for Netty.  They certainly addressed our biggest pain point.
