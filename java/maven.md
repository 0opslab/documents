## Maven常用命令

```
//创建普通项目
mvn archetype:create
    -DgroupId=packageName
    -DartifactId=projectName

//创建Maven的web项目
mvn archetype:create
    -DgroupId=packageName
    -DartifactId=webappName
    -DarchetypeArtifactId=maven-archetype-webapp
    
//编译源代码    
mvn compile
//编译测试代码
mvn test-compile
//运行测试
mvn test
//产生site
mvn site

//打包
mvn package

//在本地Repository中安装jar
mvn install
例：installing D:\xxx\xx.jar to D:\xx\xxxx

//清除产生的项目
mvn clean

//生成eclipse项目
mvc eclipse:ecplise

//生成IDEA项目
mvn idea:idea

//只打jar包
mvn jar:jar

//查看当前项目已呗解析的依赖
mvn dependency:list

//显示整个依赖树
mvn dependency:tree


```

### maven插件

Maven本质上是一个执行插件的框架。插件共分两类：build插件和reporting插件。**build插件**，会在build阶段被执行，应该配置在POM的<build/>元素中。**reporting插件**，生成站点的时候会执行，应该配置在POM的<reporting/>元素中。因为reporting插件的结果是生成的站点的一部分，所以这种插件应该是国际化和本地化的。

下面是一些常用插件的列表：

| 插件     | 描述                                                |
| :------- | :-------------------------------------------------- |
| clean    | 构建之后清理目标文件。删除目标目录。                |
| compiler | 编译 Java 源文件。                                  |
| surefile | 运行 JUnit 单元测试。创建测试报告。                 |
| jar      | 从当前工程中构建 JAR 文件。                         |
| war      | 从当前工程中构建 WAR 文件。                         |
| javadoc  | 为工程生成 Javadoc。                                |
| antrun   | 从构建过程的任意一个阶段中运行一个 ant 任务的集合。 |



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

