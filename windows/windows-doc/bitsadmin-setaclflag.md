# bitsadmin setaclflag



Sets the access control list propagations flags.

## Syntax

```
bitsadmin /SetAclFlags <Job> <Flags>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|
|Flags|Specify one or more of the following flag values:</br>-   O: Copy owner information with file.</br>-   G: Copy group information with file.</br>-   D: Copy DACL information with file.</br>-   S :Copy SACL information with file.|

## Remarks

The SetAclFlags command is used to maintain Owner and access control list information when a job is downloading data from a Windows (SMB) share.

## <a name="BKMK_examples"></a>Examples

The following example sets the access control list propagation flags for the job named *myDownloadJob* to maintain the owner and group information with the downloaded files.
```
C:\>bitsadmin /setaclflags myDownloadJob OG
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)