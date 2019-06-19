# Set contex



Sets the context for shadow copy creation. If used without parameters, **set context** displays help at the command prompt.

For examples of how to use this command, see [Examples](#BKMK_examples).

## Syntax

```
set context {clientaccessible | persistent [nowriters] | volatile [nowriters]}
```

## Parameters

|Parameter|Description|
|---------|-----------|
|clientaccessible|Specifies that the shadow copy is usable by client versions of Windows.|
|persistent|Specifies that the shadow copy persists across program exit, reset, or restart.|
|volatile|Deletes the shadow copy on exit or reset.|
|nowriters|Specifies that all writers are excluded.|

## Remarks

-   The *clientaccessible* context is persistent by default.

## <a name="BKMK_examples"></a>Examples

To prevent shadow copies from being deleted when you exit DiskShadow, type:
```
set context persistent
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)