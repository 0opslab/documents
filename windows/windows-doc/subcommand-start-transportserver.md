# Subcommand: start-TransportServer

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

starts all services for a Transport Server.
## Syntax
```
wdsutil [Options] /start-TransportServer [/Server:<Server name>]
```
## Parameters
|Parameter|Description|
|-------|--------|
|[/Server:<Server name>]|Specifies the name of the Transport Server. This can be either the NetBIOS name or the fully qualified domain name (FQDN). If no server name is specified, the local server will be used.|
## <a name="BKMK_examples"></a>Examples
To start the server, type one of the following:
```
wdsutil /start-TransportServer
wdsutil /verbose /start-TransportServer /Server:MyWDSServer
```
#### additional references
[Command-Line Syntax Key](command-line-syntax-key.md)
[Using the disable-TransportServer Command](using-the-disable-transportserver-command.md)
[Using the enable-TransportServer Command](using-the-enable-transportserver-command.md)
[Using the get-TransportServer Command](using-the-get-transportserver-command.md)
[Subcommand: set-TransportServer](subcommand-set-transportserver.md)
[Subcommand: stop-TransportServer](subcommand-stop-transportserver.md)
