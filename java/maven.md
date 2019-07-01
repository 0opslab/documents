## Maven常用命令

创建普通项目

```
mvn archetype:create
    -DgroupId=packageName
    -DartifactId=projectName
```

创建Maven的web项目

```
mvn archetype:create
    -DgroupId=packageName
    -DartifactId=webappName
    -DarchetypeArtifactId=maven-archetype-webapp
```

编译源代码

mvn compile

编译测试代码

mvn test-compile

运行测试

mvn test

产生site

mvn site

打包

mvn package

在本地Repository中安装jar

```
mvn install
例：installing D:\xxx\xx.jar to D:\xx\xxxx
```

清楚产生的项目

```
mvn clean
```

生成eclipse项目

mvc eclipse:ecplise

生成IDEA项目

mvn idea:idea

只打jar包

mvn jar:jar



查看当前项目已呗解析的依赖

mvn dependency:list

显示整个依赖树

mvn dependency:tree



### 修改maven源为阿里源

修改maven目录下的settings.xml配置文件，设置如下

```xml
<mirror>
	<id>alimaven</id>
	<name>aliyun maven</name>
	<url>http://maven.aliyun.com/nexus/content/groups/public/</url>
	<mirrorOf>central</mirrorOf>
</mirror>
<mirror>
<id>alimaven</id>
	<mirrorOf>central</mirrorOf>
	<name>aliyun maven</name>
	<url>http://maven.aliyun.com/nexus/content/repositories/central/</url>
</mirror>
```

