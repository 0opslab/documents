# title{base64 - 再shell中编码解码base64}


# 进行base64编码
```bash
base=$(base64  <<< "123456" )
echo "$base"
```

# 进行base64解码
```bash
base=$(base64 -d <<< "MTIzNDU2Cg==" )
echo "$base"
```


