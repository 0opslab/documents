# Get a list of PIDs matching the pattern 
#获取与模式匹配的PID列表
pgrep example

# Kill all PIDs matching the pattern
#杀死与模式匹配的所有PID
pgrep -f example | xargs kill
