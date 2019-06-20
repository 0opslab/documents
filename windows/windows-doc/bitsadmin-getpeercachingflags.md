#bitsadmin getpeercachingflags

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Retrieves flags that determine if the files of the job can be cached and served to peers, and if BITS can download content for the job from peers.

## Syntax

```
bitsadmin /GetPeerCachingFlags <Job> 
```

## Parameters

|Parameter|Description|
|-------|--------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples
The following example retrieves the flags for the job named *myJob*.

```
C:\>bitsadmin /GetPeerCachingFlags myJob
```

## additional references
[Command-Line Syntax Key](command-line-syntax-key.md)


