# bitsadmin gettype



Retrieves the job type of the specified job.

## Syntax

```
bitsadmin /GetType <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## Remarks

The type can be DOWNLOAD, UPLOAD, UPLOAD-REPLY, or UNKNOWN.

## <a name="BKMK_examples"></a>Examples

The following example retrieves the job type for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetType myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)