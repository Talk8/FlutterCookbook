

///不要像JAVA中一样写成大写，否则编译器会提示符合命名规则
enum HttpMethod {get, post, delete}

///封装请求类型,创建请求时只需要实现该类中的三个抽象方法就可以
abstract class BaseRequest {
  ///查询类参数，就是带问号
  ///path类参数，就是在base url后带其它内容

  var pathParams;
  var useHttps = true;
  ///查询参数，通过add方法添加，这个内容就是url中key=value的内容
  Map<String,String> queryParams= Map();
  Map<String,dynamic> headerParams= Map();

  ///返回baseUrl
  String baseUrl () {
    // return 'www.base.com';
    ///返回心知天气的网络数据,不能带http，uri.parse会添加
    // return "https://api.seniverse.com/";
    return "api.seniverse.com";
  }

  ///定义三个抽象方法，子类需要实现这三个方法,这三个方法代表了常用的HTTP操作
  ///是否需要登录
  bool needLogin();
  ///HTTP请求操作的类型
  HttpMethod httpMethod();
  ///HTTP请求的路径
  String path();

  String url() {
    Uri uri;
    var  pathStr = path();

    ///拼接path
    if(pathParams != null) {
      if(path().endsWith("/")) {
        pathStr = "${pathStr}${pathParams}";
      }else {
        pathStr = "${pathStr}/${pathParams}";
      }
    }

    ///区分http和https,uri的方法可以把queryParams中的key和value拼接成key=value&key=value这些的形式
    ///该方法还可以自动在baseUrl前添加http://或者https://
    ///该方法还可以在path和queryParams之间添加一个问号表示查询
    if(useHttps) {
      uri = Uri.https(baseUrl(),pathStr,queryParams);
    }else{
      uri = Uri.http(baseUrl(),pathStr,queryParams);
    }

    // debugPrint(uri.toString());
    return uri.toString();
  }

  BaseRequest addRequestParams(String key, dynamic object) {
    queryParams[key] = object.toString();

    return this;
  }

  BaseRequest addHeader(String key, dynamic object) {
    headerParams[key] = object.toString();

    return this;
  }

}