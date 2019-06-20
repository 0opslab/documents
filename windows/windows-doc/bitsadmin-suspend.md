# bitsadmin suspend

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Suspends the specified job.
## Syntax
```
bitsadmin /Suspend <Job>
```
## Parameters
|Parameter|Description|
|-------|--------|
|Job|The job's display name or GUID|
## Remarks
To restart the job, use the [bitsadmin resume](bitsadmin-resume.md) command.
## <a name="BKMK_examples"></a>Examples
The following example suspends the job named *myDownloadJob*.
```
C:\>bitsadmin /Suspend myDownloadJob
```
## additional references
[Command-Line Syntax Key](command-line-syntax-key.md)
