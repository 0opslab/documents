---
title: Android配置文件之AndroidManifest
date: 2018-06-19 21:58:41
tags: android
---

AndroidManifest.xml同J2EE中web.xml一样重要，是整个APP应用程序的入口。它位于整个项目的根目录，描述了package中暴露的组件activity, service,广播接收器,各种能被处理的数据和启动位置已经一些APP需要的权限和安全控制。因此能看懂和修改该文件对于一名android开发人员或者DIY爱好者来说至关重要。虽然网上很多类似的文章已经整理的很全面，但是因为其阅读查询效果不是很理想，再次重新整理一份。

下面是其完整的结构
```xml
<?xmlversion="1.0"encoding="utf-8"?>
<manifest>
    <application>
        <activity>
            <intent-filter>
                <action>
                </action>
                <category>
                </category>
            </intent-filter>
        </activity>
        <activity-alias>
            <intent-filter>
            </intent-filter>
            <meta-data>
            </meta-data>
        </activity-alias>
        <service>
            <intent-filter>
            </intent-filter>
            <meta-data>
            </meta-data>
        </service>
        <receiver>
            <intent-filter>
            </intent-filter>
            <meta-data>
            </meta-data>
        </receiver>
        <provider>
            <grant-uri-permission>
            </grant-uri-permission>
            <meta-data>
            </meta-data>
        </provider>
        <uses-library>
        </uses-library>
    </application>
    <uses-permission>
    </uses-permission>
    <permission>
    </permission>
    <permission-tree>
    </permission-tree>
    <permission-group>
    </permission-group>
    <instrumentation>
    </instrumentation>
    <uses-sdk>
    </uses-sdk>
    <uses-configuration>
    </uses-configuration>
    <uses-feature>
    </uses-feature>
    <supports-screens>
    </supports-screens>
</manifest>
``` 
### 根原元素manifest
manifest作为根元素，定义了很多全局性的属性，具体信息如下
```xml
<manifest  xmlns:android="http://schemas.android.com/apk/res/android"
          package="com.woody.test"
          android:sharedUserId="string"
          android:sharedUserLabel="string resource"
          android:versionCode="integer"
          android:versionName="string"
          android:installLocation=["auto" | "internalOnly" | "preferExternal"] >
</manifest>
```
* xmlns:android
	定义android命名空间，一般为http://schemas.android.com/apk/res/android，这样使得Android中各种标准属性能在文件中使用，提供了大部分元素中的数据。
* package
	指定本应用内java主程序包的包名，它也是一个应用进程的默认名称
* android:sharedUserId
	表明数据权限，因为默认情况下，Android给每个APK分配一个唯一的UserID，所以是默认禁止不同APK访问共享数据的。若要共享数据，第一可以采用Share Preference方法，第二种就可以采用sharedUserId了，将不同APK的sharedUserId都设为一样，则这些APK之间就可以互相共享数据了。详见：http://wallage.blog.163.com/blog/static/17389624201011010539408/
* android:sharedUserLabel
	一个共享的用户名，它只有在设置了sharedUserId属性的前提下才会有意义
* android:versionCode
	是给设备程序识别版本(升级)用的必须是一个interger值代表app更新过多少次，比如第一版一般为1，之后若要更新版本就设置为2，3等等
* android:versionName
	这个名称是给用户看的，你可以将你的APP版本号设置为1.1版，后续更新版本设置为1.2、2.0版本等等
* android:installLocation
	安装参数，是Android2.2中的一个新特性，installLocation有三个值可以选择：internalOnly、auto、preferExternal选择preferExternal,系统会优先考虑将APK安装到SD卡上(当然最终用户可以选择为内部ROM存储上，如果SD存储已满，也会安装到内部存储上)选择auto，系统将会根据存储空间自己去适应选择internalOnly是指必须安装到内部才能运行

### Application
一个AndroidManifest.xml中必须含有一个Application标签，这个标签声明了每一个应用程序的组件及其属性(如icon,label,permission等)
```xml
<application  android:allowClearUserData=["true" | "false"]
             android:allowTaskReparenting=["true" | "false"]
             android:backupAgent="string"
             android:debuggable=["true" | "false"]
             android:description="string resource"
             android:enabled=["true" | "false"]
             android:hasCode=["true" | "false"]
             android:icon="drawable resource"
             android:killAfterRestore=["true" | "false"]
             android:label="string resource"
             android:manageSpaceActivity="string"
             android:name="string"
             android:permission="string"
             android:persistent=["true" | "false"]
             android:process="string"
             android:restoreAnyVersion=["true" | "false"]
             android:taskAffinity="string"
             android:theme="resource or theme" >
</application>
```

