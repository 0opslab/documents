# bitsadmin getreplyprogress



Retrieves the size and progress of the server reply.

## Syntax

```
bitsadmin /GetReplyProgress <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## Remarks

Valid only for upload-reply jobs.

## <a name="BKMK_examples"></a>Examples

The following example retrieves the reply progress for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetReplyProgress myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)