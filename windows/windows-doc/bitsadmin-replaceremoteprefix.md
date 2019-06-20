# bitsadmin replaceremoteprefix



All files in the job whose remote URL begins with *OldPrefix* are changed to use *NewPrefix*.

## Syntax

```
bitsadmin /ReplaceRemotePrefix <Job> <OldPrefix> <NewPrefix
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|
|OldPrefix|Existing URL prefix|
|NewPrefix|New URL prefix|

## <a name="BKMK_examples"></a>Examples

The following example changes all files in job named *myDownloadJob* whose remote URL begins with *http://stageserver* to *http://prodserver*.
```
C:\>bitsadmin /ReplaceRemotePrefix myDownloadJob http://stageserver http://prodserver
```

## Additional information

[Command-Line Syntax Key](command-line-syntax-key.md)