* android:allowClearUserData 
	用户是否能选择自行清除数据，默认为true，程序管理器包含一个选择允许用户清除数据。当为true时，用户可自己清理用户数据，反之亦然
* android:allowTaskReparenting 
	是否允许activity更换从属的任务，比如从短信息任务切换到浏览器任务
* android:backupAgent 
	这也是Android2.2中的一个新特性，设置该APP的备份，属性值应该是一个完整的类名，如com.project.TestCase，此属性并没有默认值，并且类名必须得指定(就是个备份工具，将数据备份到云端的操作)
* android:debuggable 
	这个从字面上就可以看出是什么作用的，当设置为true时，表明该APP在手机上可以被调试。默认为false,在false的情况下调试该APP
* android:description/android:label 
	此两个属性都是为许可提供的，均为字符串资源，当用户去看许可列表(android:label)或者某个许可的详细信息(android:description)时，这些字符串资源就可以显示给用户。label应当尽量简短，之需要告知用户该许可是在保护什么功能就行。而description可以用于具体描述获取该许可的程序可以做哪些事情，实际上让用户可以知道如果他们同意程序获取该权限的话，该程序可以做什么。我们通常用两句话来描述许可，第一句描述该许可，第二句警告用户如果批准该权限会可能有什么不好的事情发生
* android:enabled 
	Android系统是否能够实例化该应用程序的组件，如果为true，每个组件的enabled属性决定那个组件是否可以被 enabled。如果为false，它覆盖组件指定的值；所有组件都是disabled。
* android:hasCode 
	表示此APP是否包含任何的代码，默认为true，若为false，则系统在运行组件时，不会去尝试加载任何的APP代码,一个应用程序自身不会含有任何的代码，除非内置组件类，比如Activity类，此类使用了AliasActivity类，当然这是个罕见的现象
* android:icon 
	这个很简单，就是声明整个APP的图标，图片一般都放在drawable文件夹下
* android:killAfterRestore 
	这个属性用于指定在全系统的恢复操作期间，应用的设置被恢复以后，对应的问题程序是否应该被终止。单包恢复操作不会导致应用程序被关掉。全系统的复原操作通常只会发生一次，就是在电话被首次建立的时候。第三方应用程序通常不需要使用这个属性。默认值是true，这意味着在全系统复原期间，应用程序完成数据处理之后，会被终止。
* android:manageSpaceActivity 
	自己管理数据目录，则可以使用android:manageSpaceActivity属性来控制，而不是默认的全部清除了/data/data/包名/里面的所有文件
* android:name 
	为应用程序所实现的Application子类的全名。当应用程序进程开始时，该类在所有应用程序组件之前被实例化
* android:permission 
	设置许可名，这个属性若在<application>上定义的话，是一个给应用程序的所有组件设置许可的便捷方式，当然它是被各组件设置的许可名所覆盖的
* android:persistent 
	该应用程序是否应该在任何时候都保持运行状态,默认为false。因为应用程序通常不应该设置本标识，持续模式仅仅应该设置给某些系统应用程序才是有意义的。
* android:process 
	应用程序运行的进程名，它的默认值为<manifest>元素里设置的包名，当然每个组件都可以通过设置该属性来覆盖默认值。如果你想两个应用程序共用一个进程的话，你可以设置他们的android:process相同，但前提条件是他们共享一个用户ID及被赋予了相同证书的时候
* android:restoreAnyVersion 
	同样也是android2.2的一个新特性，用来表明应用是否准备尝试恢复所有的备份，甚至该备份是比当前设备上更要新的版本，默认是false
* android:taskAffinity 
	拥有相同的affinity的Activity理论上属于相同的Task，应用程序默认的affinity的名字是<manifest>元素中设定的package名
* android:theme 
	是一个资源的风格，它定义了一个默认的主题风格给所有的activity,当然也可以在自己的theme里面去设置它，有点类似style。


