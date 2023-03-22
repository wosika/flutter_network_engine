/// reason : "查询成功"
/// result : {"city":"三亚","realtime":{"temperature":"28","humidity":"73","info":"晴","wid":"00","direct":"西南风","power":"3级","aqi":"28"},"future":[{"date":"2023-03-22","temperature":"22/30℃","weather":"多云","wid":{"day":"01","night":"01"},"direct":"东南风转东风"},{"date":"2023-03-23","temperature":"24/31℃","weather":"多云","wid":{"day":"01","night":"01"},"direct":"东南风"},{"date":"2023-03-24","temperature":"24/30℃","weather":"多云","wid":{"day":"01","night":"01"},"direct":"东风转东南风"},{"date":"2023-03-25","temperature":"23/28℃","weather":"多云","wid":{"day":"01","night":"01"},"direct":"持续无风向"},{"date":"2023-03-26","temperature":"24/28℃","weather":"多云","wid":{"day":"01","night":"01"},"direct":"持续无风向"}]}
/// error_code : 0

class WeatherModel {
  WeatherModel({
      String? reason, 
      Result? result, 
      num? errorCode,}){
    _reason = reason;
    _result = result;
    _errorCode = errorCode;
}

  WeatherModel.fromJson(dynamic json) {
    _reason = json['reason'];
    _result = json['result'] != null ? Result.fromJson(json['result']) : null;
    _errorCode = json['error_code'];
  }
  String? _reason;
  Result? _result;
  num? _errorCode;
WeatherModel copyWith({  String? reason,
  Result? result,
  num? errorCode,
}) => WeatherModel(  reason: reason ?? _reason,
  result: result ?? _result,
  errorCode: errorCode ?? _errorCode,
);
  String? get reason => _reason;
  Result? get result => _result;
  num? get errorCode => _errorCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reason'] = _reason;
    if (_result != null) {
      map['result'] = _result?.toJson();
    }
    map['error_code'] = _errorCode;
    return map;
  }

}

/// city : "三亚"
/// realtime : {"temperature":"28","humidity":"73","info":"晴","wid":"00","direct":"西南风","power":"3级","aqi":"28"}
/// future : [{"date":"2023-03-22","temperature":"22/30℃","weather":"多云","wid":{"day":"01","night":"01"},"direct":"东南风转东风"},{"date":"2023-03-23","temperature":"24/31℃","weather":"多云","wid":{"day":"01","night":"01"},"direct":"东南风"},{"date":"2023-03-24","temperature":"24/30℃","weather":"多云","wid":{"day":"01","night":"01"},"direct":"东风转东南风"},{"date":"2023-03-25","temperature":"23/28℃","weather":"多云","wid":{"day":"01","night":"01"},"direct":"持续无风向"},{"date":"2023-03-26","temperature":"24/28℃","weather":"多云","wid":{"day":"01","night":"01"},"direct":"持续无风向"}]

class Result {
  Result({
      String? city, 
      Realtime? realtime, 
      List<Future>? future,}){
    _city = city;
    _realtime = realtime;
    _future = future;
}

