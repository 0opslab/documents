# bitsadmin cache and deleteurl



Deletes all cache entries for the given URL.

## Syntax

```
bitsadmin /DeleteURL url
```

## Parameters

|Parameter|Description|
|---------|-----------|
|url|The Uniform Resource Locator that identifies a remote file.|

## <a name="BKMK_examples"></a>Examples

The following example deletes all cache entries for https://www.microsoft.com/en/us/default.aspx
```
C:\>bitsadmin /DeleteURL https://www.microsoft.com/en/us/default.aspx 
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)