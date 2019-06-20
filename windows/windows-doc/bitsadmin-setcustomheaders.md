# bitsadmin setcustomheaders



Add a custom HTTP header to a GET request.

## Syntax

```
bitsadmin /SetCustomHeaders <Job> <Header1> <Header2> <. . .>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|
|Header1 Header2 . . .|The custom headers for the job|

## Remarks

-   This command is used to add a custom HTTP header to a GET request sent to an HTTP server.

## <a name="BKMK_examples"></a>Examples

The following example adds a custom HTTP header for the job named *myDownloadJob*.
```
C:\>bitsadmin / SetCustomHeaders myDownloadJob "Accept-encoding:deflate/gzip"
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)