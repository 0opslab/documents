    Boot entry ID:   1
    Friendly Name:   ""
    path:            multi(0)disk(0)rdisk(0)partition(1)\WINDOWS
    OS Load Options: /fastdetect /debug /debugport=com1:
    ```
-   The Boot Loader Settings portion of the **bootcfg query** output displays each entry in the [boot loader] section of Boot.ini.
-   The Boot Entries portion of the **bootcfg query** output displays the following detail for each operating system entry in the [operating systems] section of Boot.ini: Boot entry ID, Friendly Name, path, and OS Load Options.
## <a name="BKMK_examples"></a>Examples
The following examples show how you can use the **bootcfg /query** command:
```
bootcfg /query
bootcfg /query /s srvmain /u maindom\hiropln /p p@ssW23
bootcfg /query /u hiropln /p p@ssW23
```
#### additional references
[Command-Line Syntax Key](command-line-syntax-key.md)
