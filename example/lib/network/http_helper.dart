import 'package:example/model/base_result.dart';
import 'package:flutter_network_engine/flutter_network_engine.dart';
import 'package:dio/dio.dart';

class HttpHelper {
  static OnResult onResult = (Response? response, [dynamic error]) {
    return BaseResult.fromResponse(response, error);
  };

}
