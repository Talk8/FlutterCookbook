import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart' ;
///这个包中定义了Text类与material中的Text有冲突,所以重命名。
// import 'package:html/dom.dart' ;
import 'package:html/dom.dart' as html_dom;
import 'package:webview_flutter/webview_flutter.dart';

///
///主要介绍html和flutter_widget_from_html两个包的用法
class ExHtmlView extends StatefulWidget {
  const ExHtmlView({super.key});

  @override
  State<ExHtmlView> createState() => _ExHtmlViewState();
}

class _ExHtmlViewState extends State<ExHtmlView> {
  var webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.lightGreen)
    ..setNavigationDelegate(
      NavigationDelegate( onProgress: (progress)=>debugPrint('onProgress'),
      ),
    );

  @override
  Widget build(BuildContext context) {

   ///parse方法可以直接处理html文本
    var htmStr = parse('''
     <body>
     <h2>Header 1</h2>
     <p>Text.</p>
     <h2>Header 2</h2>
     More text.<br>
     Line 1... <br>
     Line 2...<br>
     Line 3...<br>
     Line 4...<br>
     Line 5...<br>
     Line 6...<br>
     Line 7...<br>
     Line 8...<br>
     Line 9...<br>
     Line 10...<br>
     <br/>
     </body>''');

    ///parse方法可以直接处理html文本
    var htmlStr = parse('''
     <body>
     <h2>Header 1</h2>
     <p>Text.</p>
     <h2>Header 2</h2>
     More text.<br>
     Line 1... <br>
     Line 2...<br>
     Line 3...<br>
     <br/>
     </body>''');

    ///这要定义html字符串是错误的，因为字符串中有特殊符号,推荐使用上面的方法
    // String strHtml = "     <body>
    // <h2>Header 1</h2>
    // <p>Text.</p>
    // <h2>Header 2</h2>
    // More text.
    // <br/>
    // </body>";
    ///输出：I/flutter (22038): <html><head></head><body>
    // I/flutter (22038):      <h2>Header 1</h2>
    // I/flutter (22038):      <p>Text.</p>
    // I/flutter (22038):      <h2>Header 2</h2>
    // I/flutter (22038):      More text.
    // I/flutter (22038):      <br>
    // I/flutter (22038):      </body></html>
    debugPrint(htmStr.outerHtml);
    ///输出：I/flutter (22038): <html>
    // I/flutter (22038):   <head>
    // I/flutter (22038):   </head>
    // I/flutter (22038):   <body>
    // I/flutter (22038):     <h2>
    // I/flutter (22038):       Header 1
    // I/flutter (22038):     </h2>
    // I/flutter (22038):     <p>
    // I/flutter (22038):       Text.
    // I/flutter (22038):     </p>
    // I/flutter (22038):     <h2>
    // I/flutter (22038):       Header 2
    // I/flutter (22038):     </h2>
    // I/flutter (22038):     More text.
    // I/flutter (22038):     <br/>
    // I/flutter (22038):   </body>
    // I/flutter (22038): </html>
    _Visitor().visit(htmStr);


    webViewController.loadHtmlString(htmStr.outerHtml);

    return Scaffold(
      appBar: AppBar(
        title:const Text("Example of HtmlView"),
        backgroundColor: Colors.purpleAccent,
      ),

      body: Column(
        children: [
          ///提取html中的元素，但是不是元素对应的值而是html中的标签,不是我期望的效果
          Text("data is : ${htmStr.body}"), ///显示<htm body>
          Text("data is : ${htmStr.head}"),///显示<htm head>
          Text("data is : ${htmStr.documentElement}"),
          ///无法使用父容器限制HtmlWidget的大小，有运行时错误
          // Container(
          //   color: Colors.deepOrangeAccent,
          //   padding: const EdgeInsets.all(16),
          //   width: MediaQuery.sizeOf(context).width,
          //   height: MediaQuery.sizeOf(context).height/5,
          //   child: HtmlWidget(htmStr.outerHtml),
          // ),
          ///直接通过包中的widget直接渲染html文本
          HtmlWidget(htmlStr.outerHtml),

          ///通过webViewWidget渲染html文本，不过尺寸太大，不能放在这里，需要放在整个屏幕中
          // WebViewWidget(controller: webViewController),
          ///把webView放在父容器中用来限制WebView的大小，内容无法显示时可以自动滚动
          Container(
          color: Colors.lightBlueAccent,
          padding: const EdgeInsets.all(16),
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height/5,
          child: WebViewWidget(controller: webViewController,),
          ),
        ],
      ),
      ///通过webViewWidget渲染html文本，尺寸太大，需要放在整个屏幕中,
      // body: WebViewWidget(controller: webViewController,),
    );
  }
}


class _Visitor extends TreeVisitor {
  String indent = '';


  @override
  void visitText(html_dom.Text node) {
    if (node.data.trim().isNotEmpty) {
      debugPrint('$indent${node.data.trim()}');
    }
  }

  @override
  void visitElement(html_dom.Element node) {
    if (isVoidElement(node.localName)) {
      debugPrint('$indent<${node.localName}/>');
    } else {
      debugPrint('$indent<${node.localName}>');
      indent += '  ';
      visitChildren(node);
      indent = indent.substring(0, indent.length - 2);
      debugPrint('$indent</${node.localName}>');
    }
  }

  @override
  void visitChildren(html_dom.Node node) {
    for (var child in node.nodes) {
      visit(child);
    }
  }
}

