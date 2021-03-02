# title{convert - 命令可以用来转换图像的格式，支持JPG, BMP, PCX, GIF, PNG, TIFF, XPM和XWD等类型}


```bash
# To resize an image to a fixed width and proportional height:
#要将图像调整为固定宽度和比例高度：
convert original-image.jpg -resize 100x converted-image.jpg

# To resize an image to a fixed height and proportional width:
#要将图像调整为固定高度和比例宽度，请执行以下操作：
convert original-image.jpg -resize x100 converted-image.jpg

# To resize an image to a fixed width and height:
#要将图像调整为固定宽度和高度，请执行以下操作：
convert original-image.jpg -resize 100x100 converted-image.jpg

# To resize an image and simultaneously change its file type:
#要调整图像大小并同时更改其文件类型：
convert original-image.jpg -resize 100x converted-image.png

# To resize all of the images within a directory:
#要调整目录中的所有图像：
# To implement a for loop:
#要实现for循环：
for file in `ls original/image/path/`;
    do new_path=${file%.*};
    new_file=`basename $new_path`;
    convert $file -resize 150 converted/image/path/$new_file.png;
done
```