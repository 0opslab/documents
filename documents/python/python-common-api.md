title: python常用API实例
date: 2016-01-02 16:22:26
tags:
    - Python
    - requests
    - BeautifulSoup
    - threading
categories: Python
---
今天在微博上看到有人发的一个python的资源,挺好用的.但是是国外的网站有时间访问不是很稳定。所以写了段代码将其当下来
具体的代码如下。
<pre>
    特点:
        1.代码清晰便捷便于再次修改
        2.实用了多线程速度说的过去
    缺点:
        1.不支持断点续传
</pre>
```python
    #!/usr/bin/python
    # coding:UTF-8

    import sys, os, requests
    import threading, time
    import logging
    from threading import Thread, Condition
    from bs4 import BeautifulSoup

    '''
        DOWNLOAD code from
            http://www.programcreek.com/python/index/module/list
    '''

    headers = {
        'Accept': 'image/gif, image/jpeg, image/pjpeg, image/pjpeg,*/*',
        'Referer': 'http://www.programcreek.com',
        'Accept-Language': 'zh-cn',
        'User-Agent': 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1;.NET CLR 2.0.50727)',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept-Encoding': 'gzip, deflate'
    }



    def getLog(modeule_name):
        """Initialize logging module."""
        logger = logging.getLogger(modeule_name)
        formatter = logging.Formatter('%(asctime)s-(%(name)s)-[%(levelname)s] %(message)s')
        logger.setLevel(logging.DEBUG)

        # Create a file handler to store error messages
        fhdr = logging.FileHandler("./info.log", mode = 'w')
        fhdr.setLevel(logging.ERROR)
        fhdr.setFormatter(formatter)

        # Create a stream handler to print all messages to console
        chdr = logging.StreamHandler()
        chdr.setFormatter(formatter)

        logger.addHandler(fhdr)
        logger.addHandler(chdr)

        return logger




    # Handler Thread
    class Handler(threading.Thread):
        def __init__(self, name, queue,log):
            threading.Thread.__init__(self, name=name)
            self.data = queue
            self.log = log
        def html(self,url):
            for i in xrange(5):
                try:
                    r = requests.get(url, headers=headers)
                    return r.text
                except IOError:
                    log.error('requests error(retry...):%d->%s' % (i,url))
                    time.sleep(10)

        def wirtefile(self,file_name, strs):
            thread_name = threading.currentThread().getName()
            try:
                self.log.info('%s-%s' % (thread_name,file_name))
                # path
                path = os.path.split(file_name)[0].replace(".","/")
                name = os.path.split(file_name)[1]
                if not os.path.exists(path):
                    os.makedirs(path)

                h_file = open(path+'/'+name, 'w', 1)
                try:
                    h_file.write(strs.encode('utf-8'))
                finally:
                    h_file.close()
            except IOError:
                print "IOError"

        def download(self,item):
            text = self.html(item[1])
            if  text:
                soup = BeautifulSoup(text,"html.parser")
                header = soup.find('div',id='header')
                if header:
                    header.extract()
                ul = soup.find('ul', id='api-list')
                if ul:
                    #print "list page"
                    self.wirtefile(item[0] + '/index.html', soup.prettify())
                    for a in soup.find('ul', id='api-list').find_all('a'):
                        lst = [item[0] + '/' + str(a.contents[0]).strip(), a['href']]
                        condition.acquire()
                        if len(queue) == MAX_NUM:
                            condition.wait()
                        else:
                            self.data.append(lst)
                            condition.notify()
                        condition.release()
                else:
                    #content page"
                    #删除一些无用的元素
                    disqus_thread = soup.find('div',id='disqus_thread')
                    if disqus_thread:
                        disqus_thread.extract()
                    content = soup.find('div',id='content2').div
                    if content :
                        content.div
                    self.wirtefile(item[0]+".html",soup.prettify())

        def run(self):
            thread_name = threading.currentThread().getName()
            print thread_name + " is starting..."
            while True:
                try:
                    condition.acquire()
                    if not self.data:
                        condition.wait()
                    else:
                        self.download(self.data.pop())
                        condition.notify()
                    condition.release()
                    time.sleep(1)
                except IOError:
                    print "IOError"

    MAX_NUM = 1000
    condition = Condition()

    if __name__ == "__main__":
        queue = []
        queue.append(['download','http://www.programcreek.com/python/index/module/list'])
        log = getLog(__name__)
        for i in xrange(40):
            Handler("Thread" + str(i), queue,log).start()
            time.sleep(1)
```