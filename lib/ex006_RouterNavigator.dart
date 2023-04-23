import 'package:flutter/material.dart';
import 'package:fluttercookbook/main.dart';

//这里的代码与第12和14回中内容匹配，包含Route，Navigator导航以及在页面跳转时传递数据
class SecondRouter extends StatelessWidget {
  const SecondRouter({Key? key,required this.data}) : super(key: key);

  final String data;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: const Text("This is the second page"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: OutlinedButton(
        onPressed: (){
          Navigator.pop(context,
              MaterialPageRoute(builder: (context){
                return const MyHomePage(title: "Back to Home");
              })
          );
        },
        // child: const Text("Back"),
        child: Text(data),
      ),
    );
  }
}