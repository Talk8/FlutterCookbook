//这个代码和第六回Image Widget的内容匹配
import 'package:flutter/material.dart';

class ExImage extends StatelessWidget {
  const ExImage({Key?key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget imageEx = Container(
      width: 300,
      height: 200,
      color: Colors.blue[300],
      child: Row(
        children: const [
          //if the image is not existed,it can not be shown.
          Image(image: AssetImage("images/ex.png"),),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Example of Image Widget"),
      ),
      body: imageEx,
    );
  }
}