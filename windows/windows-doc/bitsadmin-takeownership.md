# bitsadmin takeownership



Lets a user with administrative privileges take ownership of the specified job.

## Syntax

```
bitsadmin /TakeOwnership <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example takes ownership of the job named *myDownloadJob*.
```
C:\>bitsadmin /TakeOwnership myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)