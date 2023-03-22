/// username : "aa"
/// data : "aaa"

class AccountModel {
  AccountModel({
      String? username, 
      String? data,}){
    _username = username;
    _data = data;
}

  AccountModel.fromJson(dynamic json) {
    _username = json['username'];
    _data = json['data'];
  }
  String? _username;
  String? _data;
AccountModel copyWith({  String? username,
  String? data,
}) => AccountModel(  username: username ?? _username,
  data: data ?? _data,
);
  String? get username => _username;
  String? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['data'] = _data;
    return map;
  }

}