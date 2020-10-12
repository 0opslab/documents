# import



Imports a foreign disk group into the disk group of the local computer.

## Syntax

```
import [noerr]
```

## Parameters

|Parameter|Description|
|---------|-----------|
|noerr|For scripting only. When an error is encountered, DiskPart continues to process commands as if the error did not occur. Without this parameter, an error causes DiskPart to exit with an error code.|

## Remarks

-   The import command imports every disk that is in the same group as the disk with focus.
-   A dynamic disk in a foreign disk group must be selected for this operation to succeed. Use the **select disk** command to select a disk and shift the focus to it.

## <a name="BKMK_examples"></a>Examples

To import every disk that is in the same disk group as the disk with focus into the disk group of the local computer, type:
```
import
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)

