import 'package:flutter/material.dart';

//和25回中的内容相匹配
class ExPageView extends StatefulWidget {
  const ExPageView({Key? key}) : super(key: key);

  @override
  State<ExPageView> createState() => _ExPageViewState();
}

class _ExPageViewState extends State<ExPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of PaveView"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        onPageChanged: (value){print("onPage Changed: ${value}");},
        children: [
          Container(
            alignment: Alignment.center,
            //长度和调试没有效果，会填充满整个屏幕
            width: 100,
            height: 300,
            color: Colors.lightBlue,
            child: const Text("Page 1"),
          ),
          Container(
            alignment: Alignment.center,
            color: Colors.greenAccent,
            child: const Text("Page 2"),
          ),
          Container(
            alignment: Alignment.center,
            color: Colors.brown,
            child: const Text("Page 3"),
          ),
        ],
      ),
    );
  }
}
