# nslookup set timeout

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

changes the initial number of seconds to wait for a reply to a lookup request.
## Syntax
```
set timeout=<Number>
```
## Parameters
|Parameter|Description|
|-------|--------|
|<Number>|Specifies the number of seconds to wait for a reply. The default number of seconds to wait is 5.|
|{help &#124; ?}|Displays a short summary of **nslookup** subcommands.|
## Remarks
-   When a reply to a request is not received within the specified time period, the time-out is doubled and the request is sent again. You can use the **set retry** command to control the number of retries.
## <a name="BKMK_examples"></a>Examples
The following example sets the timeout for getting a response to 2 seconds:
```
set timeout=2
```
## additional references
[Command-Line Syntax Key](command-line-syntax-key.md)
[nslookup set retry](nslookup-set-retry.md)
