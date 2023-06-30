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
        backgroundColor: Colors.purpleAccent,
      ),
      // body: imageEx,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildImageFill(),
          buildImageCover(),
          buildImageContain(),
          buildImageColorLighten(),
          buildImageColorClear(),
          buildImageColorDstIn(),
          buildImageColorDstOut(),
          buildImageColorDiff(),
        ],
      ),
    );
  }

  //抽象成方法
  Image buildImageFill() {
    return Image(
      width: 80,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.fill,
      filterQuality:FilterQuality.high ,
    );
  }

  Image buildImageCover() {
    return Image(
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.cover,
      filterQuality:FilterQuality.high,
    );
  }

  Image buildImageContain() {
    return Image(
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
    );
  }

  Image buildImageColorLighten() {
    return Image(
      color: Colors.purpleAccent,
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
      colorBlendMode: BlendMode.lighten,
    );
  }

  Image buildImageColorClear() {
    return Image(
      color: Colors.purpleAccent,
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
      colorBlendMode: BlendMode.clear,
    );
  }

  Image buildImageColorDstIn() {
    return Image(
      color: Colors.purpleAccent,
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
      colorBlendMode: BlendMode.dstIn,
    );
  }

  Image buildImageColorDstOut() {
    return Image(
      color: Colors.purpleAccent,
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
      colorBlendMode: BlendMode.dstOut,
    );
  }

  Image buildImageColorDiff() {
    return Image(
      color: Colors.purpleAccent,
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
      colorBlendMode: BlendMode.difference,
    );
  }
}