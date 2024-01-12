import 'package:flutter/material.dart';

class ExKeyboardPage extends StatefulWidget {
  const ExKeyboardPage({super.key});

  @override
  State<ExKeyboardPage> createState() => _ExKeyboardPageState();
}

class _ExKeyboardPageState extends State<ExKeyboardPage> {
  
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///用来控制键盘弹出时是否自动滚动页面,默认值是true,另外一种解决方案是在页面外层加一个ListView
      ///让页面滚动起来，缺点时键盘消失后，需要对滚动进行复位操作
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: const Text("Example of Keyboard"),
      ),
      // body: Column(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("this is a text"),
          Container(
            width: 200,
            height: 400,
            color: Colors.lightGreen,
          ),

          TextField(
            maxLines: 6,
            focusNode: focusNode,
            ///点击输入框时获取focus,可以不用获取，因为它会自动获取
            onTap: () {
              debugPrint("onTap");
              focusNode.requestFocus();
            },
            ///点击输入框区域外边时隐藏键盘
            onTapOutside: (event) {
              debugPrint("onTapOutside");
              focusNode.unfocus();
            },

            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color:Colors.orange,width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color:Colors.orange,width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color:Colors.orange,width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
              ///输入时显示的边框
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color:Colors.orange,width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          
          Container(
            width: 200,
            height: 400,
            color: Colors.lightBlueAccent,
          ),
          ElevatedButton(
            onPressed: () { },
            child: const Text("button"),
          ),
          Container(
            width: 200,
            height: 400,
            color: Colors.lightGreen,
          ),
        ],
      ),
    );
  }
}
