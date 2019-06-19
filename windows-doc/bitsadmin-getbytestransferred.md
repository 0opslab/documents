# bitsadmin getbytestransferred



Retrieves the number of bytes transferred for the specified job.

## Syntax

```
bitsadmin /GetBytesTransferred <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example retrieves the number of bytes transferred for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetBytesTransferred myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)