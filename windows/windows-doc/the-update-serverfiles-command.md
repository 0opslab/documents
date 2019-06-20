# The Update-ServerFiles Command



Updates files in the REMINST shared folder by using the latest files that are stored in the server's %Windir%\System32\RemInst folder. To ensure the validity of your Windows Deployment Services installation, you should run this command once after each server upgrade, service pack installation, or update to Windows Deployment Services files.

## Syntax

```
WDSUTIL [Options] /Update-ServerFiles [/Server:<Server name>]
```

## Parameters

|Parameter|Description|
|---------|-----------|
|[/Server:\<Server name>]|Specifies the name of the server. This can be either the NetBIOS name or the fully qualified domain name (FQDN). If no server name is specified, the local server will be used.|

## <a name="BKMK_examples"></a>Examples

To update the files, type one of the following:
```
WDSUTIL /Update-ServerFiles
WDSUTIL /Verbose /Progress /Update-ServerFiles /Server:MyWDSServer
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)