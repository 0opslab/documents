# bitsadmin listfiles



Lists the files in the specified job.

## Syntax

```
bitsadmin /ListFiles <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example retrieves the list of files for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetNotifyFlags myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)