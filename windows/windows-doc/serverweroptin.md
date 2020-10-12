# serverweroptin

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Allows you to enable error reporting.
## Syntax
```
serverweroptin [/query] [/detailed] [/summary]
```
### Parameters
|Parameter|Description|
|-------|--------|
|/query|verifies the current setting.|
|/detailed|Sends detailed reports automatically.|
|/summary|Sends summary reports automatically.|
|/?|Displays help at the command prompt.|
## <a name="BKMK_Examples"></a>Examples
To verify the current setting, type:
```
serverweroptin /query
```
To automatically send detailed reports, type:
```
serverweroptin /detailed
```
To automatically send summary reports, type
```
serverweroptin /summary
```
## additional references
-   [Command-Line Syntax Key](command-line-syntax-key.md)

