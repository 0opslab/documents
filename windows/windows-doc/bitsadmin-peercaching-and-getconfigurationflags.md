# bitsadmin peercaching and getconfigurationflags



Gets the configuration flags that determine if the computer serves content to peers and can download content from peers.

## Syntax

```
bitsadmin /PeerCaching /GetConfigurationFlags <Job> 
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples

The following example gets the configuration flags for the job named *myJob*.
```
C:\> Bitsadmin /PeerCaching /GetConfigurationFlags myJob
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)