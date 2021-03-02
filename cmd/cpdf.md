# title{cpdf - }

```bash
# Read in.pdf, select pages 1, 2, 3 and 6, and write those pages to
#读入.pdf，选择第1,2,3和6页，然后将这些页面写入
# out.pdf
#out.pdf
cpdf in.pdf 1-3,6 -o out.pdf

# Select the even pages (2, 4, 6...) from in.pdf and write those pages
#从in.pdf中选择偶数页（2,4,6 ...）并写入这些页面
# to out.pdf
#到out.pdf
cpdf in.pdf even -o out.pdf

# Using AND to perform several operations in order, here merging two
#使用AND按顺序执行多个操作，这里合并两个
# files together and adding a copyright stamp to every page.
#文件一起并为每个页面添加版权标记。
cpdf -merge in.pdf in2.pdf AND -add-text "Copyright 2014" -o out.pdf

# Read control.txt and use its contents as the command line arguments
#读取control.txt并将其内容用作命令行参数
# for cpdf.
#对于cpdf。
cpdf -control control.txt

# Merge in.pdf and in2.pdf into one document, writing to out.pdf.
#将in.pdf和in2.pdf合并到一个文档中，写入out.pdf。
cpdf -merge in.pdf in2.pdf -o out.pdf

# Split in.pdf into ten-page chunks, writing them to Chunk001.pdf,
#将in.pdf拆分为十页块，将它们写入Chunk001.pdf，
# Chunk002.pdf etc
#Chunk002.pdf等
cpdf -split in.pdf -o Chunk%%%.pdf -chunk 10

# Split in.pdf on bookmark boundaries, writing each to a file whose
#在书签边界上拆分in.pdf，将每个文件写入一个文件
# name is the bookmark label
#name是书签标签
cpdf -split-bookmarks 0 in.pdf -o @N.pdf

# Scale both the dimensions and contents of in.pdf by a factor of two
#将in.pdf的维度和内容缩放两倍
# in x and y directions.
#在x和y方向。
cpdf -scale-page "2 2" in.pdf -o out.pdf

# Scale the pages in in.pdf to fit the US Letter page size, writing to
#缩放in.pdf中的页面以适合US Letter页面大小，写入
# out.pdf
#out.pdf
cpdf -scale-to-fit usletterportrait in.pdf -o out.pdf

# Shift the contents of the page by 26 pts in the x direction, and 18
#将页面内容沿x方向移动26点，然后移动18
# millimetres in the y direction, writing to out.pdf
#在y方向上毫米，写到out.pdf
cpdf -shift "26pt 18mm" in.pdf -o out.pdf

# Rotate the contents of the pages in in.pdf by ninety degrees and
#将in.pdf中的页面内容旋转90度
# write to out.pdf.
#写到out.pdf。
cpdf -rotate-contents 90 in.pdf -o out.pdf

# Crop the pages in in.pdf to a 600 pts by 400 pts rectangle.
#将in.pdf中的页面裁剪为600 pts×400 pts矩形。
cpdf -crop "0 0 600pt 400pt" in.pdf -o out.pdf

# Encrypt using 128bit PDF encryption using the owner password 'fred'
#使用所有者密码'fred'使用128位PDF加密进行加密
# and the user password 'joe'
#和用户密码'joe'
cpdf -encrypt 128bit fred joe in.pdf -o out.pdf

# Decrypt using the owner password, writing to out.pdf.
#使用所有者密码解密，写入out.pdf。
cpdf -decrypt in.pdf owner=fred -o out.pdf

# Compress the data streams in in.pdf, writing the result to out.pdf.
#压缩in.pdf中的数据流，将结果写入out.pdf。
cpdf -compress in.pdf -o out.pdf

# Decompress the data streams in in.pdf, writing to out.pdf.
#在in.pdf中解压缩数据流，写入out.pdf。
cpdf -decompress in.pdf -o out.pdf

# List the bookmarks in in.pdf. This would produce:
#列出in.pdf中的书签。这会产生：
cpdf -list-bookmarks in.pdf

# Outputs:
#输出：

# Add bookmarks in the same form from a prepared file bookmarks.txt to
#从准备好的文件bookmarks.txt中添加相同表单的书签
# in.pdf, writing to out.pdf.
#in.pdf，写到out.pdf。
cpdf -add-bookmarks bookmarks.txt in.pdf -o out.pdf

# Use the Split style to build a presentation from the PDF in.pdf,
#使用拆分样式从PDF in.pdf构建演示文稿，
# each slide staying 10 seconds on screen unless manually advanced.
#每个幻灯片在屏幕上停留10秒，除非手动前进。
# The first page, being a title does not move on automatically, and
#作为标题的第一页不会自动移动，并且
# has no transition effect.
#没有过渡效应。
cpdf -presentation in.pdf 2-end -trans Split -duration 10 -o out.pdf

# Stamp the file watermark.pdf on to each page of in.pdf, writing the
#将文件watermark.pdf标记到in.pdf的每一页上，写入
# result to out.pdf.
#结果是out.pdf。
cpdf -stamp-on watermark.pdf in.pdf -o out.pdf

# Add a page number and date to all the pages in in.pdf using the
#使用以下命令为in.pdf中的所有页面添加页码和日期
# Courier font, writing to out.pdf
#Courier字体，写入out.pdf
cpdf -topleft 10 -font Courier -add-text "Page %Page\nDate %d-%m-%Y" in.pdf -o out.pdf

# Two up impose the file in.pdf, writing to out.pdf
#两个人将文件in.pdf强制写入out.pdf
cpdf -twoup-stack in.pdf -o out.pdf

# Add extra blank pages after pages one, three and four of a document.
#在文档的第一页，第三页和第四页之后添加额外的空白页。
cpdf -pad-after 1,3,4 in.pdf -o out.pdf

# List the annotations in a file in.pdf to standard output.
#将文件in.pdf中的注释列出为标准输出。
cpdf -list-annotations in.pdf

# Might Produce:
#可能会产生：

# -- # Annotation text content 1 # -- # -- # Annotation text content 2
# - 注释文本内容1  -   - 注释文本内容2
# --
#--

# Copy the annotations from from.pdf to in.pdf, writing to out.pdf.
#将注释从from.pdf复制到in.pdf，写入out.pdf。
cpdf -copy-annotations from.pdf in.pdf -o out.pdf

# Set the document title of in.pdf. writing to out.pdf.
#设置in.pdf的文档标题。写到out.pdf。
cpdf -set-title "The New Title" in.pdf -o out.pdf

# Set the document in.pdf to open with the Acrobat Viewer's toolbar
#将文档in.pdf设置为使用Acrobat Viewer的工具栏打开
# hidden, writing to out.pdf.
#隐藏，写出来.pdf。
cpdf -hide-toolbar true in.pdf -o out.pdf

# Set the metadata in a PDF in.pdf to the contents of the file
#将PDF in.pdf中的元数据设置为文件的内容
# metadata.xml, and write the output to out.pdf.
#metadata.xml，并将输出写入out.pdf。
cpdf -set-metadata metadata.xml in.pdf -o out.pdf

# Set the document in.pdf to open in Acrobat Viewer showing two
#将文档in.pdf设置为在Acrobat Viewer中打开，显示两个
# columns of pages, starting on the right, putting the result in
#页面的列，从右侧开始，将结果放入
# out.pdf.
#out.pdf。
cpdf -set-page-layout TwoColumnRight in.pdf -o out.pdf

# Set the document in.pdf to open in Acrobat Viewer in full screen
#将文档in.pdf设置为在Acrobat Viewer中全屏打开
# mode, putting the result in out.pdf.
#模式，将结果输入out.pdf。
cpdf -set-page-mode FullScreen in.pdf -o out.pdf

# Attach the file sheet.xls to in.pdf, writing to out.pdf.
#将文件sheet.xls附加到in.pdf，写入out.pdf。
cpdf -attach-file sheet.xls in.pdf -o out.pdf

# Remove any attachments from in.pdf, writing to out.pdf.
#从in.pdf中删除所有附件，写入out.pdf。
cpdf -remove-files in.pdf -o out.pdf

# Blacken all the text in in.pdf, writing to out.pdf.
#将in.pdf中的所有文本变黑，写入out.pdf。
cpdf -blacktext in.pdf -o out.pdf

# Make sure all lines in in.pdf are at least 2 pts wide, writing to
#确保in.pdf中的所有行都至少有2个宽，写入
# out.pdf.
#out.pdf。
cpdf -thinlines 2pt in.pdf -o out.pdf
```
