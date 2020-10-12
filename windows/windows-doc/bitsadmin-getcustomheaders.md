# bitsadmin getcustomheaders



Retrieves the custom HTTP headers from the job.

## Syntax

```
bitsadmin /GetCustomHeaders <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example gets the custom headers for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetCustomHeaders myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)