### Activity
Activity作为安卓的四大组件之一，其重要性不言而喻。
```xml
<activity android:allowTaskReparenting=["true" | "false"]
          android:alwaysRetainTaskState=["true" | "false"]
          android:clearTaskOnLaunch=["true" | "false"]
          android:configChanges=["mcc", "mnc", "locale",
                                 "touchscreen", "keyboard", "keyboardHidden",
                                 "navigation", "orientation", "screenLayout",
                                 "fontScale", "uiMode"]
          android:enabled=["true" | "false"]
          android:excludeFromRecents=["true" | "false"]
          android:exported=["true" | "false"]
          android:finishOnTaskLaunch=["true" | "false"]
          android:icon="drawable resource"
          android:label="string resource"
          android:launchMode=["multiple" | "singleTop" |
                              "singleTask" | "singleInstance"]
          android:multiprocess=["true" | "false"]
          android:name="string"
          android:noHistory=["true" | "false"]  
          android:permission="string"
          android:process="string"
          android:screenOrientation=["unspecified" | "user" | "behind" |
                                     "landscape" | "portrait" |
                                     "sensor" | "nosensor"]
          android:stateNotNeeded=["true" | "false"]
          android:taskAffinity="string"
          android:theme="resource or theme"
          android:windowSoftInputMode=["stateUnspecified",
                                       "stateUnchanged", "stateHidden",
                                       "stateAlwaysHidden", "stateVisible",
                                       "stateAlwaysVisible", "adjustUnspecified",
                                       "adjustResize", "adjustPan"] >   
</activity>
```


* android:alwaysRetainTaskState
	是否保留状态不变， 比如切换回home, 再从新打开，activity处于最后的状态。比如一个浏览器拥有很多状态(当打开了多个TAB的时候)，用户并不希望丢失这些状态时，此时可将此属性设置为true
* android:clearTaskOnLaunch 
	比如 P 是 activity, Q 是被P 触发的 activity, 然后返回Home, 重新启动 P，是否显示 Q	
* android:configChanges
	当配置list发生修改时， 是否调用 onConfigurationChanged() 方法  比如 "locale|navigation|orientation". 
* android:excludeFromRecents
	是否可被显示在最近打开的activity列表里，默认是false
* android:finishOnTaskLaunch
	当用户重新启动这个任务的时候，是否关闭已打开的activity，默认是false.如果这个属性和allowTaskReparenting都是true,这个属性就是王牌。Activity的亲和力将被忽略。该Activity已经被摧毁并非re-parented
* android:launchMode
	在多Activity开发中，有可能是自己应用之间的Activity跳转，或者夹带其他应用的可复用Activity。可能会希望跳转到原来某个Activity实例，而不是产生大量重复的Activity。这需要为Activity配置特定的加载模式，而不是使用默认的加载模式Activity有四种加载模式：
 	- standard：就是intent将发送给新的实例，所以每次跳转都会生成新的activity。
	- singleTop：也是发送新的实例，但不同standard的一点是，在请求的Activity正好位于栈顶时(配置成singleTop的Activity)，不会构造新的实例
	- singleTask：和后面的singleInstance都只创建一个实例，当intent到来，需要创建设置为singleTask的Activity的时候，系统会检查栈里面是否已经有该Activity的实例。如果有直接将intent发送给它。
	- singleInstance：首先说明一下task这个概念，Task可以认为是一个栈，可放入多个Activity。比如启动一个应用，那么Android就创建了一个Task，然后启动这个应用的入口Activity，那在它的界面上调用其他的Activity也只是在这个task里面。那如果在多个task中共享一个Activity的话怎么办呢。举个例来说，如果开启一个导游服务类的应用程序，里面有个Activity是开启GOOGLE地图的，当按下home键退回到主菜单又启动GOOGLE地图的应用时，显示的就是刚才的地图，实际上是同一个Activity，实际上这就引入了singleInstance。singleInstance模式就是将该Activity单独放入一个栈中，这样这个栈中只有这一个Activity，不同应用的intent都由这个Activity接收和展示，这样就做到了共享。当然前提是这些应用都没有被销毁，所以刚才是按下的HOME键，如果按下了返回键，则无效	
