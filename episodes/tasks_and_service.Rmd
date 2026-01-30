---
title: "Create a task and a 'service'"
output: html_document
teaching: 10
exercises: 20
---

::: questions
-   What are tasks and what can they do?
-   Can I run a task as a (background) 'service' process?
:::

::: objectives
-   Learn how to create tasks with (customized) task runners
-   Learn how to make a background 'service' process with `qmi_proc`
:::

## Setting up a task and a “service”

Next, we want to demonstrate QMI tasks and how they can be used in setting up services, i.e. tasks running as background processes, on your PC. This needs now somewhat more complex configuration of the `qmi.conf`, but nothing scary, I promise.

### Configuration file

The new configuration will have an extension for the background process:

```         
{
    # Log level for messages to the console.
    "logging": {
        "console_loglevel": "INFO"
        # "logfile": "log.log"
    },
    # Directory to write various log files.
    "log_dir": "~/qmi_course/log",
    "contexts": {
        # Testing remote instrument access.
        "instr_server": {
            "host": "127.0.0.1",
            "tcp_server_port": 40001
        },
        # Testing process management.
        "proc_demo": {
            "host": "127.0.0.1",
            "tcp_server_port": 40002,
            "enabled": true,
            "program_module": "task_demo"
        }
    }
}
```

The ‘”enabled”: true’ parameter makes it possible to start the context via QMI process management, and ‘”program_module”: “task_demo”’ line tells the QMI to start a module named ‘task_demo.py’ for this process. We’ll create it in a qubit, but first let’s define a task we want to make the service for.

### Demo task

To demonstrate a custom task, we need to create one. Make a new Python module inside the module path for your project. If you don’t have a module path yet, just create a file `demo_task.py` in the current directory:

``` python
from dataclasses import dataclass
import logging
import qmi
from qmi.core.rpc import rpc_method
from qmi.core.task import QMI_Task, QMI_TaskRunner


# Global variable holding the logger for this module.
_logger = logging.getLogger(__name__)


@dataclass
class DemoLoopTaskSettings:
    sample: float | None
    amplitude: float


class CustomRpcControlTaskRunner(QMI_TaskRunner):
    @rpc_method
    def set_amplitude(self, amplitude: float):
        settings = self.get_settings()
        settings.amplitude = amplitude
        self.set_settings(settings)


class DemoRpcControlTask(QMI_Task):
    def __init__(self, task_runner, name):
        super().__init__(task_runner, name)
        self.settings = DemoLoopTaskSettings(amplitude=100.0, sample=None)

    def run(self):
        _logger.info("starting the background task")
        nsg = qmi.get_instrument("proc_demo.nsg")
        while not self.stop_requested():
            self.update_settings()
            nsg.set_amplitude(self.settings.amplitude)
            self.sleep(0.01)

        _logger.info("stopping the background task")
```

Note that we define class `DemoRpcControlTask` with one special method named `run()`. This method contains the code that makes up the background task. In this simple example, the task simply loops once per second, reading settings from the sine generator and adjusting its amplitude. The task uses the function [`qmi.core.task.QMI_Task.sleep()`](https://qmi.readthedocs.io/en/latest/build/qmi.core.task.html#qmi.core.task.QMI_Task.sleep) to sleep instead of `time.sleep()`. The advantage of this is that it stops waiting immediately when it is necessary to stop the task.

### Task runner script

Now we still miss the program starting up and running the task. Make the `task_demo.py` file with the following contents:

``` python
import logging
import time
import qmi
from qmi.utils.context_managers import start_stop
from qmi.instruments.dummy.noisy_sine_generator import NoisySineGenerator
from demo_task import DemoRpcControlTask, CustomRpcControlTaskRunner

# Global variable holding the logger for this module.
_logger = logging.getLogger(__name__)


def main():
    with start_stop(qmi, "proc_demo", config_file="./qmi.conf"):
        ctx = qmi.context()
        with qmi.make_instrument("nsg", NoisySineGenerator) as nsg:
            with qmi.make_task("demo_task", DemoRpcControlTask, task_runner=CustomRpcControlTaskRunner) as task:
                _logger.info("the task has been started")
                while task.is_running() and not ctx.shutdown_requested():
                    sample = nsg.get_sample()
                    amplitude = nsg.get_amplitude()
                    print(" " * int(40.0 + 0.25 * sample) + "*")
                    if abs(sample) > 10:
                        task.set_amplitude(amplitude * 0.9)
                    else:
                        task.set_amplitude(amplitude * 1.1)

                    time.sleep(0.01)

            _logger.info("the task has been stopped")


if __name__ == "__main__":
    main()
```

This program now takes care of creating the instrument `nsg` and followingly starting up the task. The script also loops about once per second, and at each iteration prints out the latest sample and amplitude values, and controls the `DemoRpcControlTask`’s amplitude to keep the sample value at around 10. In practice, we are now trying to suppress the sine wave as much as possible by continuously controlling its amplitude.

### Running the task as a service

We can now start the service using `qmi_proc` program. `qmi_proc` is a command-line executable created when installing QMI, see also documentation about [managing background processes](https://qmi.readthedocs.io/en/latest/tutorial.html%23managing-background-processes). It can be used to start, stop and inquire status of services. To start the “proc_demo” service, type the following (the “--config ./qmi.conf” is not necessary if the `qmi.conf` is in the default path).

``` shell
qmi_proc start proc_demo --config ./qmi.conf
```

Leave the program now to run a few seconds and then stop it:

``` shell
qmi_proc stop proc_demo --config ./qmi.conf
```

The use of the `qmi_proc` creates extra output files for services. One was now created also for “proc_demo” service. You can find it in the default location with name “proc_demo\_<date>\_<time>.out”. Opening this file, after a few info statements, you’ll see again the sine wave starting, like in the earlier example. Only now, it’ll quickly loose amplitude and become a very slightly wavy sine line. If you see that to happen, the service did it’s job.

There are plenty of other things going on on this example, like the use of a custom `QMI_TaskRunner` with an RPC method added into the runner. We also make use of file-specific loggers for logging. For more information about QMI tasks see the [tutorial](https://qmi.readthedocs.io/en/latest/tutorial.html#making-a-qmi-task), and about logging the [Design Overview](https://qmi.readthedocs.io/en/latest/design.html#logging) in documentation. There are also other examples of tasks in the `examples` folder of the QMI repository.

Further, the amplitude control through the task settings actually utilizes the QMI’s signalling feature. For more details on this, you can read into [signalling](https://qmi.readthedocs.io/en/latest/design.html#signalling) and look at API of [qmi.core.task](https://qmi.readthedocs.io/en/latest/build/qmi.core.task.html#module-qmi.core.task) in the documentation.

::: keypoints
-   Also QMI tasks need to be defined in `qmi.conf`. To enable running the task a a service, parameters "enabled" and "program_module" need to be define.
-   A task consists of a `QMI_Task` class and a `QMI_TaskRunner` class. The latter can be customized to include RPC methods in tasks.
-   `qmi_proc` is an executable created while installing QMI. It can be used to start, stop and checking status of (local) QMI tasks running as background processes.
:::
