    LASER Queue       3 jobs               *printer active*
       USER1          84        93844      printing
       USER2          85        12555      Waiting
       USER3          86        10222      Waiting
    ```
-   The following is an example of a report for a print job:
    ```
    Job #            35
    Status           Waiting
    Size             3096
    remark
    Submitting user  USER2
    Notify           USER2
    Job data type
    Job parameters
    additional info
    ```
## <a name="BKMK_examples"></a>Examples
This example shows how to list the contents of the Dotmatrix print queue on the \\\Production computer:
```
Net print \\Production\Dotmatrix 
```
This example shows how to display information about job number 35 on the \\\Production computer:
```
Net print \\Production 35 
```
This example shows how to delay job number 263 on the \\\Production computer:
```
Net print \\Production 263 /hold 
```
This example shows how to release job number 263 on the \\\Production computer:
```
Net print \\Production 263 /release 
```
#### additional references
[Command-Line Syntax Key](command-line-syntax-key.md)
[print Command Reference](print-command-reference.md)
