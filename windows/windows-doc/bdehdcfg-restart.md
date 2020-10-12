# bdehdcfg: restart



Informs the Bdehdcfg command-line tool that the computer should be restarted after the drive preparation has concluded. For an example of how this command can be used, see [Examples](#BKMK_Examples).

## Syntax

```
bdehdcfg -target {default|unallocated|<DriveLetter> shrink|<DriveLetter> merge} -restart
```

### Parameters

This command takes no additional parameters.

## Remarks

If other users are logged on to the computer and the **quiet** command is not specified, a prompt will be displayed to confirm that the computer should be restarted.

## <a name="BKMK_Examples"></a>Examples

The following example illustrates using the **restart** command.
```
bdehdcfg -target default -restart
```

#### Additional references

-   [Command-Line Syntax Key](command-line-syntax-key.md)
-   [Bdehdcfg](bdehdcfg.md)