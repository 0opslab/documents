# bitsadmin get priority



Retrieves the priority of the specified job.

## Syntax

```
bitsadmin /GetPriority <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## Remarks

-   The priority is either FOREGROUND, HIGH, NORMAL, LOW, or UNKNOWN.

## <a name="BKMK_examples"></a>Examples

The following example retrieves the priority for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetPriority myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)