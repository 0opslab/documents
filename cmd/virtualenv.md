# title{virtualenv - 虚拟环境}

```bash
# Create new environment
#创造新的环境
virtualenv /path/to/project/env_name

# Create new environment and inherit already installed Python libraries
#创建新环境并继承已安装的Python库
virtualenv --system-site-package /path/to/project/env_name

# Create new environment with a given Python interpreter
#使用给定的Python解释器创建新环境
virtualenv /path/to/project/env_name -p /usr/bin/python/3.4

# Activate environnment
#激活环境
source /path/to/project/env_name/bin/activate

# Quit environment
#退出环境
deactivate


# virtualenvwrapper (wrapper for virtualenv)
#virtualenvwrapper（virtualenv的包装）
# installation
#安装
pip install --user virtualenvwrapper
# configuration
#组态
# add in ~/.bashrc or similar
#添加〜/ .bashrc或类似的
export WORKON_HOME=~/.virtualenvs
mkdir -p $WORKON_HOME
source ~/.local/bin/virtualenvwrapper.sh

# Create new environmment (with virtualenvwrapper)
#创建新环境（使用virtualenvwrapper）
mkvirtualenv env_name
# new environmment is stored in ~/.virtualenvs
#新环境存储在〜/ .virtualenvs中

# Activate environmment (with virtualenvwrapper)
#激活环境（使用virtualenvwrapper）
workon env_name

# Quit environmment (with virtualenvwrapper)
#退出环境（使用virtualenvwrapper）
deactivate

# Delete environmment (with virtualenvwrapper)
#删除环境（使用virtualenvwrapper）
rmvirtualenv env_name

```

