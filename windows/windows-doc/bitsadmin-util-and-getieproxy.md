# bitsadmin util and getieproxy

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Retrieves the proxy usage for the given service account.
## Syntax
```
bitsadmin /Util /GetIEProxy <Account> [/Conn <ConnectionName>]
```
## Parameters
|Parameter|Description|
|-------|--------|
|Account|Specifies the service account whose proxy settings you want to retrieve. Possible values are:<br /><br />-   LOCALSYSTEM<br />-   NETWORKSERVICE<br />-   LOCALSERVICE|
|ConnectionName|Optional used with the **/Conn** command to specify the use of a modem connection. If you do not specify the **/Conn** command, BITS uses the LAN connection. Specify the modem connection name immediately following the **/Conn** parameter.|
## Remarks
This command shows the value for each proxy usage, not just the proxy usage you specified for the service account. For details on setting the proxy usage for service accounts, see the [bitsadmin util and setieproxy](bitsadmin-util-and-setieproxy.md) command.
## <a name="BKMK_examples"></a>Examples
The following example displays the proxy usage for the NETWORK SERVICE account.
```
C:\>bitsadmin /Util /GetIEProxy NETWORKSERVICE
```
## additional references
[Command-Line Syntax Key](command-line-syntax-key.md)
