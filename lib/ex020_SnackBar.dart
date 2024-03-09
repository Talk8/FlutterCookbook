import 'package:flutter/material.dart';

class ExSnackBar extends StatefulWidget {
  const ExSnackBar({Key? key}) : super(key: key);

  @override
  State<ExSnackBar> createState() => _ExSnackBarState();
}

class _ExSnackBarState extends State<ExSnackBar> {
  int value = 0;
  _showToolTip() {
    return Tooltip(
      //提示框的高度，宽度自适应文字长度.
      height: 100,
      //鼠标悬停等待时间，时间到达后显示tooltip
      // waitDuration: Duration(seconds: 2),
      //长按等待时间,时间到达后显示tooltip
      showDuration: const Duration(seconds: 3),
      message: "This is the message of ToolTip",
      //建议设置文字颜色，默认为白色,不容易看到
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        alignment: Alignment.center,
        width: 400,
        height: 300,
        child: const Text('Show Tooltip'),
      ),
    );
  }

  _showSnackBar(BuildContext context) {
    return ElevatedButton(
      child: const Text("Show SnackBar"),
      onPressed: () {
        //通过showSnackBar方法显示SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("This is SnackBar"),
          backgroundColor: Colors.amberAccent,
          //修改形状，默认为矩形
          shape:const CircleBorder(
            side: BorderSide(),
          ),
          //显示时间
          duration:const Duration(seconds: 3),
          action: SnackBarAction(
            textColor: Colors.black12,
            label: "SnackBar Action",
            onPressed: () {//do nothing
             },
          ),
        ));
      },
    );
  }

  ///通过key来控制snackBar的显示和隐藏，需要配合ScaffoldMessenger使用，与239内容匹配
  final snackBarKeyA = GlobalKey<ScaffoldMessengerState>();
  
  @override
  Widget build(BuildContext context) {
    debugPrint("SubPage build");
    // return Text('Replace');
    return ScaffoldMessenger(
      key: snackBarKeyA,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          title: const Text('Example of SnackBar'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _showToolTip(),
            ///通过showSnackBar来显示Snackbar
            _showSnackBar(context),

            ElevatedButton(onPressed: () => snackBarKeyA.currentState?.showSnackBar(createSnackBar()),
                child: const Text("Show another SnackBar"),
            ),
            ElevatedButton(onPressed: () => snackBarKeyA.currentState?.removeCurrentSnackBar(),
              child: const Text("remover another SnackBar"),
            ),
            // TextStatefulWidget(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  value += 1;
                  debugPrint("SubPage value: $value");
                });
              },
              child: const Text("change value"),
            ),
            Text("Value : $value"),
          ],
        ),
        // body: _showToolTip(),
      ),
    );
  }

  SnackBar createSnackBar() {
    return const SnackBar(
      content: Text("This is SnackBar"),
      backgroundColor: Colors.amberAccent,
      //修改形状，默认为矩形
      shape:CircleBorder(
        side: BorderSide(),
      ),
      //显示时间
      duration:Duration(seconds: 3),
    );
  }
  
  @override
  void didChangeDependencies() {
    debugPrint("SubPage didChangeDependencies");
  }

  @override
  void dispose() {
    debugPrint("SubPage dispose");
    super.dispose();
  }

  @override
  void activate() {
    debugPrint("SubPage activate");
  }

  @override
  void deactivate() {
    debugPrint("SubPage deactivate");
  }


  @override
  void reassemble() {
    debugPrint("SubPage reassemble");
  }

  @override
  void didUpdateWidget(ExSnackBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("SubPage didUpdateWidget");
  }

  @override
  void initState() {
    debugPrint("SubPage initState");
  }
}

//这个示例是为了演示widget的生命周期，主要是didUpdateWidget()方法，不过没有回调该方法
class TextStatefulWidget extends StatefulWidget {
  const TextStatefulWidget({Key? key}) : super(key: key);

  @override
  State<TextStatefulWidget> createState() => _TextStatefulWidgetState();
}

class _TextStatefulWidgetState extends State<TextStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return const Text('Hello');
  }

  @override
  void didChangeDependencies() {
    debugPrint('TestStatefulWidget didChangeDependencies');
  }

  @override
  void dispose() {
    debugPrint('TestStatefulWidget dispose');
    super.dispose();
  }

  @override
  void activate() {
    debugPrint('TestStatefulWidget activate');
  }

  @override
  void deactivate() {
    debugPrint('TestStatefulWidget deactivate');
  }

  @override
  void reassemble() {
    debugPrint('TestStatefulWidget reassemble');
  }

  @override
  void initState() {
    debugPrint('TestStatefulWidget initState');
  }
}