title: 半自动化办公脚本
date: 2016-01-03 19:58:11
tags:
    - Python
    - Java
categories: Tools-Scripts
---
今天遇到一些excel数据。excel不是太会玩 具体的数据格式如下，第一和有列日期和数量,
其后的单列行(遇到俩列行为止)的行都是该月的量。现在想要统计每月的总量。
想来excel中肯定也有公式能很好的处理。苦于不会，用手单独重复的统计，实在有点
而且数据量还是相当的大，那更是...因此写了俩端脚本进行半自动化处理。
python和java的脚本。

```bash
20151201	1
	1
	1
	2
	1
	1
	1
	1
	1
	1
	1
20151202	1
	1
	1
	2
	1
	1
	1
	1
	1
	1
	1
```
# python脚本
```python
#!/usr/bin/python
# coding:utf-8

import fileinput
from conf import db


if __name__ == "__main__":
    # 更新业务产品类别b
    lst_day = []
    lst_count = [0]
    index = 0
    t =0
    for line in fileinput.input("data/TimeCount.txt"):
        tt = line.split()
        day = '2015-12-00'
        if len(tt) == 2:
            if t != index:
                index += 1
            lst_day.append(tt[0])
            lst_count[index] = lst_count[index] + int(tt[1])
            lst_count.append(0)
            t += 1

        else:
            lst_count[index] = lst_count[index] + int(tt[0])

    for i in xrange(0, 31):
        print '%s-%d' % (lst_day[i], lst_count[i])

```

# Java脚本
```java
	@Test
    public void testList(){
        File file = new File(System.getProperty("user.dir") + "/Junit/Resource/TimeCount.txt");
        List<String> lines = FileUtil.lines(file);
        Map<String,Integer> group = new HashMap<String,Integer>();
        String key ="";
        for(String line:lines) {
            line = line.replaceAll("^\\t","").replaceAll("\\t",":");
            String[] tt = line.split(":");

            if(tt.length == 2){
                key = tt[0];
                if(!group.containsKey(key)){
                    group.put(key,0);
                }
                int count = Integer.parseInt(tt[1]) + group.get(key);
                group.put(key,count);
            }else{
                int count = Integer.parseInt(tt[0]) + group.get(key);
                group.put(key,count);
            }
        }
        PrintUtil.print(group);
    }
```
输出结果
```bash
	20151201-193
	20151202-173
	20151203-165
	20151204-220
	20151205-188
	20151206-199
	....
```