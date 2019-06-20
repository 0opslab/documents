# bitsadmin getfilestransferred



Retrieves the number of files transferred for the specified job.

## Syntax

```
bitsadmin /GetFilesTransferred <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example retrieves the number of files transferred in the job named *myDownloadJob*.
```
C:\>bitsadmin /GetFilesTransferred myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)