* android:multiprocess
	是否允许多进程，默认是false具体可看该篇文章：http://www.bangchui.org/simple/?t3181.html
* android:noHistory
	当用户从Activity上离开并且它在屏幕上不再可见时，Activity是否从Activity stack中清除并结束。默认是false。Activity不会留下历史痕迹
* android:screenOrientation	
	activity显示的模式默认为unspecified
	- unspecified：由系统自动判断显示方向
	- landscape横屏模式，宽度比高度大
	- portrait竖屏模式, 高度比宽度大
	- user模式，用户当前首选的方向
	- behind模式：和该Activity下面的那个Activity的方向一致(在Activity堆栈中的)
	- sensor模式：有物理的感应器来决定。如果用户旋转设备这屏幕会横竖屏切换
	- nosensor模式：忽略物理感应器，这样就不会随着用户旋转设备而更改了
* android:stateNotNeeded
	activity被销毁或者成功重启时是否保存状态
* android:windowSoftInputMode
	activity主窗口与软键盘的交互模式，可以用来避免输入法面板遮挡问题，Android1.5后的一个新特性
	各值的含义：
	- 当有焦点产生时，软键盘是隐藏还是显示
	- 是否减少活动主窗口大小以便腾出空间放软键盘
	- stateUnspecified：软键盘的状态并没有指定，系统将选择一个合适的状态或依赖于主题的设置
	- stateUnchanged：当这个activity出现时，软键盘将一直保持在上一个activity里的状态，无论是隐藏还是显示
	- stateHidden：用户选择activity时，软键盘总是被隐藏
	- stateAlwaysHidden：当该Activity主窗口获取焦点时，软键盘也总是被隐藏的
	- stateVisible：软键盘通常是可见的
	- stateAlwaysVisible：用户选择activity时，软键盘总是显示的状态
	- adjustUnspecified：默认设置，通常由系统自行决定是隐藏还是显示
	- adjustResize：该Activity总是调整屏幕的大小以便留出软键盘的空间
	- adjustPan：当前窗口的内容将自动移动以便当前焦点从不被键盘覆盖和用户能总是看到输入内容的部分		




### intent-filter

 Android中提供了Intent机制来协助应用间的交互与通讯，Intent负责对应用中一次操作的动作、动作涉及数据、附加数据进行描述，Android则根据此Intent的描述，负责找到对应的组件，将 Intent传递给调用的组件，并完成组件的调用。Intent不仅可用于应用程序之间，也可用于应用程序内部的Activity/Service之间的交互。因此，Intent在这里起着一个媒体中介的作用，专门提供组件互相调用的相关信息，实现调用者与被调用者之间的解耦。IntentFilter就是用于描述intent的各种属性， 比如action, category等.
```xml
<intent-filter  android:icon="drawable resource"
               android:label="string resource"
               android:priority="integer" >
      <action />
      <category />
      <data />
</intent-filter>
```

* android:priority
	(解释：有序广播主要是按照声明的优先级别，如A的级别高于B，那么，广播先传给A，再传给B。优先级别就是用设置priority属性来确定，范围是从-1000～1000，数越大优先级别越高)Intent filter内会设定的资料包括action,data与category三种。也就是说filter只会与intent里的这三种资料作对比动作

* action属性
	action很简单，只有android:name这个属性。常见的android:name值为android.intent.action.MAIN，表明此activity是作为应用程序的入口。有关android:name具体有哪些值，可参照这个网址：http://hi.baidu.com/linghtway/blog/item/83713cc1c2d053170ff477a7.html
* category属性
	category也只有android:name属性。常见的android:name值为android.intent.category.LAUNCHER(决定应用程序是否显示在程序列表里)有关android:name具体有哪些值，可参照这个网址：http://chroya.javaeye.com/blog/685871
* data属性
	每个<data>元素指定一个URI和数据类型（MIME类型）。它有四个属性scheme、host、port、path对应于URI的每个部分： scheme://host:port/path	



### meta-data
这是该元素的基本结构.可以包含在<activity> <activity-alias> <service> <receiver>四个元素中
```xml
<meta-data android:name="string"
           android:resource="resource specification"
           android:value="string"/>	
```
* android:name
	元数据项的名字，为了保证这个名字是唯一的，采用java风格的命名规范，如com.woody.project.fried
