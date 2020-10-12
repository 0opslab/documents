# bitsadmin getproxylist



Retrieves the proxy list for the specified job.

## Syntax

```
bitsadmin /GetProxyList <Job>
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## Remarks

-   The proxy list is the list of proxy servers to use. The list is comma-delimited.

## <a name="BKMK_examples"></a>Examples

The following example retrieves the proxy list for the job named *myDownloadJob*.
```
C:\>bitsadmin /GetProxyList myDownloadJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)