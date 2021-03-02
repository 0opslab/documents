#!/usr/bin/env python
#coding=utf-8

# func{基于python2实现http的命令执行}
from SimpleHTTPServer import SimpleHTTPRequestHandler
import SocketServer
import os,io,shutil
import logging
import cgi
import sys


log_path = './run_server_http2.log'
logging.basicConfig(level=logging.INFO,format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',datefmt='%a, %d %b %Y %H:%M:%S',filename=log_path)
class MyHttpHandler(SimpleHTTPRequestHandler):
    
    def execCmd(self,cmd): 
        '''execute command, and return the output  ''' 
        r = os.popen(cmd)  
        text = r.read()  
        r.close()
        return text  
        '''处理请求并返回页面'''


    # 处理一个GET请求
    def do_GET(self):
        con = self.execCmd('/home/local/script/deploy.sh')
        self.send_response(200)
        self.send_header("Content-Type", "text/html")
        self.send_header("Content-Length", str(len(con)))
        self.end_headers()
        self.wfile.write(con.encode('UTF-8'))
 
        
def start_server():
    server_host = '0.0.0.0'
    server_port = 8099
    httpd = SocketServer.TCPServer((server_host,server_port), MyHttpHandler)
    logging.info('\nStart server success ... \nserver_host:'+server_host+'   server_port:'+str(server_port))
    print('exe_server started on '+str(server_host)+' server_port:'+str(server_port))
    httpd.serve_forever()

if __name__ == "__main__":
    start_server()
