# ktmutil



Starts the Kernel Transaction Manager utility. If used without parameters, **ktmutil** displays available subcommands.

For examples of how to use this command, see [Examples](#BKMK_examples).

## Syntax

```
ktmutil list tms 
ktmutil list transactions [{TmGuid}]
ktmutil resolve complete {TmGuid} {RmGuid} {EnGuid}
ktmutil resolve commit {TxGuid}
ktmutil resolve rollback {TxGuid}
ktmutil force commit {??Guid}
ktmutil force rollback {??Guid}
ktmutil forget
```

## Parameters

## Remarks

## <a name="BKMK_examples"></a>Examples

To force an Indoubt transaction with GUID 311a9209-03f4-11dc-918f-00188b8f707b to commit, type:
```
ktmutil force commit {311a9209-03f4-11dc-918f-00188b8f707b}
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)