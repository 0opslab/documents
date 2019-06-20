#bitsadmin getsecurityflags

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Reports the HTTP security flags for URL redirection and checks performed on the server certificate during the transfer.

## Syntax

```
bitsadmin /GetSecurityFlags <Job> 
```

## Parameters

|Parameter|Description|
|-------|--------|
|Job|The job's display name or GUID|

## <a name="BKMK_examples"></a>Examples
The following example retrieves the securitly flags from a job named *myJob*.

```
C:\>bitsadmin /GetSecurityFlags myJob 
```

## additional references
[Command-Line Syntax Key](command-line-syntax-key.md)


