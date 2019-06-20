# unlodctr

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Removes Performance counter names and Explain text for a service or device driver from the system registry.   

## Syntax  
```  
Unlodctr <DriverName>   
```  
### Parameters  
|Parameter|Description|  
|-------|--------|  
|\<DriverName>|removes the Performance counter name settings and Explain text for driver or service <DriverName> from the Windows Server 2003 registry.|  
|/?|Displays help at the command prompt.|  

## Remarks  
> [!WARNING]  
> Incorrectly editing the registry may severely damage your system. Before making changes to the registry, you should back up any valued data on the computer.  

If the information that you supply contains spaces, use quotation marks around the text (for example, "<DriverName>").  

## <a name="BKMK_Examples"></a>Examples  
To remove the current Performance registry settings and counter Explain text for the Simple Mail Transfer Protocol (SMTP) service:  
```  
unlodctr SMTPSVC  
```  
## Additional references  
-   [Command-Line Syntax Key](command-line-syntax-key.md)  
  
