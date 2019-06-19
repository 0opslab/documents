# secedit:validate



Validates the security settings stored in a security template (.inf file). For examples of how this command can be used, see [Examples](#BKMK_Examples).

## Syntax

```
Secedit /validate <configuration file name>  

```

### Parameters

|Parameter|Description|
|---------|-----------|
|Configuration file name|Required.</br>Specifies the path and file name for the security template that will be validated.|

## Remarks

Validating security templates can help you if one is corrupted or inappropriately set.

An invalid security template will not be applied.

The log file will not be updated.

In Windows Server 2008, `Secedit /refreshpolicy` has been replaced with `gpupdate`. For information on how to refresh security settings, see [Gpupdate](gpupdate.md).

## <a name="BKMK_Examples"></a>Examples

After a rollback is performed on a security template, you want to verify that the rollback inf file, secRBKcontoso.inf, is valid.
```
Secedit /validate secRBKcontoso.inf
```

#### Additional references

-   [Secedit:generaterollback](secedit-generaterollback.md)
-   [Secedit](secedit.md)
-   [Command-Line Syntax Key](command-line-syntax-key.md)