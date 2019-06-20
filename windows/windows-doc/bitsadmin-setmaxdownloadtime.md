# bitsadmin setmaxdownloadtime



Sets the download timeout in seconds.

## Syntax

```
bitsadmin /SetMaxDownloadTime <Job> <Timeout>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|
|Timeout|The timeout in seconds|

## Remarks

-   N/A

## <a name="BKMK_examples"></a>Examples

The following example sets the timeout for the job named *myDownloadJob* to 10 seconds.
```
C:\>bitsadmin /SetMaxDownloadTime myDownloadJob 10
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)