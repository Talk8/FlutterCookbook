
import 'package:flutter/material.dart';

import 'main.dart';

//这里是启动页splash screen示例，同时也包含生命周期方法对应81 82，回的内容。还有部分代码在020文件中
class ExSplashScreen extends StatefulWidget {
  const ExSplashScreen({Key? key}) : super(key: key);

  @override
  State<ExSplashScreen> createState() => _ExSplashScreenState();
}

class _ExSplashScreenState extends State<ExSplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Widget Circle: initState");
    Future.delayed(Duration(seconds: 3), () {
      //可以在这里加一些广播或者视频等,我们是延时3秒后启动主页
      Navigator.of(context).pushReplacementNamed("MyHomePage");
    });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) { MyHomePage(title: 'Flutter Demo Home Page');});


    //以下方式调用会有错误：setState() or markNeedsBuild() called during build.
    /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
     */
  }


  @override
  void didUpdateWidget(Widget oldWidget) {
    print("Widget Circle: didUpdateWidget");
  }

  @override
  Widget build(BuildContext context) {
    print("Widget Circle: build");

    return Container(
      child: Image.asset("images/ex.png"),
    );
  }

  @override
  void deactivate() {
    print("Widget Circle: deactivate");
  }

  @override
  void activate() {
    print("Widget Circle: activate");
  }

  @override
  void dispose() {
    print("Widget Circle: dispose");
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print("Widget Circle: didChangeDependencies");
  }
}
