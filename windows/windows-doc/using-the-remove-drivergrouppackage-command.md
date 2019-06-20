# Using the remove-DriverGroupPackage Command



Removes a driver package from a driver group on a server.

## Syntax

```
WDSUTIL /Remove-DriverGroupPackage /DriverGroup:<Group Name> [/Server:<Server Name>] {/DriverPackage:<Name> | /PackageId:<ID>}
```

## Parameters

|Parameter|Description|
|---------|-----------|
|[/Server:\<Server name>]|Specifies the name of the server. This can be the NetBIOS name or the FQDN. If a server name is not specified, the local server is used.|
|[/DriverPackage:\<Name>]|Specifies the name of the driver package to remove.|
|[/PackageId:\<ID>]|Specifies the Windows Deployment Services ID of the driver package to remove. You must specify this option if the driver package cannot be uniquely identified by name.|

## <a name="BKMK_examples"></a>Examples

```
WDSUTIL /Remove-DriverGroupPackage /DriverGroup:PrinterDrivers /PackageId:{4D36E972-E325-11CE-BFC1-08002BE10318}
```
```
WDSUTIL /Remove-DriverGroupPackage /DriverGroup:PrinterDrivers /DriverPackage:XYZ
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)