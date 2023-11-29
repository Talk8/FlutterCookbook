//这个代码和第六回Image Widget的内容匹配,183添加了图片阴影
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
      child: const Row(
        children: [
          //if the image is not existed,it can not be shown.
          Image(image: AssetImage("images/ex.png"),),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Image Widget"),
        backgroundColor: Colors.purpleAccent,
      ),
      // body: imageEx,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imageEx,
          const SizedBox(height: 20,),
          buildImageFill(),
          buildImageShadow(),
          const SizedBox(height: 20),
          buildImageCover(),
          buildImageContain(),
          buildImageColorLighten(),
          // buildImageColorClear(),
          // buildImageColorDstIn(),
          // buildImageColorDstOut(),
          buildImageColorDiff(),
        ],
      ),
    );
  }

  //抽象成方法
  //组件尺寸和图片不同时，图片会有拉伸
  Image buildImageFill() {
    return const Image(
      width: 160,
      height: 60,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.fill,
      filterQuality:FilterQuality.high ,
      color: Colors.redAccent,
      colorBlendMode: BlendMode.dstOver,
    );
  }

  //组件尺寸和图片不同时，图片会有剪裁
  Image buildImageCover() {
    return const Image(
      width: 160,
      height: 60,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.cover,
      filterQuality:FilterQuality.high,
    );
  }

  //组件尺寸和图片不同时，图片正常显示，不过有缩放现象
  Image buildImageContain() {
    return const Image(
      width: 160,
      height: 60,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
    );
  }

  //在图片上加了一层带颜色的蒙板
  Image buildImageColorLighten() {
    return const Image(
      color: Colors.purpleAccent,
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
      colorBlendMode: BlendMode.lighten,
    );
  }

  //无法显示图片，不建议使用
  Image buildImageColorClear() {
    return const Image(
      color: Colors.purpleAccent,
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
      colorBlendMode: BlendMode.clear,
    );
  }

  //无法显示颜色，不建议使用
  Image buildImageColorDstIn() {
    return const Image(
      color: Colors.purpleAccent,
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
      colorBlendMode: BlendMode.dstIn,
    );
  }

  //无法显示图片，不建议使用
  Image buildImageColorDstOut() {
    return const Image(
      color: Colors.purpleAccent,
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
      colorBlendMode: BlendMode.dstOut,
    );
  }

  //图片和颜色混合显示
  Image buildImageColorDiff() {
    return const Image(
      color: Colors.purpleAccent,
      width: 100,
      height: 100,
      image: AssetImage("images/panda.jpeg"),
      fit: BoxFit.contain,
      filterQuality:FilterQuality.high,
      colorBlendMode: BlendMode.difference,
    );
  }

  ///给图片添加阴影，与183内容匹配
  Widget buildImageShadow() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.redAccent,
          blurRadius: 16,
          blurStyle: BlurStyle.solid,
        ),]

      ),
      child: const Image(
        width: 160,
        height: 100,
        image: AssetImage("images/panda.jpeg"),
        fit: BoxFit.fill,
        filterQuality:FilterQuality.high ,
      ),
    );
  }
}