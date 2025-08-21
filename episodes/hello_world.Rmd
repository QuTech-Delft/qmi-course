---
title: "hello_world"
output: html_document
---

::: questions
-   How are the QMI contexts created?
:::

::: objectives
-   Create a simple QMI context
:::

## “Hello world” context creation

Start up python

``` shell
python
```

We are now in an interactive Python shell. Let’s start with importing QMI.

``` python
import qmi
```

Presuming you had just installed QMI with Pip, this should just work without any issues. Let’s continue to creating a simple context called “hello_world”.

``` python
qmi.start("hello_world", config_file=None)
```

Now, your first QMI context has been started. You can verify this with

``` python
qmi.context()
```

``` output
QMI_context(name='hello_world')
```

::: instructor
Also a nice info to view now is
```python
qmi.info()
```
:::


A couple of remarks are in place already here. The context name is with underscore (\_) as spaces in the context names cause issues. So, avoid those and also special letters like ‘!’, ‘\@’, ‘#’, ‘\$’ etc. We also gave a second input parameter `config_file=None` for the call. This was actually optional as the default value for the parameter is `None`, but we wanted to illustrate with this that we start a context without specifying a QMI configuration file. In that case, QMI will create a simple configuration for the context. Now just let’s stop the “hello_world” context.

``` python
qmi.stop()
```

We can confirm that the context has been stopped

``` python
qmi.info()
```

``` output
'*** No active QMI context ***'
```

And trying to a command like `qmi.context()` now will give an exception. Note that it is important always to stop your contexts. Python does not always manage to clean up the QMI contexts properly, especially when the context has plenty of things going on, if the context is not manually stopped before. This can leave bogus QMI contexts running on your system with e.g. some kind of task or instrument control active.

::: keypoints
-   A QMI context is created using `qmi.start("<context_name>")` call
-   Always remember to stop the context with `qmi.stop()`
:::
