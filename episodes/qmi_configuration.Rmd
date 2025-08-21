---
title: "qmi_configuration"
output: html_document
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
‘/home/<user_profile>’ in Linux or ‘C:\Users\Users\<user_name\>’ folder on Windows). If you want to use a different file
name or location, you can specify the configuration file path either as the second argument of `qmi.start()` or in the
environment variable `QMI_CONFIG`. Let’s create a configuration file `qmi.conf` at home directory with the following
contents:

``` json
{
    # Log level for messages to the console.
    "logging": {
        "console_loglevel": "INFO"
    }
}
```

This configuration file changes the log level for messages that appear on the screen. By default, QMI prints only
warnings and error messages. Our new configuration also enables printing of informational messages. For further details
about logging options, see documentation on
[qmi.core.logging_init](https://qmi.readthedocs.io/en/latest/build/qmi.core.logging_init.html#module-qmi.core.logging_init)
module. Test the new configuration file in a new Python session:

``` python
import qmi
qmi.start("hello_world")
qmi.stop()
```

Notice that we do not pass a 'None' as the second argument to `qmi.start()`. As a result, QMI will try to read the
configuration file from its default location. If the configuration file is working correctly, QMI should print a bunch
of log messages after the call to `qmi.start()`. If your configuration file is not in the default location, you may have
to specify its location as the second argument to `qmi.start()`. At your home directory should also now be a file called
`qmi.log`. The file works as a log for QMI programs. You will find in this file a log of actions you took until now
while testing your first examples. The logging can be disabled by giving input parameter `init_logging=False` for
`qmi.start()`. We will add more settings to the configuration file as we progress through this tutorial.

::: keypoints
-   `qmi.conf` has a JSON-like structure
-   Log levels are set within "logging" keyword section
-   Default name and location of the log file are `qmi.log` and the user's home directory
:::
