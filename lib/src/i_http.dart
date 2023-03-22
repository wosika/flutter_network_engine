import 'package:dio/dio.dart';
import 'i_result.dart';

///网络请求成功,并且服务端code 返回值成功 object
typedef OnSuccess<T> = Function(T t);

///网络请求成功,并且服务端code 返回值成功 list
typedef OnSuccessList<T> = Function(List<T>? list);

///请求失败
typedef OnError = Function(int? code, String? msg);

///创建基类数据
typedef OnResult = Function<T>(T? t, [dynamic error]);

typedef OnShowLoading = Function(bool isShow, [String? msg]);

abstract class IHttp {
  void init(
      {OnShowLoading? onShowLoading,
      Function(String? message)? onShowError,
      OnResult? onResult});

  void destroy();

  void setBaseUrl(String url);

  Future<void> request<T>(
    String method,
    String url, {
    Map<String, dynamic>? queryParameters,
    bool isList,
    Options? options,
    CancelToken? cancelToken,
    OnSuccess<T?>? onSuccess,
    OnSuccessList<T>? onSuccessList,
    OnError? onError,
  });

  Future<IResult<T>> requestFuture<T>(String method, String url,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken});
}
