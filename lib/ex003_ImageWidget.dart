//这个代码和第六回Image Widget的内容匹配,183添加了图片阴影
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ExImage extends StatefulWidget {
  const ExImage({Key?key}) : super(key: key);

  @override
  State<ExImage> createState() => _ExImageState();
}

class _ExImageState extends State<ExImage> {
  ///对应目录：storage/emulated/0/Android/data/package_name/files
  Future<Directory?>? _externalDocumentsDirectory;
  String filePath = "";

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


    _externalDocumentsDirectory = getExternalStorageDirectory();
    _externalDocumentsDirectory?.then((value) {
      debugPrint("current path: ${value?.path} ");
      setState(() {
        filePath = "${value?.path}/switch.png";
      });
    });

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
          // buildImageFill(),
          Image.network("https://openweathermap.org/img/wn/04d@2x.png",
            color: Colors.yellow,
            width: 60,height: 60,
            loadingBuilder: (context,widget,loadProgress) {
              debugPrint("loading img: $loadProgress");
              ///导入完成后这个值为Null,
              if(loadProgress == null) {
                return widget;
              }else {
                return const Icon(Icons.sunny,color: Colors.red,);
              }
            },
            errorBuilder: (context,error,track) {
              debugPrint("loading img error ${error.toString()}");
              return const Icon(Icons.cloud,color: Colors.green,);
            },
          ),
          ///显示本地图片，需要在对应目录下放一个名叫switch.png的文件才能显示文件,否则通过
          ///text显示错误信息
          Image.file(
            File(filePath),
            width: 200,
            height: 200,
            alignment: Alignment.center,
            fit: BoxFit.fill,
            ///处理文件导入正确相关的内容
            frameBuilder:(context,child,frame,wasSynchronouslyLoaded) {
              if(wasSynchronouslyLoaded) {
                return child;
              }else {
                // return Text("frame:${frame.toString()}");
                return child;
              }
            },
            ///处理文件导入错误相关的内容
            errorBuilder: (context,error,trace) {
              debugPrint("load file error: ${error.toString()}");
              return Text(error.toString());
            },
          ),
          ///显示时打开注释，因为页面高度够用
          // buildImageShadow(),
          // buildImageOpacity(),
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

  ///给图片添加透明度的两种方法： 与222内容匹配
  Widget buildImageOpacity() {
    // return const Image(
    //   opacity: AlwaysStoppedAnimation(0.2),
    //   width: 160,
    //   height: 100,
    //   image: AssetImage("images/panda.jpeg"),
    //   fit: BoxFit.fill,
    //   filterQuality:FilterQuality.high ,
    // );
    return const Opacity(
      opacity: 0.6,
      child: Image(
        opacity: AlwaysStoppedAnimation(0.2),
        width: 160,
        height: 100,
        image: AssetImage("images/panda.jpeg"),
        fit: BoxFit.fill,
        filterQuality:FilterQuality.high ,
      ),
    );
  }
}