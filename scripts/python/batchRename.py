import os
import os.path
import re

#func{批量文件文件重命令}

def getPhoneNumber(account):
  a = re.findall('1\d{10}', account)
  if(len(a) > 0):
    return a[0]
  else:
    account

path = 'C:\\Users\\Administrator\\Desktop\\二维码-手机号'
 
for root,dirs,files in os.walk(path):
  for file in files:
    ff = os.path.join(root,file)
    suffix = os.path.splitext(ff)[-1]
    if suffix in ['.jpg','.png']:
      ffname = os.path.basename(ff)
      bpath = os.path.dirname(ff)
      newffName = os.path.join(bpath,getPhoneNumber(ffname)+suffix)
      print(ff,"===>",newffName+"\n")
      try:
        os.rename(ff,newffName)
      except Exception as es:
        print(es)
      


