# title{iwconfig - 配置无线网络接口}

```bash
# Display wireless settings of the first wireless adapter
# 显示第一个无线适配器的无线设置
iwconfig wlan0

# Take down / up the wireless adapter
# 取下/升起无线适配器
iwconfig wlan0 txpower {on|auto|off}

# Change the mode of the wireless adapter
# 更改无线适配器的模式
iwconfig wlan0 mode {managed|ad-hoc|monitor}
```