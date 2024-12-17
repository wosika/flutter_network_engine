# flutter_network_engine
基于Dio实现的网络请求框架

[English](README.md)

## 安装

在 pubspec.yaml 中添加依赖：

```yaml
dependencies:
    flutter_network_engine: ^0.1.0
```

## 基础配置

### 初始化网络引擎

```dart
var dioHttpEngine = DioHttpEngine(
    //网络请求超时时间
    timeout: const Duration(seconds: 8),
    //基类url
    baseUrl: "your base url", 
    //json解析函数
    jsonParser: ModelFactory.generateOBJ,
    //是否显示log
    printLog: true,
    //网络请求错误提示函数
    onShowError: ({int? code, String? msg, dynamic error}) {},
    //网络请求加载中提示函数
    onShowLoading: (bool isShow, {String? msg}) {}
);
```

### 自定义响应处理

你可以自定义响应结果的处理方式：

```dart
// 自定义响应码获取
ResponseResult.onGetCode = (ResponseResult result, Type dataType) {
    return result.response?.statusCode;
};

// 自定义消息获取
ResponseResult.onGetMessage = (ResponseResult result, Type dataType) {
    return result.response?.statusMessage;
};

// 自定义成功判断
ResponseResult.onIsSuccess = (ResponseResult result, Type dataType) {
    return result.response?.statusCode != null &&
           result.response!.statusCode! >= 200 &&
           result.response!.statusCode! < 300;
};
```

### 添加拦截器

```dart
// 添加日志拦截器示例
dioHttpEngine.addInterceptor(TalkerDioLogger(
    settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
    ),
));
```

## 使用示例

### 发起网络请求

```dart
// GET 请求示例
String url = "https://api.example.com/data";
var param = {"key": "value"};
var resp = await dioHttpEngine.requestFuture<YourModel>(
    RequestMethod.get, 
    url,
    options: Options(
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
    ),
    queryParameters: param
);

// 获取响应数据
var data = resp.getData();
```

更多使用示例请参考 [example](example/lib/main.dart)
