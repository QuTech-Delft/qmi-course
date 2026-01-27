---
title: "Accessing an instrument remotely"
output: html_document
teaching: 5
exercises: 10
---

::: questions
-   How can we access the instruments remotely?
:::

::: objectives
-   Learn to connect between QMI contexts and control instruments over contexts
:::

## Accessing a remote instrument

QMI makes it easy to access an instrument instance that exists in another Python program. The programs may even run on different computers. The Python program that contains the instrument instance must be accessible via the network. This can be achieved by extending the QMI configuration file. The new file will look as follows:

``` json
{
    # Log level for messages to the console.
    "logging": {
        "console_loglevel": "INFO"
    },
    # Directory to write various log files.
    "log_dir": "~/qmi_course/log"
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

> NOTE: With Windows, the `connect_to_peer` might require explicit input of the context address. You can check the address by calling `qmi.show_network_contexts()`. Then give the whole address as second parameter in the call with `peer_address=<the_address>`. If the connecting now went without an exception, everything should be now OK. You can confirm this by calling again `qmi.show_network_contexts()`and see that the ‘connected’ column has now changed to ‘yes’. Then proceed to get the instrument and a sample.

> NOTE 2: `peer_address=”127.0.0.1:40001”` also works as the ‘localhost’ address changes into the IPv4 address in the background. This exercise demonstrated how the second Python program is able to access the `NoisySineGenerator` instance proxy that exists within the first Python program (and QMI context within it). To do this, the QMI context of the second program connects to the “instr_server” context via TCP. Behind the scenes, the two contexts exchange messages through this connection to arrange for the method `get_sample()` to be called in the real instrument instance through the proxy, and the answer to be sent back to the calling proxy in the second program.

::: keypoints
-   Instruments to be accessed remotely should be defined in `qmi.conf`
-   Connect to another QMI context using `qmi.context().connect_to_peer("<context_name>", peer_address="<ho.st.i.p:port>")`
-   Obtain remote instrument control with `qmi.get_instrument("<context_name>.<instrument_name>")`
:::
