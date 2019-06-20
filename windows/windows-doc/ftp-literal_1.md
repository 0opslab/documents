# ftp: literal_1

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012
Sends verbatim arguments to the remote ftp server. A single ftp reply code is returned.   

## Syntax  
```  
literal <Argument> [ ]  
```  
### Parameters  
|Parameter|Description|  
|-------|--------|  
|<Argument>|Specifies the argument to send to the ftp server.|  
## Remarks  
The **literal** command is identical to the **quote** command.  
## <a name="BKMK_Examples"></a>Examples  
Send a **quit** command to the remote ftp server.  
```  
literal quit  
```  
## additional references  
-   [ftp: quote](ftp-quote.md)  
-   [Command-Line Syntax Key](command-line-syntax-key.md)  
