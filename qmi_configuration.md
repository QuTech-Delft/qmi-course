---
title: "Configuring and logging"
output: html_document
teaching: 5
exercises: 5
editor_options: 
  markdown: 
    wrap: 120
---

::: questions
-   What are QMI configuration and log files?
:::

::: objectives
-   Know how to create a basic configuration file.
:::

## QMI Configuration and log file

Many aspects of QMI are configurable via a *configuration file*. The syntax of this file is very similar to
[JSON](https://www.json.org/), but unlike JSON, the configuration file may contain comments starting with a \#
character. By default, QMI attempts to read the configuration from a file named `qmi.conf` in the home directory (i.e.
‘/home/<user_profile>’ in Linux or ‘C:\\Users\\\<user_name\>’ folder on Windows). If you want to use a different file
name or location, you can specify the configuration file path with the `config_file=` argument of `qmi.start()` or in the
environment variable `QMI_CONFIG`. Let’s create a configuration file `qmi.conf` at the course directory with the
following contents:

``` json
{
    # Log level for messages to the console.
    "logging": {
        "console_loglevel": "INFO"
        # "logfile": "log.log"
    }
    # Directory to write main log file.
    # "log_dir": "~/qmi_course/log"
}
```

This configuration file changes the log level for messages that appear on your terminal. By default, QMI prints only
warnings and error messages. Our new configuration also enables printing of informational messages. For further details
about logging options, see documentation on
[qmi.core.logging_init](https://qmi.readthedocs.io/en/latest/build/qmi.core.logging_init.html#module-qmi.core.logging_init)
module. Test the new configuration file in a new Python session:

``` python
import qmi
qmi.start("hello_world", config_file="qmi.conf")
qmi.stop()
```

If the configuration file is found and written correctly, QMI should print
a bunch of log messages on the terminal after the call to start. If you don't see any output, you might
have to give full path location for the `config_file=` argument to, or try setting the `QMI_CONFIG`
environment variable with:

``` shell
export QMI_CONFIG=`pwd`/qmi.conf
```

Or in powershell

``` powershell
$Env:QMI_CONFIG = Join-Path $pwd "\qmi.conf"
```

At your *home* directory should also now be a file called `qmi.log`. The file works as a log for QMI programs. You will
find in this file a log of actions you took until now while testing your first examples. The logging can be disabled by
giving input parameter `init_logging=False` for `qmi.start()`. We will add more settings to the configuration file as we
progress through this tutorial.

::: Challenge
Let’s try the different options to change the QMI log file name and logging location. Try, for example, uncommenting the
"logfile" and "log_dir" options in your `qmi.conf` file. Then run again the test in Python and see if the location and
file name of the log file did change. Note that JSON is very picky about the use of commas. There must be a comma
between multiple elements in the same group, but there may not be a comma after the last element of a group.

You can also try commenting out these lines again and to use the `QMI_HOME` environment variable by setting it with:

``` shell
export QMI_HOME=`pwd`
```
:::

::: keypoints
-   `qmi.conf` has a JSON-like structure, but allows comments starting with '\#'
-   `qmi.conf` location can be given as an argument to `qmi.start` by setting `QMI_CONFIG` environment variable
-   Log levels are set within "logging" keyword section
-   Default name and location of the log file are `qmi.log` and the user's home directory
-   These can be changed using "logfile" and "log_dir" options in `qmi.conf`, but also by setting `QMI_HOME` environment
    variable.
:::
