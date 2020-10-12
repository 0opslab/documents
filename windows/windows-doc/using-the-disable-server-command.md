# Using the disable-Server Command



Disables all services for a Windows Deployment Services server.

## Syntax

```
WDSUTIL [Options] /Disable-Server [/Server:<Server name>]
```

## Parameters

|Parameter|Description|
|---------|-----------|
|[/Server:\<Server name>]|Specifies the name of the server. This can be either the NetBIOS name or the fully qualified domain name (FQDN). If no server name is specified, the local server will be used.|

## <a name="BKMK_examples"></a>Examples

To disable the server, run one of the following:
```
WDSUTIL /Disable-Server
WDSUTIL /Verbose /Disable-Server /Server:MyWDSServer
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)

