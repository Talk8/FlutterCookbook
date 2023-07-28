///封装网络操作的错误类型
class NetworkException implements Exception {
  final int? code;
  final String? message;
  final dynamic data;

  NetworkException({required this.code, required this.message,required this.data});
}

class NeedLogin extends NetworkException {
  NeedLogin({code =401,message="need login",data="please login"}):super(code: code,message: message,data: data);
}

class NeedAuth extends NetworkException {
  NeedAuth({code=403,message="need auth",data="please auth"}):super(code: code,message: message,data: data);
}