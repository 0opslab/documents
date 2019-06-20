# bitsadmin geterrorcount



Retrieves a count of the number of times the specified job generated a transient error.

## Syntax

```
bitsadmin /GetErrorCount <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example retrieves error count information for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetErrorCount myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)