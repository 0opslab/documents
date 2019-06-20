# The verbose Command



Displays verbose output for a specified command. You can use **/verbose** with any other WDSUTIL commands that you run. Note that you must specify **/verbose** and **/progress** directly after **WDSUTIL**.

## Syntax

```
WDSUTIL /verbose <commands>
```

## Examples

To delete approved computers from the Auto-Add database and show verbose output, type:
```
WDSUTIL /Verbose /progress /Delete-AutoAddDevices /Server:MyWDSServer /DeviceType:ApprovedDevices
```