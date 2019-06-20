# ftp: put

>Applies To: Windows Server (Semi-Annual Channel), Windows Server 2016, Windows Server 2012 R2, Windows Server 2012

Copies a local file to the remote computer using the current file transfer type.   
## Syntax  
```  
put <LocalFile> [<remoteFile>]  
```  
### Parameters  
|Parameter|Description|  
|-------|--------|  
|<LocalFile>|Specifies the local file to copy.|  
|[<remoteFile>]|Specifies the name to use on the remote computer.|  
## Remarks  
-   The **put** command is identical to the **send** command.  
-   if *remoteFile* is not specified, the file is given the *LocalFile* name.  
## <a name="BKMK_Examples"></a>Examples  
copy the local file **test.txt** and name it **test1.txt** on the remote computer.  
```  
put test.txt test1.txt  
```  
copy the local file **program.exe** to the remote computer.  
```  
put program.exe  
```  
## additional references  
-   [ftp: ascii](ftp-ascii.md)  
-   [ftp: binary](ftp-binary.md)  
-   [Command-Line Syntax Key](command-line-syntax-key.md)  
