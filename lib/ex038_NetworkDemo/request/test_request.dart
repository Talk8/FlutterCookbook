import 'package:fluttercookbook/ex038_NetworkDemo/request/base_request.dart';
///发起http网络操作时可以参考该类，只需要创建一个该类型的对象就可以将其传递给netwrokwrapper来发起请求
class TestRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.get;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    ///测试路径
    // return 'path_1/path_2';
    ///path是com到key之间的内容，通过url自动生成 :"https://api.seniverse.com/v3/weather/now.json?key
    return "v3/weather/now.json";
  }
}