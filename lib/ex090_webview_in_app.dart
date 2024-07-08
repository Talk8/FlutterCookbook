import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

///这个示例主要运行flutter_inappwebview插件实现访问app中资源(asset)目录下的html文件
///flutter官方的webView可以在app中显示正常网页，不过不能访问app中资源(asset)目录下的html文件
///如果想访问需要在manifest文件中开相关权限，这会影响完全，因此使用本插件
class ExWebViewInApp extends StatefulWidget {
  const ExWebViewInApp({super.key});

  @override
  State<ExWebViewInApp> createState() => _ExWebViewInAppState();
}

class _ExWebViewInAppState extends State<ExWebViewInApp> {
  ///直接使用WebView加载本地的html文件时报net::ERR_ACCESS_DENIED错误。这个是浏览器的安全策略
  ///需要在manifest文件中添加相关内容，调试版本可以试试，正式版本中不建议这么做
  ///尝试通过rootBundle来加载本地html文件时仍然报相同的错误
  Future<void> loadHtmlFromLocalFile(WebViewController controller) async {
    String htmlContent = await rootBundle.loadString('images/indexdev.html');
    controller.runJavaScript(
        '''
      document.open()
      document.write('$htmlContent')
      document.close()
    '''
    );
  }
  var webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.lightGreen)
    ..setNavigationDelegate(
      NavigationDelegate( onProgress: (progress)=>debugPrint('onProgress'),
      ),
    )
  // ..loadRequest(Uri.parse("https://.pub.dev")); ///加载正常网页可以，加载资源文件中的网页不可以
    ..loadRequest(Uri.parse("file:///images/indexdev.html"));



  @override
  Widget build(BuildContext context) {

    InAppWebViewSettings settings = InAppWebViewSettings(
        isInspectable:  kDebugMode,
        allowFileAccessFromFileURLs: false,
        allowFileAccess: false,
        allowContentAccess: false,
        webViewAssetLoader: WebViewAssetLoader(
            domain: "my.custom.domain.com",
            pathHandlers: [
              AssetsPathHandler(path: "/assets/")
            ]
        )
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of WebView in App"),
      ),
      ///程序可以正常运行，但是无法加载本地html文件
      // body: FutureBuilder<void>(
      //   future: loadHtmlFromLocalFile(webViewController),
      //   builder: (context,snapshot) {
      //     return WebViewWidget(
      //       controller: webViewController,
      //     );
      //   }
      // ),
      ///程序可以正常运行，而且可以加载本地html文件
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri("https://my.custom.domain.com/assets/flutter_assets/images/indexdev.html"),),
        initialSettings: settings,
      ),

    );
  }
}
