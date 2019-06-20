# Using the remove-DriverPackage Command

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012


>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

removes a driver package from a server.
## Syntax
```
wdsutil /remove-DriverPackage [/Server:<Server name>] {/DriverPackage:<Package Name> | /PackageId:<ID>}
```
## Parameters
|Parameter|Description|
|-------|--------|
|[/Server:<Server name>]|Specifies the name of the server. This can be the NetBIOS name or the FQDN. If a server name is not specified, the local server is used.|
|[/DriverPackage:<Name>]|Specifies the name of the driver package to remove.|
|[/PackageId:<ID>]|Specifies the Windows Deployment Services ID of the driver package to remove. You must specify the ID if the driver package cannot be uniquely identified by name.|
## <a name="BKMK_examples"></a>Examples
To view information about the images, type one of the following:
```
wdsutil /remove-DriverPackage /PackageId:{4D36E972-E325-11CE-Bfc1-08002BE10318}
```
```
wdsutil /remove-DriverPackage /Server:MyWdsServer /DriverPackage:MyDriverPackage
```
#### additional references
[Command-Line Syntax Key](command-line-syntax-key.md)
[Using the remove-DriverPackages Command](using-the-remove-driverpackages-command.md)
