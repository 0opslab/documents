#!/usr/bin/python3
#coding=utf-8
import os
import re

fileSuffix = ['.py','.md','.sql','.bat','.pl','.ps1','.vbs','.sh',".js"]


def loadFileContent(path_string):
  '''获取文件内容'''
  try:
    with open(path_string, "r+",encoding="utf-8") as f:
      a=f.readlines()
      title = a[0].strip().replace('\n','')
      content=''.join(a[1:])
      return title,content
  except Exception as es:
    print("loadFileContent Error",path_string,es)

def fileNameGorupCount(path):
  '''对路径下的文件名字进行重复统计'''
  count_dict = {}
  for root,dirs,files in os.walk(path):
    for ff in files:
      file = os.path.join(root, ff)
      suffix = os.path.splitext(ff)[-1]
      ffname = os.path.basename(file).split(".")[0]
      if suffix in fileSuffix:
        # 如果字典里有该单词则加1，否则添加入字典
        if ffname in count_dict.keys():
            count_dict[ffname] = count_dict[ffname] + 1
        else:
            count_dict[ffname] = 1
  #按照词频从高到低排列
  count_list=sorted(count_dict.items(),key=lambda x:x[1],reverse=True)
  for f in count_list:
    if(f[1] > 1):
      print(f[0])

### 获取脚本函数关键词
def cleanComment(res):
  return res[5:-1]

def clearPythonFunc(res):
  return str(res[3:-1]).strip()

def clearJsFunc1(res):
  return str(res[8:-1]).strip()

def clearJsFunc2(res):
  return str(res.split("\s+")[0]).strip()

def shFunc1(res):
  return str(res[0:-2])

reList = [
  {'type':'comment_func','re':re.compile('func{.*}'),'clear':cleanComment},
  {'type':'java_funcname','re':re.compile('public\s+ \w{}'),'clear':cleanComment},
  {'type':'python_funcname','re':re.compile(u'def\s+[a-zA-Z0-9_]{3,}\s{0,}\('),'clear':clearPythonFunc},
  {'type':'js_funcname1','re':re.compile('function\s[a-zA-Z0-9_]{3,}\s{0,}\('),'clear':clearJsFunc1},
  {'type':'js_funcname2','re':re.compile('[a-zA-Z0-9_]{3,}\s+=\s+function\s+\('),'clear':clearJsFunc2},
  {'type':'sh_funcname','re':re.compile('[a-zA-Z0-9_]{3,}\s{0,}\(\)'),'clear':shFunc1}
]

def GetFuncComment(file_path):
  with open(file_path,encoding='UTF-8') as file_obj:
    Content = file_obj.read()
    ress = []
    for item in reList:
      resList = []
      res = item['re'].findall(Content)
      if len(res) > 0:
        for r in res:
          resList.append(item['clear'](r))
      
      if len(resList) > 0:
        reMap = {'type':item['type'],'list':resList}
        ress.append(reMap)
    return ress


def Save2db(conn,title,command_type,command,content):
  """保存或更新记录"""
  insert = "insert t_command_content(title,command_type,command,content) values('%s','%s','%s','%s')"
  delete = "delete from t_command_content where command_type='%s' and command ='%s'"
  try:
    delete_sql = delete % (command_type, command)
    insert_sql = insert % (
        title, command_type, command, content)
    print(delete_sql)
    mycur = conn.cursor()
    mycur.execute(delete_sql)
    mycur.execute(insert_sql)
    conn.commit()
  except Exception as es:
    print("保存入库失败===>"+es)

if __name__ == "__main__":
  path = "D:\\workspace\\useful-command"
  #fileNameGorupCount(path)
  for root,dirs,files in os.walk(path):
    for ff in files:
      file = os.path.join(root, ff)
      suffix = os.path.splitext(ff)[-1]
      ffname = os.path.basename(file).split(".")[0]
      title,fcontent = loadFileContent(file)
      funcComments = GetFuncComment(file)
      print(file,'===>',title,'===>',funcComments)