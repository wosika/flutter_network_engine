import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_network_engine/flutter_network_engine.dart';

import '../network/model_factory.dart';

class BaseResult<T> extends IResult<T> {
  int? code;

  T? data;

  dynamic error;

  List<T> listData = [];

  String? message;

  bool? _isSuccess;

  @override
  int? getCode() {
    return code;
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
  List<T> getListData() {
    return listData;
  }

  @override
  String? getMessage() {
    return message;
  }

  @override
  bool isSuccess() {
    return _isSuccess == true;
  }

  BaseResult.fromResponse(Response<T>? response, [dynamic error]) {
    code = response?.statusCode??-1;
    _isSuccess = code! >= 200 && code! < 300;
    message = response?.statusMessage;

    try {
      log("解析数据");
      var json = jsonDecode(response!.data.toString());

      if (json is List) {
        log("解析数组数据");
        for (var item in json) {
          if (T is String) {
            listData.add(item.toString() as T);
          } else {
            var obj = ModelFactory.generateOBJ<T>(item);
            if (obj != null) {
              listData.add(obj);
            }
          }
        }
      } else {
        log("解析单个数据");
        if (T is String) {
          log("泛型是String");
          data = json.toString() as T;
        } else if (T is Map) {
          log("泛型是Map");
          data = json as T?;
        } else {
          log("泛型是不是string也不是map");
          data = ModelFactory.generateOBJ<T>(json);
        }
      }
    } catch (e) {
      //直接将data返回
      data = response?.data as T;
    }
  }
}
