# bitsadmin getreplydata



Retrieves the server's reply data in hexadecimal format.

## Syntax

```
bitsadmin /GetReplyData <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## Remarks

Valid only for upload-reply jobs.

## <a name="BKMK_examples"></a>Examples

The following example retrieves the reply data for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetReplyData myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)