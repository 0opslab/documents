# title{xmlto - 一款用于xml操作的工具}

```bash
# DocBook XML to PDF
#DocBook XML到PDF
xmlto pdf mydoc.xml

# DocBook XML to HTML
#DocBook XML到HTML
xmlto -o html-dir html mydoc.xml

# DocBook XML to single HTML file
#DocBook XML到单个HTML文件
xmlto html-nochunks mydoc.xml

# modify output with XSL override
#使用XSL覆盖修改输出
xmlto -m ulink.xsl pdf mydoc.xml

# use non-default xsl
#使用非默认的xsl
xmlto -x mystylesheet.xsl pdf mydoc.xml
```
