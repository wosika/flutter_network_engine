import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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
  Function(String?)? _showError;
  JsonParser? _jsonParser;

  DioHttpEngine({
    Duration? timeout,
    String? baseUrl,
    bool? printLog,
    OnShowLoading? onShowLoading,
    Function(String? message)? onShowError,
    JsonParser? jsonParser
  }) {
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
  @Deprecated("目前baseUrl通过拦截器实现,请勿直接设置") //目前baseUrl通过拦截器实现,请勿直接设置
  void setBaseUrl(String url) {
    _dio!.options.baseUrl = url;
  }

  @override
  Future<void> request<T>(String method, String url,
      {Map<String, dynamic>? queryParameters,
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
      onError?.call(respModel.getCode(), respModel.getMessage());
    }
  }

  @override
  Future<ResponseResult<T>> requestFuture<T>(RequestMethod method, String url,
      {Map<String, dynamic>? queryParameters,
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
      _showLoading?.call(true, loadingText);
    }
    try {
      Response response = await _dio!.request(url,
          queryParameters: method == 'get' ? queryParameters : null,
          data: method == 'post' ? queryParameters : null,
          options: options ?? Options(method: method.name),
          cancelToken: cancelToken);
      return ResponseResult<T>(response: response,jsonParser: _jsonParser);
    } on DioError catch (e) {
      if (_printLog && e.type != DioErrorType.cancel) {
        log("网络请求错误", error: e);
      }
      //是取消的请求不显示错误提示
      if (e.type != DioErrorType.cancel && (isShowError)) {
        _showError?.call(errorText ?? _getErrorDes(e));
      }
      return ResponseResult<T>(error: e,jsonParser: _jsonParser);
    } catch (e) {
      if (_printLog) {
        log("网络请求错误", error: e);
      }
      if (isShowError) {
        _showError?.call(errorText ?? e.toString());
      }
      return ResponseResult<T>(error: e,jsonParser: _jsonParser);
    } finally {
      if (isShowLoading) {
        _showLoading?.call(false);
      }
    }
  }

  Future<ResponseResult<T>> getFuture<T>(String url,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      bool isShowLoading = false,
      bool isShowError = false,
      String? loadingText,
      String? errorText}) {
    return requestFuture(RequestMethod.get, url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        isShowError: isShowError,
        isShowLoading: isShowLoading,
        loadingText: loadingText,
        errorText: errorText);
  }

  Future<ResponseResult<T>> postFuture<T>(String url,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      bool isShowLoading = false,
      bool isShowError = false,
      String? loadingText,
      String? errorText}) {
    return requestFuture(RequestMethod.post, url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        isShowError: isShowError,
        isShowLoading: isShowLoading,
        loadingText: loadingText,
        errorText: errorText);
  }

  void post<T>(String url,
      {Map<String, dynamic>? queryParameters,
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
    request<T>("post", url,
        queryParameters: queryParameters,
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
    request<T>("get", url,
        queryParameters: queryParameters,
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

  static String? _getErrorDes(DioError error) {
    String? errorDes = '';
    switch (error.type) {
      case DioErrorType.cancel:
        errorDes = '请求取消';
        break;
      case DioErrorType.connectionTimeout:
        errorDes = '连接超时';
        break;
      case DioErrorType.sendTimeout:
        errorDes = '请求超时';
        break;
      case DioErrorType.receiveTimeout:
        errorDes = '响应超时';
        break;
      case DioErrorType.badResponse:
        {
          try {
            errorDes = error.response!.data != null
                ? _getErrorInfo(jsonDecode(error.response!.data))
                : error.response!.data;
          } on Exception catch (_) {
            errorDes = '未知错误';
          }
        }
        break;
      case DioErrorType.unknown:
        {
          if (error.error is SocketException) {
            errorDes = '网络请求错误';
          } else {
            errorDes = '未知错误';
          }
          break;
        }
      default:
        errorDes = '未知错误';
        break;
    }

    return errorDes;
  }

  static String _getErrorInfo(Map<String, dynamic> data) {
    return "";
  }
}
