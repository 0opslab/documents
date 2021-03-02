# title{npm - 一起安装的包管理工具}

```bash
# Every command shown here can be used with the `-g` switch for global scope
#此处显示的每个命令都可以与`-g`开关一起用于全局范围

# Install a package in the current directory
#在当前目录中安装包
npm install <package>

# Install a package, and save it in the `dependencies` section of `package.json`
#安装一个包，并将其保存在`package.json`的`dependencies`部分
npm install --save <package>

# Install a package, and save it in the `devDependencies` section of `package.json`
#安装一个包，并将其保存在`package.json`的`devDependencies`部分
npm install --save-dev <package>

# Show outdated packages in the current directory
#在当前目录中显示过时的包
npm outdated

# Update outdated packages
#更新过时的软件包
npm update

# Update `npm` (will override the one shipped with Node.js)
#更新`npm`（将覆盖Node.js附带的那个）
npm install -g npm

# Uninstall a package
#卸载软件包
npm uninstall <package>
```