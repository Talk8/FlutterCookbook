import 'package:flutter/material.dart';
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart' ;
///这个包中定义了Text类与material中的Text有冲突,所以重命名。
// import 'package:html/dom.dart' ;
import 'package:html/dom.dart' as html_dom;

///上一个ex086使用的是自定义的overlay,我叫它蒙板，本文件中使用的是官方SDK中提供的Overlay组件
///官方通过overlayState来显示OverlayEntry,但是不能管理多个OverlayEntry。OverlayEntry可以删除自己，
///官方的这个OverlayEntry适合显示单个Overlay，不适合做功能引导:onBoarding Overlay
///
/// 最后内容与html包中的示例
class ExOverlayEntry extends StatefulWidget {
  const ExOverlayEntry({super.key});

  @override
  State<ExOverlayEntry> createState() => _ExOverlayEntryState();
}

class _ExOverlayEntryState extends State<ExOverlayEntry> {
  OverlayEntry? _overlayEntry1;
  OverlayEntry? _overlayEntry2;
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var htmStr = parse('''
     <body>
     <h2>Header 1</h2>
     <p>Text.</p>
     <h2>Header 2</h2>
     More text.
     <br/>
     </body>''');

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

    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: const Text("Example of Overlay Entry") ,
      ),
      body: Column(
        children: [
          const Text("this is body"),
          ElevatedButton(
            onPressed: () => _showOverlay(context),
            child: const Text("Show Overlay"),
          ),
          ElevatedButton(
            onPressed: () => _showCurrentOverlay(context),
            child: const Text("Show current Overlay"),
          ),

          ///提取html中的元素
          Text("data is : ${htmStr.body}"),
          Text("data is : ${htmStr.head}"),
          Text("data is : ${htmStr.documentElement}"),
        ],
      ),
    );
  }

  ///显示一个全屏的Overlay
  void _showOverlay(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    _overlayEntry1 = OverlayEntry(builder: (context) {
      ///Overlay上显示的内容
      return Positioned(
          top: 0,
          left: 0,
          child: Container(
            color: Colors.lightBlueAccent,
            width: screenWidth,
            height: screenHeight,
            child:const Text("This is a Overlay Entry"),
          ),
      );
    },
      ///控制透明度
    opaque: true,
    );

    final OverlayState overlayState = Overlay.of(context);
    overlayState.insert(_overlayEntry1!);
    // overlayState.insert(_overlayEntry1!,below: _overlayEntry1!);

    Future.delayed(const Duration(seconds: 5,),() {
      if(_overlayEntry1 != null) {
        _overlayEntry1!.remove();
        _overlayEntry1 = null;
      }
    });
  }
  ///显示一个在组件位置下方的Overlay,宽度和宽度是固定的，这个例子可以当作模板来使用
  void _showCurrentOverlay(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    ///这个方法可以获取到对象，但是获取时机不好掌握，当前这种时机获取到的坐标值为0
    final RenderBox renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    double currentX = renderBox.localToGlobal(Offset.zero).dx;
    double currentY = renderBox.localToGlobal(Offset.zero).dy;

    debugPrint("current : x:$currentX, y:$currentY");

    _overlayEntry2 = OverlayEntry(builder: (context) {
      ///Overlay上显示的内容
      ///使用Stack和Opacity可以控制Overlay底层的颜色和透明度，通常是黑色
      ///或者使用Contain+透明颜色来实现
      return Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              width: screenWidth,
              height: screenHeight,
              color:Colors.black,
              ///这个是透明颜色，没有Opacity时可以通过它来实现透明效果
              // color: Color(0xDF8C8C8C),
            ),
          ),
          Positioned(
            ///这个值计算成显示Overlay位置的坐标值最好，这样可以在这个位置显示Overlay
            top: 300,
            left: 100,
            ///通过容器来控制Overlay当前的颜色和内容，通常是白色
            child: Container(
              color: Colors.lightBlueAccent,
              width: screenWidth,
              height: screenHeight/3,
              ///默认显示的文本格式是红色大号，而且有下划线
              child:const Text("This is a Overlay Entry with position",
                style: TextStyle(color: Colors.black,fontSize: 16,decoration: TextDecoration.none),
              ),
            ),
          ),
        ],
      );
    },
      ///控制透明度,设置为false时才有透明效果
      opaque: false,
    );

    ///显示Overlay,并且在5秒后自动移除Overlay
    final OverlayState overlayState = Overlay.of(context);
    overlayState.insert(_overlayEntry2!);

    Future.delayed(const Duration(seconds: 5,),() {
      if(_overlayEntry2 != null) {
        _overlayEntry2!.remove();
        _overlayEntry2 = null;
      }
    });
  }
}

class _Visitor extends TreeVisitor {
  String indent = '';


  @override
  void visitText(html_dom.Text node) {
    if (node.data.trim().isNotEmpty) {
      print('$indent${node.data.trim()}');
    }
  }

  @override
  void visitElement(html_dom.Element node) {
    if (isVoidElement(node.localName)) {
      print('$indent<${node.localName}/>');
    } else {
      print('$indent<${node.localName}>');
      indent += '  ';
      visitChildren(node);
      indent = indent.substring(0, indent.length - 2);
      print('$indent</${node.localName}>');
    }
  }

  @override
  void visitChildren(html_dom.Node node) {
    for (var child in node.nodes) {
      visit(child);
    }
  }
}
