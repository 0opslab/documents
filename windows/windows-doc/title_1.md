# title



Creates a title for the Command Prompt window.

For examples of how to use this command, see [Examples](#BKMK_examples).

## Syntax

```
title [<String>]
```

## Parameters

|Parameter|Description|
|---------|-----------|
|\<String>|Specifies the title of the Command Prompt window.|
|/?|Displays help at the command prompt.|

## Remarks

-   To create window title for batch programs, include the **title** command at the beginning of a batch program.
-   After a window title is set, you can reset it only by using the **title** command.

## <a name="BKMK_examples"></a>Examples

In the following sample script, the title of the Command Prompt window is changed to "Updating Files" while the batch file executes the **copy** command. After the command is executed, the text `Files Updated` is displayed, and the title of the Command Prompt window is changed back to "Command Prompt."
```
@echo off
title Updating Files
copy \\server\share\*.xls c:\users\common\*.xls
echo Files Updated.
title Command Prompt
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)