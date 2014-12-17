---
layout: news-item
title: 'Changes in deprecation policy'
author: trustin
---
As we mentioned in [today's release announcement](3-9-6-Final-and-3-10-0-Final.html), **we decided to remove the deprecated members and classes on a minor version bump** rather than on a major version bump. By performing minor version bumps and removing the deprecated entities more often, we hope to move as fast as wished without worrying about maintenance pain.

Why?

**We want to keep our code clean while we move fast.** When moving fast, we find we made mistakes in the past and we deprecate the members and classes that do not make sense anymore. Even if they were deprecated, they still remain in our API and they pollute our Javadoc and your IDE's auto-completion list.

**We want to minimize the difficulties of merging changes.** We currently maintain 3 major versions - 3, 4, and 5. When we make a change in one branch, we have to port it to the other two. When we are lucky, it merges cleanly. When we have deprecated entities in the old branch, it is more likely that we will fall into unpleasant conflicts.

However, this means we will break the backward compatibility on a minor version bump. To minimize the cost of migration, we will release two versions:

* the maintenance version with the deprecated members and classes, and
* the new version with minor updates plus the removal of the deprecated members and classes.

To avoid any issues during upgrade, you'll have to build your project against the maintenance version first, fix all deprecation warnings your compiler reports, and then upgrade to the new version.

Thank you for your understanding, and we hope it turns out to be trivial to remove the references to the deprecated entities on your side.

