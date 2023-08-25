import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExDialog extends StatefulWidget {
  const ExDialog({Key? key}) : super(key: key);

  @override
  State<ExDialog> createState() => _ExDialogState();
}

class _ExDialogState extends State<ExDialog> {
  _showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Alert Dialog"),
            content: Text("This is a Example of  AlerDialog"),
            actions: [
              TextButton(
                onPressed: () {
                  print("Yes selected");
                  Navigator.of(context).pop();
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  print("No selected");
                  Navigator.of(context).pop();
                },
                child: const Text("No"),
              ),
            ],
          );
        });
  }

  //通过showDialog方法弹出窗口
  _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AboutDialog(
          applicationName: "App Name",
          applicationVersion: "v1.0",
          applicationIcon: const Icon(Icons.android),
          children: [
            //可以不添加Buttonm,因为已经自带了两个Button
            TextButton(
              onPressed: () {
                print("ok selected");
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            )
          ],
        );
      },
    );
  }

  //直接使用系统封装好的方法：showAboutDialog()
  _showSystemAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "app",
      applicationVersion: "v111",
      children: [
        Text("Item 1"),
        Text("Item 2"),
        Text("Item 3"),
      ],
    );
  }

  //会遮挡底部的导航栏，点击窗口外区域不会关闭窗口
  _showBottomSheet(context) {
    ElevatedButton(
      child: const Text('showBottomSheet'),
      onPressed: () {
        Scaffold.of(context).showBottomSheet<void>(
          (BuildContext context) {
            return Container(
              height: 200,
              color: Colors.amber,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('BottomSheet'),
                    ElevatedButton(
                      child: const Text('Close BottomSheet'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //不会遮挡底部的导航栏，点击窗口外区域可以关闭窗口
  _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: 300,
            height: 100,
            color: Colors.green,
            child: const Text("This is BottomSheet"),
          );
        });
  }

  _bottomSheet(BuildContext context) {
    return BottomSheet(
        backgroundColor: Colors.purpleAccent,
        shape: const CircleBorder(
          side: BorderSide(
          ),
        ),
        onClosing: () {
          print("close sheet");
        },
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            color: Colors.green,
            width: double.infinity,
            height: 200,
            child: Text("This is a BottomSheet"),
          );
        });
  }

  //用来演示Dialog和ModalBottomSheet
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: const Text("Example of All kinds of dialog"),
      ),
      //在这里设置bottomSheet会一直显示
      // bottomSheet: _bottomSheet(context),

      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _showAlertDialog(),
            child: const Text("Show Dialog"),
          ),
          ElevatedButton(
            onPressed: () => _showAboutDialog(),
            child: const Text("Show About Dialog"),
          ),
          ElevatedButton(
            onPressed: () => _showSystemAboutDialog(),
            child: const Text("Show System AboutDialog"),
          ),
          ElevatedButton(
            //无法显示BottomSheet,这种用法不对，参看下面被注释掉的代码中的用法
            onPressed: () => _showBottomSheet(context),
            child: const Text("Show BottomSheet"),
          ),
          ElevatedButton(
            onPressed: () => _showModalBottomSheet(context),
            child: const Text("Show Modal BottomSheet"),
          ),
          ElevatedButton(
            //关于当前页面，而不是关闭BottomSheet
            onPressed: () => Navigator.pop(context),
            child: const Text("Close BottomSheet"),
          ),
          ///我在这里可以在showDialog中通过consumer获取到provider中的数据，但是ex045蓝牙
          ///包中的内容却不行，估计是包中嵌套的太多导致的。
          ElevatedButton(
            onPressed: () {
              String str = Provider.of<String>(context,listen: false);
              showDialog(context: context, builder: (context) {
                return Consumer<String>(
                  builder: (context, data, _) {
                    return AlertDialog(
                      title: Text('alter'),
                      // content: Text('$str'),
                      content: Text('$data'),
                    );
                  },
                );
              },
              );
            }, ///consumer中无法嵌套show dialog,报发下错误：
            ///setState() or markNeedsBuild() called during build.
            /*
            child: Consumer<String>(
              builder: (context,data,_){
                print('test');
                String str = data;
                // return Text("Consumer $str");
                showDialog(context: context,
                    builder: (context){
                      return Text("Consumer $str");
                    },);
                return Text("Consumer $str");
                },
            ),

             */
            child: const Text("Consumer debug"),
          ),


        ],
      ),
    );
  }

  /*
  //用来演示ShowBottomSheet
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example of BottomSheet"),
      ),
      body: const ExBottomSheet(),
    );
  }

   */
}

//必须创建一个widget并且将它赋值给Scaffold的body属性才可以,该示例来源于官方文档
//参考：https://api.flutter.dev/flutter/material/ScaffoldState/showBottomSheet.html
class ExBottomSheet extends StatelessWidget {
  const ExBottomSheet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('showBottomSheet'),
        onPressed: () {
          Scaffold.of(context).showBottomSheet<void>(
            (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.amber,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('This is BottomSheet'),
                      //关闭BottomSheet窗口
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
