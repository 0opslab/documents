# bitsadmin rawreturn



Returns data suitable for parsing.

## Syntax

```
bitsadmin /RawReturn
```

## Remarks

Strips new line characters and formatting from the output.

Typically, you use this command in conjunction with the **Create** and **Get\*** commands to receive only the value. You must specify this command before other commands.

## <a name="BKMK_examples"></a>Examples

The following example retrieves the raw data for the state of the job named *myDownloadJob*.
```
C:\>bitsadmin /RawReturn /GetState myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)