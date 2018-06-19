应用入口 

(new yii\web\Application($config))


###继承关系
```flow

yii\web\Application ->  yii\base\Application -> yii\base\Module


-> yii\di\ServiceLocator -> yii\base\Component -> yii\base\BaseObject

```


##1、初始化：
###yii\base\Application初始化，

$application 已经被实例化出来了
复制 自己引用 到 \yii::$app
状态 开始

预处理 preInit $config

检查 应用 id,basePath,vendorPath,runtimePath,timeZone,container

核心组件 coreComponents

'log'
'view' 
'formatter'
'i18n'
'mailer'
'urlManager' 
'assetManager'
'security'

'request' ,
'response',
'session'
'user'
'errorHandler'


注册
实例化 错误处理
错误处理 errorHandler 组件


###构造函数 在BaseObject

BaseObject 处理所有$config，将$config 对应的名称值赋值给 $application.

其中 
ServiceLocator 记录下components中的所有配置，仅仅记录配置_definitions，
并未实例化，components，当需要的时候，get时候，没有就再实例，实现惰性加载。


yii\base\Application
init()

状态 STATE_INIT

web\Application ->bootstrap()

获取 $request 对象，这里应该是第一次被实例化
设置 webroot
设置 web

base\Application bootstrap()

加载 yii拓展配置 yii /extensions.php，加载其中的文件

可以给路径设置别名

对配置中的 bootstrap 进行实例化，
bootstrap 可以是 回调，可以是组件，
回调的结果可以是BootstrapInterface 接口对象

如果是则调用 该对象的bootstrap()方法


##2、run()


状态 STATE_BEFORE_REQUEST
触发 EVENT_BEFORE_REQUEST 事件

状态 STATE_HANDLING_REQUEST

处理请求 ｛内容｝

状态 STATE_AFTER_REQUEST
触发 EVENT_AFTER_REQUEST

状态 STATE_SENDING_RESPONSE
发送 send() 
状态 STATE_END


监听 捕获 ExitException 异常

baseApplication  end()

如果状态 在请求之前STATE_BEFORE_REQUEST，触发事件EVENT_AFTER_REQUEST

如果状态在响应之后，则发送 response

否则抛出退出异常



### 异常处理的绑定

errorHandler 组件