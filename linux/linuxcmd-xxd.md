# Convert bin/string to hex.
#将bin / string转换为hex。
# Result: 34322069732074686520736f6c7574696f6e0a
#结果：34322069732074686520736f6c7574696f6e0a
echo '42 is the solution' | xxd -p

# Convert hex to bin/string.
#将十六进制转换为bin / string。
# Result: 42 is the solution
#结果：42是解决方案
echo '34322069732074686520736f6c7574696f6e0a' | xxd -r -p

