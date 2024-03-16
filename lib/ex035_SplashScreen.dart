
import 'package:flutter/material.dart';


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
    debugPrint("Widget Circle: initState");
    Future.delayed(const Duration(seconds: 3), () {
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
  Widget build(BuildContext context) {
    debugPrint("Widget Circle: build");

    return Image.asset("images/ex.png");
  }

  @override
  void deactivate() {
    super.deactivate();
    debugPrint("Widget Circle: deactivate");
  }

  @override
  void activate() {
    super.activate();
    debugPrint("Widget Circle: activate");
  }

  @override
  void dispose() {
    debugPrint("Widget Circle: dispose");
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("Widget Circle: didChangeDependencies");
  }
}
