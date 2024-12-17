# flutter_network_engine
[![Pub](https://img.shields.io/pub/v/flutter_network_engine.svg)](https://pub.dev/packages/flutter_network_engine)  
基于Dio实现的网络请求框架

[English](README.md)

## 安装

在 pubspec.yaml 中添加依赖：

```yaml
dependencies:
    flutter_network_engine: ^0.1.2
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

### 错误处理

框架提供了内置的错误处理功能，通过 `onShowError` 回调来自定义错误展示方式：

```dart
DioHttpEngine(
    // ... 其他配置
    onShowError: ({int? code, String? msg, dynamic error}) {
        // 根据错误码或消息处理错误
        if (code == 404) {
            // 处理未找到错误
        } else if (code == 401) {
            // 处理未授权错误
        }
        // 向用户展示错误信息
    }
);
```

### 加载状态管理

处理网络请求过程中的加载状态：

```dart
DioHttpEngine(
    // ... 其他配置
    onShowLoading: (bool isShow, {String? msg}) {
        if (isShow) {
            // 显示加载指示器
            // 可以使用可选的消息参数
        } else {
            // 隐藏加载指示器
        }
    }
);
```

## 特性

- 易于集成和使用
- 可自定义响应处理
- 内置错误处理
- 加载状态管理
- 支持拦截器
- 类型安全的响应解析
- 可配置的超时和基础 URL
- 完整的日志选项

## 高级用法

更多高级用法示例和完整的实现细节，请参考仓库中的 [示例代码](example/lib/main.dart)。

## 贡献

欢迎提交 Pull Request 来改进这个项目！
