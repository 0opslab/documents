# Using the disable-TransportServer Command

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Disables all services for a Transport Server.
## Syntax
```
wdsutil [Options] /Disable-TransportServer [/Server:<Server name>]
```
## Parameters
|Parameter|Description|
|-------|--------|
|[/Server:<Server name>]|Specifies the name of the Transport Server to be disabled. This can be either the NetBIOS name or the fully qualified domain name (FQDN). If no Transport Server name is specified, the local server will be used.|
## <a name="BKMK_examples"></a>Examples
To disable the server, type:
```
wdsutil /Disable-TransportServer
wdsutil /verbose /Disable-TransportServer /Server:MyWDSServer
```
#### additional references
[Command-Line Syntax Key](command-line-syntax-key.md)
[Using the enable-TransportServer Command](using-the-enable-transportserver-command.md)
[Using the get-TransportServer Command](using-the-get-transportserver-command.md)
[Subcommand: set-TransportServer](subcommand-set-transportserver.md)
[Subcommand: start-TransportServer](subcommand-start-transportserver.md)
[Subcommand: stop-TransportServer](subcommand-stop-transportserver.md)
