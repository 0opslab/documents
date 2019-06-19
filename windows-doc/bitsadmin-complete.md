# bitsadmin complete



Completes the job. The downloaded files are not available to you until you use this switch. Use this switch after the job moves to the transferred state. Otherwise, only those files that have been successfully transferred are available.

## Syntax

```
bitsadmin /complete <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

When the state of the job is TRANSFERRED, BITS has successfully transferred all files in the job. However, the files are not available until you use the **/complete** switch. If multiple jobs use *myDownloadJob* as their name, you must replace *myDownloadJob* with the job's GUID to uniquely identify the job.
```
C:\>bitsadmin /complete myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)