* android:resource
	资源的一个引用，指定给这个项的值是该资源的id。该id可以通过方法Bundle.getInt()来从meta-data中找到。
* android:value
	指定给这一项的值。可以作为值来指定的数据类型并且组件用来找回那些值的Bundle方法：[getString],[getInt],[getFloat],[getString],[getBoolean]

### activity-alias
为activity创建快捷方式的	
```xml
<activity-alias android:enabled=["true" | "false"]
                android:exported=["true" | "false"]
                android:icon="drawable resource"
                android:label="string resource"
                android:name="string"
                android:permission="string"
                android:targetActivity="string">

<intent-filter/> 
<meta-data/>
</activity-alias>
```

### service
service与activity同级，与activity不同的是，它不能自己启动的，运行在后台的程序，如果我们退出应用时，Service进程并没有结束，它仍然在后台运行。比如听音乐，网络下载数据等，都是由service运行的。

service生命周期：Service只继承了onCreate(),onStart(),onDestroy()三个方法，第一次启动Service时，先后调用了onCreate(),onStart()这两个方法，当停止Service时，则执行onDestroy()方法，如果Service已经启动了，当我们再次启动Service时，不会在执行onCreate()方法，而是直接执行onStart()方法

service与activity间的通信

Service后端的数据最终还是要呈现在前端Activity之上的，因为启动Service时，系统会重新开启一个新的进程，这就涉及到不同进程间通信的问题了(AIDL)，Activity与service间的通信主要用IBinder负责。具体可参照：http://zhangyan1158.blog.51cto.com/2487362/491358

```xml
<service android:enabled=["true" | "false"]
         android:exported[="true" | "false"]
         android:icon="drawable resource"
         android:label="string resource"
         android:name="string"
         android:permission="string"
         android:process="string">
</service>
```

### receiver
BroadcastReceiver（广播接收器），属于 Android 四大组件之一,在 Android 开发中，BroadcastReceiver 的应用场景非常多receive是静态注册BroadcastReceiver的。
```xml
<receiver 
    android:enabled=["true" | "false"]
//此broadcastReceiver能否接收其他App的发出的广播
//默认值是由receiver中有无intent-filter决定的：如果有intent-filter，默认值为true，否则为false
    android:exported=["true" | "false"]
    android:icon="drawable resource"
    android:label="string resource"
//继承BroadcastReceiver子类的类名
    android:name=".mBroadcastReceiver"
//具有相应权限的广播发送者发送的广播才能被此BroadcastReceiver所接收；
    android:permission="string"
//BroadcastReceiver运行所处的进程
//默认为app的进程，可以指定独立的进程
//注：Android四大基本组件都可以通过此属性指定自己的独立进程
    android:process="string" >

//用于指定此广播接收器将接收的广播类型
//本示例中给出的是用于接收网络状态改变时发出的广播
 <intent-filter>
<action android:name="android.net.conn.CONNECTIVITY_CHANGE" />
    </intent-filter>
</receiver>

```

### provider
ContentProvider一般为存储和获取数据提供统一的接口，可以在不同的应用程序之间共享数据
```xml
<provider android:authorities="list"
          android:enabled=["true" | "false"]
          android:exported=["true" | "false"]
          android:grantUriPermissions=["true" | "false"]
          android:icon="drawable resource"
          android:initOrder="integer"
          android:label="string resource"
          android:multiprocess=["true" | "false"]
          android:name="string"
          android:permission="string"
          android:process="string"
          android:readPermission="string"
          android:syncable=["true" | "false"]
          android:writePermission="string">
           <grant-uri-permission/>
           <meta-data/>
</provider>
```
* android:authorities
	标识这个ContentProvider，调用者可以根据这个标识来找到它
* android:grantUriPermission：
	对某个URI授予的权限
* android:initOrder
* android:exported 
	设置此provider是否可以被其他应用使用。
* android:readPermission 
	该provider的读权限的标识
* android:writePermission 
	该provider的写权限标识
* android:permission 
	provider读写权限标识
