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

Install [Git for Windows](https://gitforwindows.org/) and use the installed "Git Bash" terminal program. Command Prompt/Powershell might be OK as well.

Note that since recently, Windows installation of Python might not automatically create alias "python[.exe]" for executing Python. Windows should in any case install Python launcher executable called "py" in any case. If you cannot run commands with "python", use "py" instead, or resolve the issue following [these tips](https://docs.python.org/3/using/windows.html#pymanager-troubleshoot).
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

-   Make a folder for the exercises. For the examples in this course this is expected to be at the user's home directory ("/home/\<username\>/" or "C:\\Users\\\<username\>\\")

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
# Powershell, with possibly required step to enable running scripts
set-executionpolicy RemoteSigned -Scope CurrentUser
.\venv\Scripts\Activate.ps1
```

-   Install open-source QMI with Pip

``` shell
pip install qmi
```

-   Handy to have: IDE software, like [PyCharm](https://www.jetbrains.com/pycharm/).
