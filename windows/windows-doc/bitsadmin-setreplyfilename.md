# bitsadmin setreplyfilename



Specify the path of the file that contains the server reply.

## Syntax

```
bitsadmin /SetReplyFileName <Job> <Path>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|
|Path|Location to place the server reply|

## Remarks

Valid only for upload-reply jobs.

## <a name="BKMK_examples"></a>Examples

The following example sets the reply filename pathfor the job named *myDownloadJob*.
```
C:\>bitsadmin /SetReplyFileName myDownloadJob c:\reply
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)