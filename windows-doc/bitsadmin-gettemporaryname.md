# bitsadmin gettemporaryname



Reports the temporary filename of the given file within the job.

## Syntax

```
bitsadmin /GetTemporaryName <Job> <file index> 
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|
|File index|Starts from 0|

## <a name="BKMK_examples"></a>Examples

The following example reports the temporary filename of file 2 for the job named *myJob*.
```
C:\>bitsadmin /GetTemporaryName myJob 1 
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)