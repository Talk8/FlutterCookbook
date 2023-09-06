import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExWebView extends StatefulWidget {
  const ExWebView({Key? key}) : super(key: key);

  @override
  State<ExWebView> createState() => _ExWebViewState();
}

class _ExWebViewState extends State<ExWebView> {

  var webViewController = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(Colors.lightGreen)
  ..setNavigationDelegate(
  NavigationDelegate( onProgress: (progress)=>print('onProgress'),
  ),
  )
  ..loadRequest(Uri.parse("https://.pub.dev"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of WebView'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: WebViewWidget(
          controller: webViewController,
        ),
      ),
    );
  }
}