* android:grantUriPermissions 
	临时权限标识，true时，意味着该provider下所有数据均可被临时使用；false时，则反之，但可以通过设置<grant-uri-permission>标签来指定哪些路径可以被临时使用。这么说可能还是不容易理解，我们举个例子，比如你开发了一个邮箱应用，其中含有附件需要第三方应用打开，但第三方应用又没有向你申请该附件的读权限，但如果你设置了此标签，则可以在start第三方应用时，传入FLAG_GRANT_READ_URI_PERMISSION或FLAG_GRANT_WRITE_URI_PERMISSION来让第三方应用临时具有读写该数据的权限。



### uses-library
用户库，可自定义。所有android的包都可以引用


### supports-screens
这是在android1.6以后的新特性，支持多屏幕机制各属性含义：这四个属性，是否支持大屏，是否支持中屏，是否支持小屏，是否支持多种不同密度	
```xml
<supports-screens  android:smallScreens=["true" | "false"] 
                  android:normalScreens=["true" | "false"] 
                  android:largeScreens=["true" | "false"] 
                  android:anyDensity=["true" | "false"] />
```

### uses-configuration/uses-feature
这两者都是在描述应用所需要的硬件和软件特性，以便防止应用在没有这些特性的设备上安装。
```xml
<uses-configuration  android:reqFiveWayNav=["true" | "false"] 
                    android:reqHardKeyboard=["true" | "false"]
                    android:reqKeyboardType=["undefined" | "nokeys" | "qwerty" |   "twelvekey"]
                    android:reqNavigation=["undefined" | "nonav" | "dpad" |  "trackball" | "wheel"]
                    android:reqTouchScreen=["undefined" | "notouch" | "stylus" | "finger"] />

<uses-feature android:glEsVersion="integer"
              android:name="string"
              android:required=["true" | "false"] />
```


### uses-sdk
描述应用所需的api level，就是版本，目前是android 2.2 = 8，android2.1 = 7，android1.6 = 4，android1.5=3在此属性中可以指定支持的最小版本，目标版本以及最大版本
```xml
<uses-sdk android:minSdkVersion="integer"
          android:targetSdkVersion="integer"
          android:maxSdkVersion="integer"/>
```

### instrumentation 
定义一些用于探测和分析应用性能等等相关的类，可以监控程序。在各个应用程序的组件之前instrumentation类被实例化android:functionalTest(解释：instrumentation类是否能运行一个功能测试，默认为false)
```xml
<instrumentation android:functionalTest=["true" | "false"]
                 android:handleProfiling=["true" | "false"]
                 android:icon="drawable resource"
                 android:label="string resource"
                 android:name="string"
                 android:targetPackage="string"/>

```
### permission/uses-permission/permission-tree/permission-group
最常用的当属<uses-permission>，当我们需要获取某个权限的时候就必须在我们的manifest文件中声明，此<uses-permission>与<application>同级，具体权限列表请看此处
通常情况下我们不需要为自己的应用程序声明某个权限，除非你提供了供其他应用程序调用的代码或者数据。这个时候你才需要使用<permission> 这个标签。很显然这个标签可以让我们声明自己的权限。比如：
```xml
<permission android:name="com.teleca.project.MY_SECURITY" . . . />
```
当然自己声明的permission也不能随意的使用，还是需要使用<uses-permission>来声明你需要该权限<permission-group> 就是声明一个标签，该标签代表了一组permissions，而<permission-tree>是为一组permissions声明了一个namespace。这两个标签可以看之前的系列文章。


