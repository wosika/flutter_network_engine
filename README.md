## 网络请求框架
基于Dio实现的网络请求框架

##简单使用：
#使用示例可以参考example中

```
//初始化

var dioHttpEngine = DioHttpEngine(
    //网络请求超时时间
    timeout: const Duration(seconds: 8),
    //基类url
    baseUrl: "https://apis.juhe.cn", 
    //json解析函数
    jsonParser: ModelFactory.generateOBJ ,
    //是否显示log
    printlog:true,
    //网络请求错误提示函数
    onShowError: (String? message)=>{},
    //网络请求加载中提示函数

    onShowLoading: (bool isShow,[String? message])=>{}
  ));


```
