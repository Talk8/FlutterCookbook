import 'package:flutter/material.dart';

//对应第22回的内容
class ExAlignAndPadding extends StatelessWidget {
  const ExAlignAndPadding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Example of Align and Padding"),
          backgroundColor: Colors.purpleAccent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Container也有Align功能，它和Align最好二选一
            Container(
              margin:const EdgeInsets.only(left: 30.0),
              width: 200,
              height: 200,
              color: Colors.blue,
              alignment:const FractionalOffset(0.1,0.2),
              child: const Text("Column 1"),
            ),
            //三种方法都可以实现居中对齐
            const Align(
              alignment: Alignment.center,
              child: Text("This is a text"),
            ),
            const Align(
              alignment: FractionalOffset(0.5, 0.5),
              child: Text("This is a text"),
            ),
            const Center(
              child: Text("This is a text"),
            ),
            //全部和部分设置内边距
            const Padding(
              padding:EdgeInsets.all(10.0),
              child: Text("This is a text"),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text("This is a text"),
            ),
          ],
        )
    );
  }
}
