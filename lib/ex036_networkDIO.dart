import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ExNetworkDio extends StatefulWidget {
  const ExNetworkDio({Key? key}) : super(key: key);

  @override
  State<ExNetworkDio> createState() => _ExNetworkDioState();
}

class _ExNetworkDioState extends State<ExNetworkDio> {
  var _mDio = Dio();
  var _getType = "https://httpbin.org/get";
  var _postType = "https://httpbin.org/post";

  @override
  Widget build(BuildContext context) {
    _getRequest() {
      _mDio.get(_getType).then((value) {
        debugPrint(value.toString());
      });
    }

    _postRequest() {
      _mDio.post(_postType).then((value) => debugPrint(value.toString()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Example of Network'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              debugPrint('get button clicked');
              _getRequest();
            },
            child: Text('GET request'),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint('post button clicked');
              _getRequest();
            },
            child: Text('POST request'),
          ),
        ],
      ),
    );
  }
}
