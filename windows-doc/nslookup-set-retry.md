# nslookup set retry

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Sets the number of retries.
## Syntax
```
set retry=<Number>
```
## Parameters
|Parameter|Description|
|-------|--------|
|<Number>|Specifies the new value for the number of retries. The default number of retries is 4.|
|{help &#124; ?}|Displays a short summary of **nslookup** subcommands.|
## Remarks
-   When a reply to a request is not received within a certain amount of time, the time-out period is doubled and the request is resent. The retry value controls how many times a request is resent before giving up. You can change the time-out period with the **set timeout** subcommand.
## additional references
[Command-Line Syntax Key](command-line-syntax-key.md)
[nslookup set timeout](nslookup-set-timeout.md)
