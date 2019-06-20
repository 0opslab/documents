# bitsadmin wrap

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Wraps any line of output text extending beyond the rightmost edge of the command window to the next line.
## Syntax
```
bitsadmin /Wrap Job
```
## Parameters
|Parameter|Description|
|-------|--------|
|Job|The job's display name or GUID|
## Remarks
Specify before other commands. By default, all commands, except the [bitsadmin monitor](bitsadmin-monitor.md) command, wrap the output.
## <a name="BKMK_examples"></a>Examples
The following example retrieves information for the job named *myDownloadJob* and wraps the output.
```
C:\>bitsadmin /Wrap /Info myDownloadJob /verbose
```
## additional references
[Command-Line Syntax Key](command-line-syntax-key.md)
