# bitsadmin getreplyfilename



Gets the path of the file that contains the server reply.

## Syntax

```
bitsadmin /GetReplyFileName <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## Remarks

Valid only for upload-reply jobs.

## <a name="BKMK_examples"></a>Examples

The following example retrieves the reply filename for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetReplyFileName myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)