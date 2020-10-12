# break



Sets or clears extended CTRL+C checking on MS-DOS systems. If used without parameters, **break** displays the current setting.

> [!NOTE]
> This command is no longer in use. It is included only to preserve compatibility with existing MS-DOS files, but it has no effect at the command line because the functionality is automatic.

## Syntax

```
break=[on|off]
```

## Remarks

If command extensions are enabled and running on the Windows platform, inserting the **break** command into a batch file enters a hard-coded breakpoint if being debugged by a debugger.

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)