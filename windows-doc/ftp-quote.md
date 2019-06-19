# ftp: quote

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Sends verbatim arguments to the remote ftp server. A single ftp reply code is returned.   
## Syntax  
```  
quote <Argument>[ ]  
```  
### Parameters  
|Parameter|Description|  
|-------|--------|  
|<Argument>|Specifies the argument to send to the ftp server.|  
## Remarks  
The **quote** command is identical to the **literal** command.  
## <a name="BKMK_Examples"></a>Examples  
Send a **quit** command to the remote ftp server.  
```  
quote quit  
```  
## additional references  
-   [ftp: literal_1](ftp-literal_1.md)  
-   [Command-Line Syntax Key](command-line-syntax-key.md)  
