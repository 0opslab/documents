# bitsadmin getminretrydelay



Retrieves the length of time, in seconds, that the service waits after encountering a transient error before trying to transfer the file.

## Syntax

```
bitsadmin /GetMinRetryDelay <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example retrieves the minimum retry delay for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetMinRetryDelay myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)