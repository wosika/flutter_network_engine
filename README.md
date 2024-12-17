# flutter_network_engine

A network request framework based on Dio for Flutter applications.

[中文文档](README_CN.md)

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
    flutter_network_engine: ^0.1.0
```

## Basic Configuration

### Initialize Network Engine

```dart
var dioHttpEngine = DioHttpEngine(
    // Network request timeout
    timeout: const Duration(seconds: 8),
    // Base URL for all requests
    baseUrl: "your base url", 
    // JSON parsing function
    jsonParser: ModelFactory.generateOBJ,
    // Enable logging
    printLog: true,
    // Error handling callback
    onShowError: ({int? code, String? msg, dynamic error}) {},
    // Loading state callback
    onShowLoading: (bool isShow, {String? msg}) {}
);
```

### Customize Response Handling

You can customize how responses are processed:

```dart
// Custom status code handling
ResponseResult.onGetCode = (ResponseResult result, Type dataType) {
    return result.response?.statusCode;
};

// Custom message handling
ResponseResult.onGetMessage = (ResponseResult result, Type dataType) {
    return result.response?.statusMessage;
};

// Custom success criteria
ResponseResult.onIsSuccess = (ResponseResult result, Type dataType) {
    return result.response?.statusCode != null &&
           result.response!.statusCode! >= 200 &&
           result.response!.statusCode! < 300;
};
```

### Add Interceptors

```dart
// Example of adding a logger interceptor
dioHttpEngine.addInterceptor(TalkerDioLogger(
    settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
    ),
));
```

## Usage Examples

### Making Network Requests

```dart
// GET request example
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

// Get response data
var data = resp.getData();
```

### Error Handling

The framework provides built-in error handling capabilities through the `onShowError` callback. You can customize how errors are presented to users:

```dart
DioHttpEngine(
    // ... other configurations
    onShowError: ({int? code, String? msg, dynamic error}) {
        // Handle error based on code or message
        if (code == 404) {
            // Handle not found error
        } else if (code == 401) {
            // Handle unauthorized error
        }
        // Show error message to user
    }
);
```

### Loading States

Handle loading states during network requests:

```dart
DioHttpEngine(
    // ... other configurations
    onShowLoading: (bool isShow, {String? msg}) {
        if (isShow) {
            // Show loading indicator
            // You can use the optional message parameter
        } else {
            // Hide loading indicator
        }
    }
);
```

## Features

- Easy to integrate and use
- Customizable response handling
- Built-in error handling
- Loading state management
- Support for interceptors
- Type-safe response parsing
- Configurable timeout and base URL
- Comprehensive logging options

## Advanced Usage

For more advanced usage examples and complete implementation details, please refer to the [example](example/lib/main.dart) in the repository.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
