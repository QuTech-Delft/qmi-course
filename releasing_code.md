---
title: "Releasing and versioning of QMI code"
output: html_document
teaching: 5
exercises: 0
---

::: questions
-   How is QMI code released?
-   What are the differences between different types of ways to obtain QMI?
:::

::: objectives
-   Understanding of ways and differences QMI code is released and can be obtained
:::

## Releasing, released packaged and stable branches/tags

Finally, a little bit about the releasing of QMI code. Every now and then, after some amount of issues have been approved and merged into main, a new *stable branch*, *tag*, *release* and a *package* are made. Why so many and what’s the difference? Well, let us explain.

A *stable branch* is created for each release new version-revision, like 0.49.0 (branch name *stable-0-49*). If for some reason, later on some user, who needs to using this release version, needs to fix a bug but not to upgrade version, the fix can be done based on the stable branch. Now, instead of branching off from the *main* branch, we branch off from the stable branch, and also merge back to it. A new *tag*, *release*, and *package* of the fix can be made with upgrading the version's patch number by one. In this case, the new versioning is 0.49.1. If the fix is relevant also for the *main* branch, it can be “cherry-picked” also there, but it might not be the case.

A *tag* is usually created together with a stable branch and possible patches to it. Our naming convention for tags is *v<Version>.<Revision>.<Patch>*, like *v0.49.0* if using the same example as above. The *tag* is a simple snapshot of the branch it is made in at that point in time. It is easy to check out to return to that point in time to check how the code was. It can also be used to revert the code to that version. But in comparison with *stable branch*, it cannot be used for branching off or merging to it, and no changes can be committed.

A *release* releases the source code as a Zip and a Gzipped Tar files. These can be downloaded and used to install the package for example with Pip locally. These are especially handy if no installable *package* is available.

A *package* is an installable [wheel or equal type of file](https://packaging.python.org/en/latest/tutorials/installing-packages/#source-distributions-vs-wheels), which can be used to install the software. QMI creates a new *package* every time a new *tag* is made, builds a *wheel* for it and uploads it to [QMI’s Pypi page](https://pypi.org/project/qmi/). From there QMI can be installed with simply using the `pip install qmi` command, or, if we want to install e.g. specifically version 0.49.1, `pip install qmi==0.49.1`.

::: keypoints
-   While main version-revision development happens through the *main* branch, also version-revision-specific development can be done through *stable branches*
-   User can also use *tags* as references to code at certain point of time
-   The usual way to install QMI is using Pip and a Pypi *package* of QMI. But, also *releases* can be downloaded and used for the installation.
:::
