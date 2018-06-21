应用入口 yii 源码解读

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

### 请求处理
web\Application  handleRequest($request)

* 1、维护页面
    如果设置了 catchAll 变量, 那么所有请求都会跳转到这里
    示例:
    假设网站维护, 需要将网站重定向到一个设置好的页面上
    可以在配置文件中添加
    'catchAll' => ['offline/index']
    这样, 所有的访问都跳转到 offline/index 页面了

* 2、正常页面
   解析请求 request 

    组件 urlmanager
    Yii::$app->urlManager->parseRequest()
   获取 路由route  和参数 param
    
    解析路由时候捕获UrlNormalizerRedirectException 异常
    处理是 将左'/'去掉 再重定向请求


 结果 对 路由 和参数  调用module->runAction(路由,参数)

如果 返回结果是 数组 则将 该数组赋值给 response ->data
如果是  response 对象直接返回
返回 response 对象

此步骤 捕获InvalidRouteException 异常，
并抛出 NotFoundHttpException  404异常，


### 路由解析

#### 初始化
  根据配置

  1、如果配置了normalizer 
规范化url，则创建 规范化url对象

    [
      'class' => 'yii\web\UrlNormalizer',
      'collapseSlashes' => true,
      'normalizeTrailingSlash' => true,
    ]

2、缓存
将路由规则存到缓存当中，并提取摘要生成md5，如果 有新的规则，则重新生成

3、构建 规则 buildRules($rules);
        遍历规则$rules as $key => $rule
   1、如果 $rule是字符串 
   匹配 key
```   
^((?:(GET|HEAD|POST|PUT|PATCH|DELETE|OPTIONS),)*(GET|HEAD|POST|PUT|PATCH|DELETE|OPTIONS))\\s+(.*)$
```
什么意思 ，将请求动作匹配下来
举个例子
规则中 有一条

```
 'GET,POST testM'=>'test/insert-million',
```

匹配数组为:
```
    0 => 'GET,POST testM'
    1 => 'GET,POST'
    2 => 'GET'
    3 => 'POST'
    4 => 'testM'
```

记录动作，GET,POST 
和 规则test/insert-million

构成 数组 
```
    [
        'class'=>'yii\web\UrlRule',
        'route'=>'test/insert-million',
        'pattern'=>'testM',
        'verb'=>['GET','POST'],
    ]
```
 实例化 一个对象 返回实例化规则数组
yii\web\UrlRule 默认的规则对象
初始化
parttern 必须  
route    必须
normalizer 数组的话则 创建对象
verb     数组的话则 转成大写
name     空的话 与parttern 相等


执行 预处理
preparePattern()


先将 pattern 的斜线去掉 ,但是双斜线不管
trimSlashes()
例如 

    //asjfkls/asdkfj/asdsa/     ->  //asjfkls/asdkfj/asdsa   
    /asjfkls/asdkfj/asdsa/      ->  asjfkls/asdkfj/asdsa

去掉 route 的前后斜线 例如
    
    //asjfkls/asdkfj/asdsa/     -> asjfkls/asdkfj/asdsa
    /asjfkls/asdkfj/asdsa/     -> asjfkls/asdkfj/asdsa

如果 

host 不全为空  去掉 host 的右边 斜线 


#### 解析

 Yii::$app->urlManager->parseRequest($request)

urlManager 会先判断 enablePrettyUrl
是否开启url美化
开启则 解析

 遍历每个规则
yii\web\UrlRule
parseRequest($manager, $request)





如果没有开启则 直接 从 $request 取 r 的参数 作为路由



### runAction(路由,参数)

 module  createController(路由)
 #### 创建控制器(路由)

取 路由前两个 由 '/' 分隔的字符串 分别id, route
路由空则取默认路由

如果配置 controllerMap 并且匹配 id 
  则根据配置，创建该 控制器

如果配置了 module 并且匹配 id
    则获取 module 对象，并且 把route 作为id
    再调用 createController


调用    createControllerID 内根据 controllerNamespace 和 id 
拼接出 控制器全名，实例化并返回控制器对象或null


* 因此如果有 控制器与 模块重名，这里解析是先实例化模块，然后在 模块下面找，如果模块下面没有该控制器则返回找不到。*

返回 控制器对象 和 控制器和去掉控制器名称的路由之外的 route (就是动作名)


控制器 controller->runAction($actionID, $params)

创建 动作

createAction($actionID);
$actionID 为空则默认为index

动作列表为actions()
动作列表里面有$actionID 则以自身作为参数创建 ， 这是外部类需要继承 base\Action


内联动作，获取动作名 id 与 action 拼接字符串，如果存在 不是直接调用，
而是 new 一个内联动作 ，以控制器，方法作为参数 返回 InlineAction 对象


*注意:这里会抛出 InvalidRouteException 异常 动作方法不存在


beforeAction 调用

获取 所有的 相关 模块 按照继承 与 module的关系 ，并调用模块的 beforeAction 方法


例如  控制器下 index 不属于模块 
则调用 ```'yii\\web\\Application' ```的beforeAction
 
如  控制器属于 system 模块，则依次调用，总的来说是根据 关系来进行 调用，
关键是 module 属性，可以让调用达到无限

```
0 => 'yii\\web\\Application'
1 => 'admin\\modules\\system\\Module'
```
记录下来 模块 对象 
稍后 以同样的方式 调用 afterAction

再调用 控制器的
的beforeAction

调用控制器的bindActionParams()  web 是这样的 
绑定 动作参数 ，主要是 利用 反射，
获取到方法的参数名称，如果$params中有该键为该名称的值，则
将该参数记录 
没有值的情况下，有默认值，设置默认值
这里会抛出BadRequestHttpException 异常 ，主要是无此参数 或者
是参数类型不对

还有 console 
区别在于,console 是按照 参数的顺序 赋值 而不是名称

调用 动作对象的 runWithParams($params)
如果是外联 动作 则调用 run 方法
如果是内联对象，则调用控制器的 的方法
调用 控制器中的 动作方法，并附加绑定好的参数
这样 

调用 afterAction

返回结果



## beforAction
 会按照 Application  beforAction 再到 module 中的beforAction 再到控制器中
 的 beforAction 在
 外联 会运行 before run
 内联 运行 无 


 逐个分析

在module 也就是  application 中的 beforAction
 beforAction 触发 EVENT_BEFORE_ACTION事件，如果绑定了该事件，触发该事件


base controller beforeAction  触发EVENT_BEFORE_ACTION 事件
 web controller  beforeAction
 判断 
 如果开启了enableCsrfValidation
 并且 无异常抛出 
 验证 csrf 

afterAction  也都是触发 事件


### 视图 view
