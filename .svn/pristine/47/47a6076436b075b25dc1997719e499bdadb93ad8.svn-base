---
title: 爬51job和智联的招聘信息
date: 2017-12-21 22:10:41
tags:
    - spider
    - Python
categories: tools
---
使用requests爬去51job和智联job的招聘信息。由于页面直接是静态的因此直接requests请求解析即可。注(右键查看源代码即可确定是否动态还是静态)
另外就是BeautifulSoup解析目前信息（不要那jquery的编程习惯来抓取，当然那样能很完成任务）。另外就是直接拿招聘信息的url来去重了，那个更新
时间其实就是一个套路。


```python
# coding:utf-8
import time
import requests
from bs4 import BeautifulSoup
import pymysql
import hashlib

"""51job"""

headers = {"Accept": "text/html,application/xhtml+xml,application/xml;",
           "Accept-Encoding": "gzip",
           "Accept-Language": "zh-CN,zh;q=0.8",
           "Referer": "https://www.baidu.com/",
           "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 "+
                "(KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"
           }


def md5str(*args):
    datastr = ""
    for x in args:
        datastr = datastr + str(x)
    m = hashlib.md5(datastr.encode(encoding='utf-8'))
    return m.hexdigest()


def zwyx_parse(zwyx):
    """月薪转换忽略十位个位"""
    import re
    if '/' in zwyx:
        try:
            partter = re.compile("[0-9]*\.?[0-9]+")
            ms = partter.findall(zwyx)
            if zwyx.strip().endswith('千/月'):
                return '-'.join([str(int(float(s) * 1000))[:-2] + '00' for s in ms])
            if zwyx.strip().endswith('千以下/月'):
                return '-'.join([str(int(float(s) * 1000))[:-2] + '00' for s in ms])
            if zwyx.strip().endswith('万/月'):
                return '-'.join([str(int(float(s) * 10000))[:-2] + '00' for s in ms])
            if zwyx.strip().endswith('万/年'):
                return '-'.join([str(int(float(s) * 10000 / 12))[:-2] + '00' for s in ms])
            return zwyx
        except:
            return zwyx
    elif zwyx.strip().endswith('1000元以下'):
        return zwyx.replace('元以下', '')
    else:
        try:
            partter = re.compile("[0-9]*\.?[0-9]+")
            ms = partter.findall(zwyx)
            return '-'.join([s[:-2] + '00' for s in ms])
        except:
            return zwyx


if __name__ == "__main__":
    day = time.strftime('%Y-%m-%d', time.localtime(time.time()))

    # pagecount
    pagecount = 1
    print("spider 51job.com city:西宁")

    conn = pymysql.connect(host="127.0.0.1", user="root",
                           password="xxxx",
                           database="xxx", charset="utf8")

    insert_sql = "insert into t_spider_jobs(kid,fromwebsite,zwmc,zwmc_url,gsmc,gsmc_url,zwyx"
        +",zwyx_s,gzdd,time,zwms) values(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
    for i in range(35):
        url = 'http://search.51job.com/list/320200,000000,0000,00,9,99,%2B,2,{0}.html'.format(i + 1)+
        '?lang=c&stype=&postchannel=0000&workyear=99&cotype=99°reefrom=99&jobterm=99&companysize=99'+
        '&providesalary=99&lonlat=0%2C0&radius=-1&ord_field=0&confirmdate=9&fromType=&dibiaoid=0&'+
        'address=&line=&specialarea=00&from=&welfare='
        print("get > ", url)
        r = requests.get(url, headers=headers)
        if r.status_code == 200:
            # print(r.encoding)
            html = r.text.encode('iso-8859-1').decode('gbk')
            soup = BeautifulSoup(html, "lxml")
            print("soup encoding", soup.original_encoding)
            zwmc = soup.select("div.el > p.t1 > span > a")
            gsmc = soup.select("div.el > span.t2 > a:nth-of-type(1)")
            zwyx = soup.select("div.el > span.t4")
            gzdd = soup.select("div.el > span.t3")
            date = soup.select('div.el > span.t5')
            for zwmc, gsmc, zwyx, gzdd in zip(zwmc, gsmc, zwyx, gzdd):
                r_zwmc = zwmc['title']
                r_zwmc_url = zwmc['href']
                r_gsmc = gsmc.get_text()
                r_gsmc_url = gsmc['href']
                r_zwyx = zwyx.get_text()
                r_gzdd = gzdd.get_text()
                kid = md5str(r_zwmc_url)
                zwyx_s = zwyx_parse(r_zwyx)
                # print(r_zwyx,'->',zwyx_s)
                insert_cursor = conn.cursor()
                try:
                    effect_row = insert_cursor.execute(
                        insert_sql, (kid, "51job.com", r_zwmc, r_zwmc_url, r_gsmc, r_gsmc_url, r_zwyx, zwyx_s, r_gzdd, day, ""))
                    print("insert row >", effect_row)
                except Exception as err:
                    print("insert row >", err)
                finally:
                    conn.commit()
                    insert_cursor.close()
        else:
            print("request error code ", r.status_code)

    conn.close()
    print("it's complete")

```
下面是智联的
```python
# coding:utf-8
import time
import requests
from bs4 import BeautifulSoup
import pymysql
import hashlib


"""智联zhaopin"""

headers = {"Accept": "text/html,application/xhtml+xml,application/xml;",
           "Accept-Encoding": "gzip",
           "Accept-Language": "zh-CN,zh;q=0.8",
           "Referer": "https://www.baidu.com/",
           "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36"+
                " (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"
           }


def md5str(*args):
    datastr = ""
    for x in args:
        datastr = datastr + str(x)
    m = hashlib.md5(datastr.encode(encoding='utf-8'))
    return m.hexdigest()


def zwyx_parse(zwyx):
    """月薪转换忽略十位个位"""
    import re
    if '/' in zwyx:
        try:
            partter = re.compile("[0-9]*\.?[0-9]+")
            ms = partter.findall(zwyx)
            if zwyx.strip().endswith('千/月'):
                return '-'.join([str(int(float(s) * 1000))[:-2] + '00' for s in ms])
            if zwyx.strip().endswith('千以下/月'):
                return '-'.join([str(int(float(s) * 1000))[:-2] + '00' for s in ms])
            if zwyx.strip().endswith('万/月'):
                return '-'.join([str(int(float(s) * 10000))[:-2] + '00' for s in ms])
            if zwyx.strip().endswith('万/年'):
                return '-'.join([str(int(float(s) * 10000 / 12))[:-2] + '00' for s in ms])
            return zwyx
        except:
            return zwyx
    elif zwyx.strip().endswith('1000元以下'):
        return zwyx.replace('元以下', '')
    elif zwyx.strip().endswith('元/月'):
        return zwyx.replace('元/月')
    else:
        try:
            partter = re.compile("[0-9]*\.?[0-9]+")
            ms = partter.findall(zwyx)
            return '-'.join([s[:-2] + '00' for s in ms])
        except:
            return zwyx

if __name__ == "__main__":
    day=time.strftime('%Y-%m-%d', time.localtime(time.time()))

    # 城市
    jl="西宁"
    # 关键字
    kw=""
    # pagecount
    pagecount=71
    print("spider zhaopin.com city:", jl, "key:", kw, ",pagecount", 72)
    conn=pymysql.connect(host="127.0.0.1", user="root",
                           password="xxxx",
                           database="xxx", charset="utf8")

    insert_sql="insert into t_spider_jobs(kid,fromwebsite,zwmc,zwmc_url,gsmc,gsmc_url,zwyx,zwyx_s,gzdd,time,zwms)"+
        " values(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
    for i in range(pagecount):
        url='http://sou.zhaopin.com/jobs/searchresult.ashx?jl={0}&kw={1}&sm=0&p={2}'.format(
            jl, kw, i + 1)
        print("get > ", url)
        r=requests.get(url, headers=headers)
        if r.status_code == 200:
            soup=BeautifulSoup(r.text, "lxml")
            zwmc=soup.select("table.newlist > tr > td.zwmc > div > a")
            gsmc=soup.select(
                "table.newlist > tr > td.gsmc > a:nth-of-type(1)")
            zwyx=soup.select("table.newlist > tr > td.zwyx")
            gzdd=soup.select("table.newlist > tr > td.gzdd")
            zwms=soup.select("table.newlist > tr.newlist_tr_detail > td")
            for zwmc, gsmc, zwyx, gzdd, zwms in zip(zwmc, gsmc, zwyx, gzdd, zwms):
                r_zwmc=zwmc.get_text()
                r_zwmc_url=zwmc['href']
                r_gsmc=gsmc.get_text()
                r_gsmc_url=gsmc['href']
                r_zwyx=zwyx.get_text()

                r_gzdd=gzdd.get_text()
                r_zwms=zwms.get_text()
                # try:
                #     r_zwms = r_zwms.encode('utf-8').decode('unicode_escape')
                # except:
                #     r_zwms = ""
                kid=md5str(r_zwmc_url)
                zwyx_s=zwyx_parse(r_zwyx)
                insert_cursor=conn.cursor()
                try:
                    effect_row=insert_cursor.execute(
                    insert_sql, (kid, "zhaopin.com", r_zwmc, r_zwmc_url, r_gsmc, r_gsmc_url, r_zwyx, zwyx_s, r_gzdd, day, r_zwms))
                    # print("insert row >", effect_row)
                except Exception as err:
                    # print(r_zwms)
                    print("insert row >", err)
                finally:
                    conn.commit()
                    insert_cursor.close()
        else:
            print("request error code ", r.status_code)

print("it's complete")

```