  Result.fromJson(dynamic json) {
    _city = json['city'];
    _realtime = json['realtime'] != null ? Realtime.fromJson(json['realtime']) : null;
    if (json['future'] != null) {
      _future = [];
      json['future'].forEach((v) {
        _future?.add(Future.fromJson(v));
      });
    }
  }
  String? _city;
  Realtime? _realtime;
  List<Future>? _future;
Result copyWith({  String? city,
  Realtime? realtime,
  List<Future>? future,
}) => Result(  city: city ?? _city,
  realtime: realtime ?? _realtime,
  future: future ?? _future,
);
  String? get city => _city;
  Realtime? get realtime => _realtime;
  List<Future>? get future => _future;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['city'] = _city;
    if (_realtime != null) {
      map['realtime'] = _realtime?.toJson();
    }
    if (_future != null) {
      map['future'] = _future?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// date : "2023-03-22"
/// temperature : "22/30℃"
/// weather : "多云"
/// wid : {"day":"01","night":"01"}
/// direct : "东南风转东风"

class Future {
  Future({
      String? date, 
      String? temperature, 
      String? weather, 
      Wid? wid, 
      String? direct,}){
    _date = date;
    _temperature = temperature;
    _weather = weather;
    _wid = wid;
    _direct = direct;
}

  Future.fromJson(dynamic json) {
    _date = json['date'];
    _temperature = json['temperature'];
    _weather = json['weather'];
    _wid = json['wid'] != null ? Wid.fromJson(json['wid']) : null;
    _direct = json['direct'];
  }
  String? _date;
  String? _temperature;
  String? _weather;
  Wid? _wid;
  String? _direct;
Future copyWith({  String? date,
  String? temperature,
  String? weather,
  Wid? wid,
  String? direct,
}) => Future(  date: date ?? _date,
  temperature: temperature ?? _temperature,
  weather: weather ?? _weather,
  wid: wid ?? _wid,
  direct: direct ?? _direct,
);
  String? get date => _date;
  String? get temperature => _temperature;
  String? get weather => _weather;
  Wid? get wid => _wid;
  String? get direct => _direct;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['temperature'] = _temperature;
    map['weather'] = _weather;
    if (_wid != null) {
      map['wid'] = _wid?.toJson();
    }
    map['direct'] = _direct;
    return map;
  }

}

/// day : "01"
/// night : "01"

class Wid {
  Wid({
      String? day, 
      String? night,}){
    _day = day;
    _night = night;
}

  Wid.fromJson(dynamic json) {
    _day = json['day'];
    _night = json['night'];
  }
  String? _day;
  String? _night;
Wid copyWith({  String? day,
  String? night,
}) => Wid(  day: day ?? _day,
  night: night ?? _night,
);
  String? get day => _day;
  String? get night => _night;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['day'] = _day;
    map['night'] = _night;
    return map;
  }

}

/// temperature : "28"
/// humidity : "73"
/// info : "晴"
/// wid : "00"
/// direct : "西南风"
/// power : "3级"
/// aqi : "28"

class Realtime {
  Realtime({
      String? temperature, 
      String? humidity, 
      String? info, 
      String? wid, 
      String? direct, 
      String? power, 
      String? aqi,}){
    _temperature = temperature;
    _humidity = humidity;
    _info = info;
    _wid = wid;
    _direct = direct;
    _power = power;
    _aqi = aqi;
}

  Realtime.fromJson(dynamic json) {
    _temperature = json['temperature'];
    _humidity = json['humidity'];
    _info = json['info'];
    _wid = json['wid'];
    _direct = json['direct'];
    _power = json['power'];
    _aqi = json['aqi'];
  }
  String? _temperature;
  String? _humidity;
  String? _info;
  String? _wid;
  String? _direct;
  String? _power;
  String? _aqi;
Realtime copyWith({  String? temperature,
  String? humidity,
  String? info,
  String? wid,
  String? direct,
  String? power,
  String? aqi,
}) => Realtime(  temperature: temperature ?? _temperature,
  humidity: humidity ?? _humidity,
  info: info ?? _info,
  wid: wid ?? _wid,
  direct: direct ?? _direct,
  power: power ?? _power,
  aqi: aqi ?? _aqi,
);
  String? get temperature => _temperature;
  String? get humidity => _humidity;
  String? get info => _info;
  String? get wid => _wid;
  String? get direct => _direct;
  String? get power => _power;
  String? get aqi => _aqi;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['temperature'] = _temperature;
    map['humidity'] = _humidity;
    map['info'] = _info;
    map['wid'] = _wid;
    map['direct'] = _direct;
    map['power'] = _power;
    map['aqi'] = _aqi;
    return map;
  }

}