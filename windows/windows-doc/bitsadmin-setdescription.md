# bitsadmin setdescription



Sets the description of the specified job.

## Syntax

```
bitsadmin /SetDescription <Job> <Description>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|
|Description|Text used to describe the job.|

## <a name="BKMK_examples"></a>Examples

The following example retrieves the description for the job named *myDownloadJob*.
```
C:\>bitsadmin /SetDescription myDownloadJob "Music Downloads"
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)