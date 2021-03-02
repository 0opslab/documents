
import os
import sys
import re

fileSuffix = ['.md']
pattern = re.compile(r'([^<>/\\\|:""\*\?]+)\.\w+$')

def get_file_name(path_string):
  pattern = re.compile(r'([^<>/\\\|:""\*\?]+)\.\w+$')
  data = pattern.findall(path_string)
  if data:
    return data[0]

def delFirstLine(path_string):
  with open(path_string, "r+",encoding="utf-8") as f:
    a=f.readlines()
    b=''.join(a[1:])
    f.seek(0)
    f.truncate(0)
    f.write(b)

def addTitleLine(file):
  try:
    with open(file, "r+",encoding="utf-8") as f:
      old = f.read()
      if not old.startswith("# title{"):
        titleLine = "# title{%s - }\n"%( re.sub("_","-",(get_file_name(file))))
        f.seek(0)
        f.write(titleLine)
        f.write(old)
  except Exception as es:
    print(file)
    print(es)

if __name__ == "__main__":
  path = "c:\\workspace\\useful-command"
  for root,dirs,files in os.walk(path):
    for ff in files:
      file = os.path.join(root, ff)
      parent_path = os.path.dirname(file)
      suffix = os.path.splitext(ff)[-1]
      if suffix in fileSuffix and parent_path != path:
        #addTitleLine(file)
        print(file)

