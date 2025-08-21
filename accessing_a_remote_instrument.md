---
title: "accessing_a_remote_instrument"
output: html_document
---

::: questions
-   What are QMI configuration and log files?
:::

::: objectives
-   Know how to create a basic configuration file.
:::

## Accessing a remote instrument

QMI makes it easy to access an instrument instance that exists in another Python program. The programs may even run on different computers. The Python program that contains the instrument instance must be accessible via the network. This can be achieved by extending the QMI configuration file. The new file will look as follows:

``` json
{
    # Log level for messages to the console.
    "logging": {
        "console_loglevel": "INFO"
    },
    "contexts": {
        # Testing remote instrument access.
        "instr_server": {
            "host": "127.0.0.1",
            "tcp_server_port": 40001
        }
    }
}
```

Note that JSON is very picky about the use of commas. There must be a comma between multiple elements in the same group, but there may not be a comma after the last element of a group.

Start the instrument server with the following lines:

``` python
from qmi.instruments.dummy.noisy_sine_generator import NoisySineGenerator
qmi.start("instr_server")
nsg = qmi.make_instrument("nsg", NoisySineGenerator)
```

Because the name of the context instr_server matches the name specified in the configuration file, QMI opens a TCP server port for this context. Check that the reading of configuration file succeeded by calling `qmi.context().get_context_config()`. In the response string, the `host` and `tcp_server_port` values should be the same as in the configuration file. If this is not the case, stop the context, and start it again providing the `qmi.conf` file path with the `config_file` parameter. Then try again to confirm the host and port. Other Python programs can now connect to this port to access the sine generator.

To try this, leave the instrument server session running and start another Python session in a separate terminal window:

``` python
import qmi
qmi.start("random_client")
qmi.context().connect_to_peer("instr_server")
nsg = qmi.get_instrument("instr_server.nsg")
nsg.get_sample()
```

> NOTE: With Windows, the `connect_to_peer` also requires explicit input of the context address. You can check the address by calling `qmi.show_network_contexts()`. Then give the whole address as second parameter in the call with `peer_address=<the_address>`. If the connecting now went without an exception, everything should be now OK. You can confirm this by calling again `qmi.show_network_contexts()`and see that the ‘connected’ column has now changed to ‘yes’. Then proceed to get the instrument and a sample.

> NOTE 2: `peer_address=”127.0.0.1:40001”` also works as the ‘localhost’ address changes into the IPv4 address in the background. This exercise demonstrated how the second Python program is able to access the `NoisySineGenerator` instance proxy that exists within the first Python program (and QMI context within it). To do this, the QMI context of the second program connects to the “instr_server” context via TCP. Behind the scenes, the two contexts exchange messages through this connection to arrange for the method `get_sample()` to be called in the real instrument instance through the proxy, and the answer to be sent back to the calling proxy in the second program.

::: keypoints
-   `qmi.conf` has a JSON-like structure
-   Log levels are set within "logging" keyword section
-   Default name and location of the log file are `qmi.log` and the user's home directory
:::
