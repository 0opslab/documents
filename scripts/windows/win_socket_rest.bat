
::func{windows networt reset}
@echo off 
netsh winsock reset
netsh interface set interface "wlan0"disabled
netsh interface set interface "wlan0" enabled