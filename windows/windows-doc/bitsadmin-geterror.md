# bitsadmin geterror



Retrieves detailed error information for the specified job.

## Syntax

```
bitsadmin /GetError <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example retrieves the error information for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetError myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)