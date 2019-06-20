# bitsadmin cancel



Removes the job from the transfer queue and deletes all temporary files associated with the job.

## Syntax

```
bitsadmin /cancel <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example removes the *myDownloadJob* job from the transfer queue.
```
C:\>bitsadmin /cancel myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)