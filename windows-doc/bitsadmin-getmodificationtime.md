# bitsadmin getmodificationtime



Retrieves the last time the job was modified or data was successfully transferred.

## Syntax

```
bitsadmin /GetModificationTime <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example retrieves the last modified time for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetModificationTime myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)