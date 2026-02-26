---
title: Setup
---

## Software Setup

:::::: discussion
### Details

-   Requirements:
-   Python 3.11+ with Pip, setuptools packages [Download Python \| Python.org](https://www.python.org/downloads/)
-   Bash-like environment for command-line

::: spoiler
### Windows

[Git for Windows](https://gitforwindows.org/). Command Prompt/Powershell might be OK as well.
:::

::: spoiler
### MacOS

Use Terminal.app
:::

::: spoiler
### Linux

Use Terminal
:::
::::::

-   Make a folder for the exercises

``` shell
mkdir qmi_course
cd qmi_course
```

-   Make a virtual environment for running exercises

``` shell
python -m venv venv
# Linux / MacOS Terminal
source venv/bin/activate
# Git bash on Windows
source venv/Scripts/activate
# Powershell, with possibly requred step to enable running scripts
set-executionpolicy RemoteSigned -Scope CurrentUser
.\venv\Scripts\Activate.ps1
```

-   Install open-source QMI with Pip

``` shell
pip install qmi
```

-   Handy to have: IDE software, like [PyCharm](https://www.jetbrains.com/pycharm/).
