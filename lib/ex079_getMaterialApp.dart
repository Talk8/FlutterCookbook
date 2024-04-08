import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExGetMaterialApp extends StatelessWidget {
  const ExGetMaterialApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: GetHomePage(),
    );
  }

}


class GetHomePage extends StatelessWidget {
  const GetHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of GetMaterialApp"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("this is body"),
          ///显示snackBar的两种方式，一种使用固定的样式，另外一种使用自定义样式
          ElevatedButton(
            onPressed: () {
              ///这个snb默认透明色而且是在顶部显示
              Get.snackbar("title", "Message");
            },
            child: const Text("show SnackBar"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.showSnackbar(
                const GetSnackBar(
                  title: "Title",
                  message: "Message",
                  ///需要加显示时间，默认一直显示
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.blue,
                  ///控制snb与屏幕的边距
                  margin:EdgeInsets.only(bottom: 80,left: 16,right: 16),
                  ///不能像原生的snb一样控制形状，但是可以控制圆角，默认是矩形
                  borderRadius: 16,
                  ///会在snb顶部显示水平滚动条
                  showProgressIndicator: true,
                  ///这两个属性决定了snackBar的默认在底部显示
                  // this.snackPosition = SnackPosition.BOTTOM,
                  // this.snackStyle = SnackStyle.FLOATING,
                )
              );
            },
            child: const Text("show overly"),
          ),
        ],
      ),
    );
  }
}


