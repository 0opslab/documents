# Pretty print the json
#相当打印json
jq "." < filename.json

# Access the value at key "foo"
#访问键“foo”的值
jq '.foo'

# Access first list item
#访问第一个列表项
jq '.[0]'

# Slice & Dice
#切片和骰子
jq '.[2:4]'
jq '.[:3]'
jq '.[-2:]'
