# mask



Removes hardware shadow copies that were imported by using the **import** command.

For examples of how to use this command, see [Examples](#BKMK_examples).

## Syntax

```
mask <ShadowSetID>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|ShadowSetID|Removes shadow copies that belong to the specified Shadow Copy Set ID.|

## Remarks

-   You can use an existing alias or an environment variable in place of *ShadowSetID*. Use **add** without parameters to see existing aliases.

## <a name="BKMK_examples"></a>Examples

To remove the imported shadow copy %Import_1%, type:
```
mask %Import_1%
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)