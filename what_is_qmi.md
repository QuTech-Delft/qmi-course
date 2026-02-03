---
title: "What is QMI?"
output: html_document
teaching: 10
exercises: 0
---

::: questions
-   What is QMI?
:::

::: objectives
-   Explain what is QMI and its main features
:::

## What is QMI?

**QMI**, **Q**uantum **M**easurement **I**nfrastructure, is a Python 3 framework for controlling laboratory equipment. It is suitable for anything ranging from one-off scientific experiments to robust operational setups.

QMI is developed by [QuTech](https://www.qutech.nl/) to support advanced physics experiments involving quantum bits. However, other than its name and original purpose, the_re is nothing specifically *quantum* about QMI — it is potentially useful in any environment where monitoring and control of measurement equipment is needed. It is also multi-platform. At QuTech, QMI is regularly used in both Linux and Windows, and running QMI on macOS is also possible.

It supports *instruments* and *devices* that encapsulate equipment under computer control. A number of instruments are provided out of the box, and it is relatively easy to add your own. QMI makes use of *tasks* that can encapsulate a (background) process that needs to run temporarily or indefinitely. It offers *network transparency*; instruments and tasks can be remotely started, stopped, monitored and controlled. With these features it can be used as basis for monitoring and control of complicated setups, distributed over multiple locations.

# Main Features

## Device drivers

With device drivers instruments and devices can be controlled. Device drivers are importable classes in QMI with (a selection of) functions with which the device can be controlled and monitored. QMI has currently device drivers for 45 manufacturers and 80 devices. In the picture below you can see most of the supported instruments in QMI.

![Montage of QMI drivers manufacturer and devices](fig/montage.png)

## Remote Procedure Calls

The second main feature of QMI is its Remote Procedure Call (RPC) protocol that enables communication between computers in the same network.

## QMI signals

The third main feature to mention is the QMI signals. The device drivers and tasks can be equipped with signal publishers and receivers. These can be used e.g. to send simple triggering signals between tasks or devices, or to send data to some external party. They can become handy with tasks that need to wait for some event to occur before performing some specific action, and thus wait to receive a signal from a publisher. Or if some data needs to be (periodically) saved to a database, like [InfluxDB](https://www.influxdata.com/) or our own [QuTech Data Lake](https://qutech-data-lake.gitlab.io/docs/latest/), for later analysis. The signals have been also used for remote live monitoring by sending data to a [Grafana](https://grafana.com/docs/grafana/latest/) server.

## QMI contexts

When starting QMI in a Python program, a QMI *context* is started. While the program is running, this context contains all information about the device drivers and tasks added in the context in the program. Another main feature of QMI is that these contexts are also approachable from another QMI context, and the instruments and tasks in the context can be controlled through another context, see Figure 1. The three contexts in Figure 1 could reside in three different PCs and communicate with each other with the help of the RPC protocol and QMI *signals*. The user only needs to setup QMI configuration files for these contexts, where information about other contexts are present. That way the contexts know where to look for other contexts. It is possible to also look for contexts not defined in the configuration files, but more about that later.

![Figure 1: An example of three QMI contexts where two instrument device drivers are added to QMI context 1. Then we have context 2, that runs a task, which is configured to make connection to context one, and to control the instruments in it. This second contexts now sends also out settings and status signals which can e.g. be forwarder to a database. A third context monitors the task status in context two and instrument status in context one. This context is hooked in the status signal and at specific signal values or circumstances could either tell context two to change settings or stop task, or send specific commands to the instruments in context one.](fig/qmi_contexts.png)

::: instructor
Advantages of this are that instruments can be grouped in logical groups in separate contexts and there is therefore no need to make one big program that contains all the instruments, tasks and whatever logic or timing is necessary. The programs can that way be made modular, with easy addition or removal of contexts.
:::

::: keypoints
-   Device drivers: With device drivers instruments and devices can be controlled
-   QMI contexts: A QMI context envelops instruments, tasks and other RPC objects and can be connected to from outside from another QMI context
-   Remote Procedure Calls: Custom RPC are used to control objects in QMI contexts
-   QMI signals: QMI context objects can also broadcast and receive signals, which can include e.g. data
:::
