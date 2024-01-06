import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///与36，37章回内容相匹配
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

  ///自定义Dialog:中间是一个输入框，下面是两个按钮
  _showCustomDialog() {
    showDialog(context: context,
        builder: (BuildContext context) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;

          ///自定义Dialog，通过container控制大小
          return AlertDialog(
            ///两颜色同时设置才有效果
            surfaceTintColor: Colors.white,
            ///这个是对话框窗口的背景颜色
            backgroundColor: Colors.white,
            ///修改对话框的圆角，默认带圆角，可以不处理,下面的代码给对话框镶了一个金边
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.yellow,width: 4),
            ),
            content: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 48,bottom: 8),
              width: width - 16*2,
              height: height/4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        ///输入框最左侧和最右侧的图标
                        prefixIcon: const Icon(Icons.mail),
                        suffixIcon: const Icon(Icons.delete),
                        ///输入框的填充颜色
                        filled: true,
                        fillColor: Colors.black26,
                        ///输入框的边框,不同状态下有不同的边框
                        enabled: true,
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.redAccent,width: 4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.redAccent,width: 4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        ///输入时显示的边框
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue,width: 4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(onPressed: (){}, child: const Text("Yes"),),
                        ElevatedButton(onPressed: (){}, child: const Text("No"),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        );
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

          ElevatedButton(onPressed: () {
            _showCustomDialog();
            },
            child: const Text("Show Custom Dialog"),),

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
