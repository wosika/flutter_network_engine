import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../flutter_network_engine.dart';

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

  ResponseResult({this.response, this.error, JsonParser? jsonParser}) {
    _jsonParser = jsonParser;
    if (error != null && error is DioError) {
      this.response = (error as DioError).response;
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
      log(e.toString());
      data = response?.data as T?;
    }

  }

  void parseSingleData(json) {
   // log("解析单个数据");
    if (T is String) {
   //   log("泛型是String");
      data = json.toString() as T;
    } else if (T is Map) {
   //   log("泛型是Map");
      data = json as T?;
    } else {
    //  log("泛型是不是string也不是map");
      data = _jsonParser?.call(json);
    }
  }

  void _parseListData(List<dynamic> json) {
    listData = [];
    for (var item in json) {
      if (T is String) {
        listData!.add(item.toString() as T);
      } else {
        var obj = _jsonParser?.call(item);
        if (obj != null) {
          listData!.add(obj);
        }
      }
    }
  }

  @override
  int? getCode() {
    return response?.statusCode;
  }

  @override
  T? getData() {
    return data;
  }

  @override
  getError() {
    return error;
  }

  @override
  List<T>? getListData() {
    return listData;
  }

  @override
  String? getMessage() {
    return response?.statusMessage;
  }

  @override
  bool isSuccess() {
    return response?.statusCode != null &&
        response!.statusCode! >= 200 &&
        response!.statusCode! < 300;
  }
}
