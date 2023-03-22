import 'package:example/model/account_model.dart';

class ModelFactory {

  static T? generateOBJ<T>(json) {
    var str = T.toString();
    switch (str) {
      case "AccountModel":
        return AccountModel.fromJson(json) as T;
      default:
        return json as T;
    }
  }
}
