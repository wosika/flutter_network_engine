import 'package:example/model/account_model.dart';

import '../model/weather_model.dart';

class ModelFactory {
  static T? generateOBJ<T>(dynamic json) {
    var str = T.toString();
    switch (str) {
      case "AccountModel":
        return AccountModel.fromJson(json) as T;
      case "WeatherModel":
        return WeatherModel.fromJson(json) as T;
      default:
        return json as T;
    }
  }
}
