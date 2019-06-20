# delete volume



Deletes the selected volume.

## Syntax

```
delete volume [noerr]
```

## Parameters

|Parameter|Description|
|---------|-----------|
|noerr|For scripting only. When an error is encountered, DiskPart continues to process commands as if the error did not occur. Without this parameter, an error causes DiskPart to exit with an error code.|

## Remarks

-   You cannot delete the system volume, boot volume, or any volume that contains the active paging file or crash dump (memory dump).
-   A volume must be selected for this operation to succeed. Use the **select volume** command to select a volume and shift the focus to it.

## <a name="BKMK_examples"></a>Examples

To delete the volume with focus, type:
```
delete volume
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)

