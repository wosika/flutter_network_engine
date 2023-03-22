mixin  IResult<T> {
  //网络请求是否成功
  bool isSuccess();

  //获取code
  int? getCode();

  //获取数据
  T? getData();

  //获取集合数据
  List<T> getListData();

  //获取任意类型的错误
  dynamic getError();

  //获取信息
  String? getMessage();

}
