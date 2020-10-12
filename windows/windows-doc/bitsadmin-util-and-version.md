# bitsadmin util and version



Displays the version of BITS service.

## Syntax

```
bitsadmin /Util /Version [/Verbose]
```

## Remarks

The **Verbose** command performs the following:
-   Displays the file version for each BITS related DLL
-   Verifies the BITS Service can be started
-   Displays BITS Group Policy values (Windows Vista only)

## <a name="BKMK_examples"></a>Examples

The following example the version of the BITS Service.
```
C:\>bitsadmin /Util /Version
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)