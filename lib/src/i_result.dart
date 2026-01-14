import 'dart:convert';
import 'dart:developer';
import 'package:flutter_network_engine/flutter_network_engine.dart';

mixin IResult<T> {
  //网络请求是否成功
  bool isSuccess();

  //获取code
  int? getCode();

  //获取数据
  T? getData();

  //获取集合数据
  List<T>? getListData();

  //获取任意类型的错误
  dynamic getError();

  //获取信息
  String? getMessage();
}

class ResponseResult<T> with IResult<T> {
  Response<dynamic>? response;
  dynamic error;
  T? data;
  List<T>? listData;

  JsonParser? _jsonParser;
  static int? Function(ResponseResult result, Type dataType)? onGetCode;
  static String? Function(ResponseResult result, Type dataType)? onGetMessage;
  static bool Function(ResponseResult result, Type dataType)? onIsSuccess;

  ResponseResult({this.response, this.error, JsonParser? jsonParser}) {
    _jsonParser = jsonParser;
    if (error != null && error is DioException) {
      response = (error as DioException).response;
    }

    try {
      var json = jsonDecode(response?.data);
      if (json is List) {
        // log("解析数组数据");
        _parseListData(json);
      } else {
        parseSingleData(json);
      }
    } catch (e) {
      //直接将data返回
      if (DioHttpEngine.enableLog) {
        log("$e\n${response?.statusCode}\n${response?.statusMessage}\n${response?.data}");
      }
      // 基础类型（String/int/double/bool）直接赋值，否则忽略
      if (response?.data == null || response?.data is T) {
        data = response?.data as T?;
      }
    }
  }

  void parseSingleData(json) {
    // log("解析单个数据");
    if (T == String) {
      data = json.toString() as T;
    } else if (T == Map || json is T) {
      data = json as T?;
    } else {
      data = _jsonParser?.call<T>(json);
    }
  }

  void _parseListData(List<dynamic> json) {
    listData = [];
    for (var item in json) {
      if (T == String) {
        listData!.add(item.toString() as T);
      } else {
        var obj = _jsonParser?.call<T>(item);
        if (obj != null) {
          listData!.add(obj);
        }
      }
    }
  }

  @override
  int? getCode() {
    return onGetCode != null ? onGetCode!(this, T) : response?.statusCode;
  }

  @override
  T? getData() {
    return data;
  }

  @override
  dynamic getError() {
    return error;
  }

  @override
  List<T>? getListData() {
    return listData;
  }

  @override
  String? getMessage() {
    return onGetMessage != null
        ? onGetMessage!(this, T)
        : response?.statusMessage;
  }

  @override
  bool isSuccess() {
    return onIsSuccess != null
        ? onIsSuccess!(this, T)
        : response?.statusCode != null &&
            response!.statusCode! >= 200 &&
            response!.statusCode! < 300;
  }
}
