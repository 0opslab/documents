#bitsadmin getmaxdownloadtime

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Retrieves the download timeout in seconds.

## Syntax

```
bitsadmin /GetMaxDownloadtime <Job> 
```

## Parameters

|Parameter|Description|
|-------|--------|
|Job|The job's display name or GUID|

## Remarks

-   N\/A

## <a name="BKMK_examples"></a>Examples
The following example gets maximum download time for the job named *myDownloadJob* in seconds.

```
C:\>bitsadmin /GetMaxDownloadtime myDownloadJob
```

## additional references
[Command-Line Syntax Key](command-line-syntax-key.md)


