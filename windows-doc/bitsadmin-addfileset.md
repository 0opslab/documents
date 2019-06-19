# bitsadmin addfileset



Adds one or more files to the specified job.

## Syntax

```
bitsadmin /addfileset <Job> <TextFile>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|
|TextFile|A text file containing remote and local file names.</br>Note: The names are space-delimited. Lines that begin with a # character are treated as a comment.|

## <a name="BKMK_examples"></a>Examples

```
C:\>bitsadmin /addfileset files.txt
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)