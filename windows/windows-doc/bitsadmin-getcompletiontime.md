# bitsadmin getcompletiontime



Retrieves the time that the job finished transferring data.

## Syntax

```
bitsadmin /GetCompletionTime <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example retrieves the time that the job named *myDownloadJob* finished transferring data.
```
C:\>bitsadmin /GetCompletionTime myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)