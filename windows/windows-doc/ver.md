# ver



Displays the operating system version number.

This command is supported in the Windows Command prompt (Cmd.exe), but not in PowerShell.

For examples of how to use this command, see [Examples](#BKMK_examples).

## Syntax

```
ver
```

## Parameters

|Parameter|Description|
|---------|-----------|
|/?|Displays help at the command prompt.|

## <a name="BKMK_examples"></a>Examples

To obtain the version number of the operating system from the Command shell (cmd.exe), type:

```
ver
```

The ver command does not work in PowerShell. To obtain the OS version from PowerShell, type:

```powershell
$PSVersionTable.BuildVersion
````


#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)
