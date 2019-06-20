# ftp: ascii

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Sets the file transfer type to ASCII.   
## Syntax  
```  
ascii  
```  
### Parameters  
none  
## Remarks  
-   The default file transfer type is ASCII.  
-   In ASCII mode, character conversions to and from the network standard character set are performed. For example, end-of-line characters are converted as necessary, based on the target operating system.  
-   **ftp** supports both ASCII and binary image file transfer types. Use ASCII when transferring text files. For more information about binary file transfer, see **ftp: binary** in additional references.  
## <a name="BKMK_Examples"></a>Examples  
Set the file transfer type to ASCII.  
```  
ascii  
```  
## additional references  
-   [ftp: binary](ftp-binary.md)  
-   [Command-Line Syntax Key](command-line-syntax-key.md)  
