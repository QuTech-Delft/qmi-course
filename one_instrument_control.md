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
help(nsg)
```

It prints out the class docstring, a listing of its callable RPC methods, signals and class constants.

Here are useful information, like the docstring which is the documentation string of the class object. Then all entries listed as “RPC methods” are the callable RPC functions of the object, with their expected input parameters and return value type. A few methods related to the proxy locking (`lock`, `unlock`, `is_locked` and `force unlock` are not present, though. We also won't handle these methods in the course, but you can have a look at the [tutorial](https://qmi.readthedocs.io/en/latest/tutorial.html#locking-an-instrument). You see also empty listings "signals" and "constants", but for this instrument class there are none present.

::: instructor
A bit shorter listing of the attributes of the object, you can use

``` python
dir(nsg)
```

but it is not easy to read and has also internal and non-RPC variable and callable methods present.

You can also get "help" of any method present. Try:

``` python
help(nsg.get_sample)
```
:::

Anyhow, in the printed out listing, a lot of useful methods are present and supported through the proxy. Let’s try one:

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
-   Detailed information about the object and variables can be obtained with `dir(<instrument_object>)`
-   The returned instrument object is an RPC *proxy* object of the actual class object
:::
