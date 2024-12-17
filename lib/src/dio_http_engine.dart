import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_network_engine/src/request_type.dart';
import 'i_http.dart';
import 'i_result.dart';

class DioHttpEngine extends IHttp {
  Dio? _dio;
  Duration _timeout = const Duration(seconds: 8000);
  String _baseUrl = "";
  bool _printLog = true;
  OnShowLoading? _showLoading;
  OnError? _showError;
  JsonParser? _jsonParser;

  DioHttpEngine(
      {Duration? timeout,
      String? baseUrl,
      bool? printLog,
      OnShowLoading? onShowLoading,
      OnError? onShowError,
      JsonParser? jsonParser}) {
    if (timeout != null) {
      _timeout = timeout;
    }
    if (baseUrl != null) {
      _baseUrl = baseUrl;
    }
    if (printLog != null) {
      _printLog = printLog;
    }

    _showLoading = onShowLoading;
    _showError = onShowError;
    _jsonParser = jsonParser;

    _dio = _initDio();
  }

  void addInterceptor(Interceptor interceptor) {
    _dio!.interceptors.add(interceptor);
  }

  Dio _initDio() {
    Dio dio = Dio(BaseOptions(
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
      sendTimeout: _timeout,
      baseUrl: _baseUrl,
      responseType: ResponseType.plain,
    ));

    return dio;
  }

  Dio? getDio() {
    return _dio;
  }

  @override
  Future<void> request<T>(RequestMethod method, String url,
      {Map<String, dynamic>? queryParameters,
      Object? data,
      bool isList = false,
      Options? options,
      CancelToken? cancelToken,
      OnSuccess<T?>? onSuccess,
      OnSuccessList<T>? onSuccessList,
      OnError? onError,
      bool isShowLoading = false,
      bool isShowError = false,
      String? loadingText,
      String? errorText}) async {
    var respModel = await requestFuture<T>(method, url,
        queryParameters: queryParameters,
        data: data,
        options: options,
        cancelToken: cancelToken,
        isShowLoading: isShowLoading,
        isShowError: isShowError,
        loadingText: loadingText,
        errorText: errorText);

    if (respModel.isSuccess()) {
      if (isList) {
        onSuccessList?.call(respModel.getListData());
      } else {
        onSuccess?.call(respModel.getData());
      }
    } else {
      onError?.call(code: respModel.getCode(), msg: respModel.getMessage());
    }
  }

  @override
  Future<ResponseResult<T>> requestFuture<T>(RequestMethod method, String url,
      {Map<String, dynamic>? queryParameters,
      Object? data,
      Options? options,
      CancelToken? cancelToken,
      bool isShowLoading = false,
      bool isShowError = false,
      String? loadingText,
      String? errorText}) async {
    if (options != null) {
      options.method = method.name;
    }

    if (isShowLoading) {
      _showLoading?.call(true, msg: loadingText);
    }
    try {
      Response response = await _dio!.request(url,
          queryParameters: queryParameters,
          data: data,
          options: options ?? Options(method: method.name),
          cancelToken: cancelToken);
      return ResponseResult<T>(response: response, jsonParser: _jsonParser);
    } on DioException catch (e) {
      if (_printLog && e.type != DioExceptionType.cancel) {
        log("network request error", error: e);
      }
      //是取消的请求不显示错误提示
      if (e.type != DioExceptionType.cancel && (isShowError)) {
        _showError?.call(
          code: e.response?.statusCode,
          msg: e.response?.statusMessage,
          error: e.message,
        );
      }
      return ResponseResult<T>(error: e, jsonParser: _jsonParser);
    } catch (e) {
      if (_printLog) {
        log("network request error", error: e);
      }
      if (isShowError) {
        _showError?.call(
          code: -1,
          msg: e.toString(),
          error: e,
        );
      }
      return ResponseResult<T>(error: e, jsonParser: _jsonParser);
    } finally {
      if (isShowLoading) {
        _showLoading?.call(false);
      }
    }
  }

  Future<ResponseResult<T>> getFuture<T>(String url,
      {Map<String, dynamic>? queryParameters,
      Object? data,
      Options? options,
      CancelToken? cancelToken,
      bool isShowLoading = false,
      bool isShowError = false,
      String? loadingText,
      String? errorText}) {
    return requestFuture<T>(RequestMethod.get, url,
        queryParameters: queryParameters,
        data: data,
        options: options,
        cancelToken: cancelToken,
        isShowError: isShowError,
        isShowLoading: isShowLoading,
        loadingText: loadingText,
        errorText: errorText);
  }

  Future<ResponseResult<T>> postFuture<T>(String url,
      {Map<String, dynamic>? queryParameters,
      Object? data,
      Options? options,
      CancelToken? cancelToken,
      bool isShowLoading = false,
      bool isShowError = false,
      String? loadingText,
      String? errorText}) {
    return requestFuture<T>(RequestMethod.post, url,
        queryParameters: queryParameters,
        data: data,
        options: options,
        cancelToken: cancelToken,
        isShowError: isShowError,
        isShowLoading: isShowLoading,
        loadingText: loadingText,
        errorText: errorText);
  }

  void post<T>(String url,
      {Map<String, dynamic>? queryParameters,
      Object? data,
      bool isList = false,
      Options? options,
      CancelToken? cancelToken,
      OnSuccess<T?>? onSuccess,
      OnSuccessList<T?>? onSuccessList,
      OnError? onError,
      bool isShowLoading = false,
      bool isShowError = false,
      String? loadingText,
      String? errorText}) {
    request<T>(RequestMethod.post, url,
        queryParameters: queryParameters,
        data: data,
        isList: isList,
        options: options,
        cancelToken: cancelToken,
        onSuccess: onSuccess,
        onSuccessList: onSuccessList,
        onError: onError,
        isShowError: isShowError,
        isShowLoading: isShowLoading,
        loadingText: loadingText,
        errorText: errorText);
  }

  void get<T>(String url,
      {Map<String, dynamic>? queryParameters,
      Object? data,
      bool isList = false,
      Options? options,
      CancelToken? cancelToken,
      OnSuccess<T?>? onSuccess,
      OnSuccessList<T?>? onSuccessList,
      OnError? onError,
      bool isShowLoading = false,
      bool isShowError = false,
      String? loadingText,
      String? errorText}) {
    request<T>(RequestMethod.get, url,
        queryParameters: queryParameters,
        data: data,
        isList: isList,
        options: options,
        cancelToken: cancelToken,
        onSuccess: onSuccess,
        onSuccessList: onSuccessList,
        onError: onError,
        isShowError: isShowError,
        isShowLoading: isShowLoading,
        loadingText: loadingText,
        errorText: errorText);
  }

  @override
  void destroy() {
    _dio?.close();
  }
}
