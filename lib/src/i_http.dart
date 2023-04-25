import 'package:dio/dio.dart';
import 'package:flutter_network_engine/src/request_type.dart';

import 'i_result.dart';

///网络请求成功,并且服务端code 返回值成功 object
typedef OnSuccess<T> = Function(T t);

///网络请求成功,并且服务端code 返回值成功 list
typedef OnSuccessList<T> = Function(List<T>? list);

///请求失败
typedef OnError = Function(int? code, String? msg);

typedef OnShowLoading = Function(bool isShow, [String? msg]);

//json解析函数
typedef JsonParser = T? Function<T>(dynamic json);

abstract class IHttp {
  void destroy();

  void setBaseUrl(String url);

  Future<void> request<T>(
    RequestMethod method,
    String url, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    bool isList,
    Options? options,
    CancelToken? cancelToken,
    OnSuccess<T?>? onSuccess,
    OnSuccessList<T>? onSuccessList,
    OnError? onError,
  });

  Future<ResponseResult<T>> requestFuture<T>(RequestMethod method, String url,
      {Map<String, dynamic>? queryParameters,
      Object? data,
      Options? options,
      CancelToken? cancelToken});
}
