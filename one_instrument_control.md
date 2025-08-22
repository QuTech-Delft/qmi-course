---
title: "Controlling an instrument"
output: html_document
teaching: 5
exercises: 10
---

::: questions
-   How do I control an instrument?
:::

::: objectives
-   Add an instrument into a QMI context and control it with RPC commands
:::

## Using QMI to control one instrument

In this example we show how to create an instrument object in a context. For this, we have a dummy instrument in the QMI instruments to illustrate. See also the QMI readthedocs documentation about the dummy instrument class call interface. Let’s import the device driver.

``` python
from qmi.instruments.dummy.noisy_sine_generator import NoisySineGenerator
```

So we imported the QMI device driver class called `NoisySineGenerator` from QMI instrument “manufacturer” `dummy` and device `noisy_sine_generator` module. To use this, we start a new QMI context and “make” an instrument object from the device driver.

``` python
qmi.start("nsg_demo", None)
nsg = qmi.make_instrument("nsg", NoisySineGenerator)
```

::: instructor
View that class "docstring" with

``` python
help(nsg)
```
:::

Now we have an instrument object `nsg` present in Python. The instrument is also added into the context. This can be checked with:

``` python
qmi.show_instruments()
```

``` output
address       type
------------  ------------------
nsg_demo.nsg  NoisySineGenerator
------------  ------------------
```

The address “nsg_demo.nsg” means that now there is an instrument object “nsg” present in context “nsg_demo”. The type confirms the instrument object is of expected class type. Alternative way to confirm this is simply to type the object in Python.

``` python
nsg
```

``` output
<rpc proxy for nsg_demo.nsg (qmi.instruments.dummy.noisy_sine_generator.NoisySineGenerator)>
```

As can be seen, the created object is actually an RPC proxy of the actual instrument object. This has a couple of consequences: The first is that the proxy object can be now shared through the context with other contexts, allowing remote control of the instrument. The second is that the proxy object does not have the full class interface of the device driver, but only the variables that are present in QMI proxy class and functions that have been selected to be RPC callable. We can list the variables of the object with

``` python
vars(nsg)
```

It gives out the whole variable dictionary in a one long string, which is a bit difficult to read. We can try to make it a bit more readable by doing:

``` python
[print(k, v, "\n") for k, v in vars(nsg).items()]
```

Here are useful information, like the `__doc__` which is the documentation string of the class object. Then all entries listed as “bound method” are the callable RPC functions of the object. If you compare this with the readthedocs documentation of the class API, you notice that a few methods like `get_category` and `release_rpc_object` are not present. These methods are not useful for the user, so they are also not available in the proxy. The double underscores in `__enter__` and `__exit__` also indicate that user should not call these directly, even if they are available. Those are used for the instrument context control. A bit shorter listing of the attributes of the object, you can use

``` python
dir(nsg)
```

Anyhow, in the printed out list, a lot of useful methods are present and supported through the proxy. Let’s try one:

``` python
nsg.get_sample()
```

``` output
96.18801232566346
```

So we get returned one sample of the sine wave at a random moment. Let’s do for demonstration purpose a little for loop print out the sine wave of our generator “instrument”:

``` python
import time
for i in range(1000):
    print(" " * int(40.0 + 0.25 * nsg.get_sample()) + "*")
    time.sleep(0.01)
```

Nice huh? Let’s then close this context with `qmi.stop()` and exit Python with `exit()`and prepare for next example.

::: keypoints
-   Instruments can be added into contexts with `<instrument_object> = qmi.make_instrument("<name>", <ClassName>, <possible_extra_parameters>)`
-   Instrument class description can be seen with `help(<instrument_object>)`
-   Detailed information about the object and available variables and RPC methods can be obtained with `vars(<instrument_object>)` and `dir(<instrument_object>)`
-   The returned instrument object is an RPC *proxy* object of the actual class object
:::