## 实例
下面是一个从APP中提取出来的文件样本
```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.opslab.app">

    <uses-permission android:name="android.permission.READ_PROFILE" />

    <uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
    <uses-permission android:name="android.permission.GET_EXPORTED" />
    <permission
        android:name="com.qhmcc.permission.GET_EXPORTED"
        android:label="APPNAME"
        android:protectionLevel="normal" />
    <uses-permission android:name="android.permission.BLUETOOTH" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />


    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
    <!-- wifi lock use -->
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <!-- Allows an application to write to external storage -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <!-- WiFi -->
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
    <!-- location -->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <!--<uses-permission android:name="android.permission.WRITE_SMS" />-->
    <!--<uses-permission android:name="android.permission.SEND_SMS" />-->
    <!--<uses-permission android:name="android.permission.READ_SMS" />-->
    <uses-permission android:name="android.permission.READ_CONTACTS" />
    <uses-permission android:name="android.permission.WRITE_CONTACTS" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.DISABLE_KEYGUARD" />
    <uses-permission android:name="android.permission.WRITE_SETTINGS" />
    <uses-permission android:name="android.permission.SYSTEM_OVERLAY_WINDOW" />
    <uses-permission android:name="android.permission.READ_LOGS" />
    <uses-permission android:name="android.permission.READ_CALL_LOG" />
    <uses-permission android:name="android.permission.WRITE_CALL_LOG" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.CHANGE_CONFIGURATION" />
    <uses-permission android:name="android.permission.CALL_PHONE" />
    <!--<uses-permission android:name="android.permission.PROCESS_OUTGOING_CALLS" />-->
    <!--<uses-permission android:name="android.permission.RECORD_AUDIO" />-->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.GET_TASKS" />

    <application
        android:name=".DaggerApplication"
        android:allowBackup="false"
        android:debuggable="false"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/AppTheme"
        tools:ignore="HardcodedDebugMode"
        tools:replace="android:allowBackup">
        <activity
            android:name=".ui.activity.MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:screenOrientation="portrait"
            android:theme="@style/AppStartLoad">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

            <intent-filter>
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />

                <data
                    android:host="qhmonitor"
                    android:scheme="qhmonitorapp" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />

                <data android:scheme="qhmonitorapp" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.DEFAULT" />

                <data android:scheme="wxd930ea5d5a258f4f" />
            </intent-filter>
        </activity>

        <activity
            android:name=".ui.activity.LoginActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name=".ui.activity.WebActivity"
            android:configChanges="orientation|screenSize|keyboardHidden"
            android:launchMode="singleTop"
            android:screenOrientation="portrait"
            android:windowSoftInputMode="stateHidden|adjustResize" />
        <activity
            android:name=".ui.activity.communicate.CommunicateActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name=".ui.activity.communicate.GroupDetailsActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name=".ui.activity.communicate.GroupListActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name=".ui.activity.communicate.EditCommunicateActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name=".ui.activity.communicate.ContactsDetailsActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name=".ui.activity.communicate.SelectUserGroupActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name=".ui.activity.ScanResultActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name=".ui.activity.MessageCenterActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name=".ui.activity.ResetPassWordActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name=".ui.activity.ChangePassWordActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name=".ui.activity.PayResultActivity"
            android:launchMode="singleTop"
            android:screenOrientation="portrait" />
        <activity
            android:name="com.tencent.smtt.sdk.VideoActivity"
            android:alwaysRetainTaskState="true"
            android:configChanges="orientation|screenSize|keyboardHidden"
            android:exported="false"
            android:launchMode="singleTask">
            <intent-filter>
                <action android:name="com.tencent.smtt.tbs.video.PLAY" />

                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>
        </activity>

        <activity
            android:name="com.mob.tools.MobUIShell"
            android:configChanges="keyboardHidden|orientation|screenSize"
            android:theme="@android:style/Theme.Translucent.NoTitleBar"
            android:windowSoftInputMode="stateHidden|adjustResize">

            <intent-filter>
                <action android:name="com.sina.weibo.sdk.action.ACTION_SDK_REQ_ACTIVITY" />

                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>
        </activity>
        <activity
            android:name="cn.sharesdk.tencent.qq.ReceiveActivity"
            android:launchMode="singleTask"
            android:noHistory="true">

            <intent-filter>
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.BROWSABLE" />
                <category android:name="android.intent.category.DEFAULT" />

                <data android:scheme="tencent1105152704" />
            </intent-filter>
        </activity>
        <activity
            android:name=".wxapi.WXEntryActivity"
            android:configChanges="keyboardHidden|orientation|screenSize"
            android:exported="true"
            android:screenOrientation="portrait"
            android:theme="@android:style/Theme.Translucent.NoTitleBar" />

        <meta-data
            android:name="com.opslab.app.util.GlideConfiguration"
            android:value="GlideModule"/>


        <receiver
            android:name="com.opslab.app.ui.notification.NotificationReceiver"
            android:permission="com.qhmcc.permission.GET_EXPORTED"
            android:process=":remote" >

            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED" />
                <action android:name="com.xwtec.ui.notificationi.NotificationReceiver" />
            </intent-filter>
        </receiver>


    </application>

</manifest>

```