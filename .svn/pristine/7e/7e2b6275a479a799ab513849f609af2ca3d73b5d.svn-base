# bitsadmin getnotifyflags



Retrieves the notify flags for the specified job.

## Syntax

```
bitsadmin /GetNotifyFlags <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## Remarks

The job can contain one or more of the following notification flags.

|-----|-----|
|0x001|Generate an event when all files in the job have been transferred.|
|0x002|Generate an event when an error occurs.|
|0x004|Disable notifications.|
|0x008|Generate an event when the job is modified or transfer progress is made.|

## <a name="BKMK_examples"></a>Examples

The following example retrieves the notify flags for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetNotifyFlags myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)