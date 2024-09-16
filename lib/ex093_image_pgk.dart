import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

///这个示例代码用来演示image插件，演示如何加载pgm文件
///这种pgm是一种2d栅格图文件

class Ex4View extends StatefulWidget {
  const Ex4View({super.key});

  @override
  State<Ex4View> createState() => _Ex4ViewState();
}

class _Ex4ViewState extends State<Ex4View> {

  ui.Image? _image;

  @override
  void initState() {
    // TODO: implement initState
    ///页面初始化时导入图片文件,这个文件的路径需在yaml文件中写好不然找不到
    loadPGMFile("images/ex_01map.pgm");
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    debugPrint(" build running");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image file of 2d format"),
      ),
      body: Column(
        children: [
          const Text("show image file ,which is 2d format"),
          ///用来显示PGM图像
          const SizedBox(height: 8,),
          Container(
            height: 80,
            color: Colors.lightGreen,
            child: _image == null ? const Text("image is null") : CustomPaint(painter:ImagePainter(_image!),),
          ),
        ],
      ),
    );


    // return threeJs.build();
  }

///通过自定义的Patin来画出图片
///pgm格式的图片无法直接通过Flutter中的Image组件显示，因为格式不支持
///显示pgm的整体思路：
///1 .从asset或者文件中读取图片，把内容转换成uint8list
///2. 用Image库把Uint8List转换成ui.Image文件
///3. 自定义组件把ui.Image图片绘制出来
///扩展：在自定义组件的基础上画轨迹和坐标，轨迹再定义一个画笔来画。
///坐标主要是计算：两个组件的宽度和高度与pgm文件自身的宽度和高度做比例，画面坐标乘以比例就是实际图像中的坐标。
///再扩展画面的绽放与画笔颜色定义，可以画出不同颜色的图像


  ///导入asset目录下的文件，path为具体的目录，
  ///后续可以修改成导入path路径下的文件，path是手机上的目录
  void loadPGMFile(String path) async {
    var fileContent =  await rootBundle.load(path);
    var lines = fileContent.buffer.asUint8List();
    var pImage = img.decodePnm(lines);

    if(pImage == null || pImage.isEmpty) {
      debugPrint( "image decode is null");
    } else {
      convertImageToFlutterUiImage(pImage).then((onValue) {
        setState(() {
          debugPrint( "image convert is ok");
          _image = onValue;
        });
      });
      debugPrint( "image decode is ok");
    }
  }


  ///把Image库中的格式转换成ui.Image格式,参考Image库在github上的示例
  Future<ui.Image> convertImageToFlutterUiImage(img.Image image) async {
    if (image.format != img.Format.uint8 || image.numChannels != 4) {
      final cmd = img.Command()
        ..image(image)
        ..convert(format: img.Format.uint8, numChannels: 4);
      final rgba8 = await cmd.getImageThread();
      if (rgba8 != null) {
        image = rgba8;
      }
    }

    ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(image.toUint8List());

    ui.ImageDescriptor id = ui.ImageDescriptor.raw(
        buffer,
        height: image.height,
        width: image.width,
        pixelFormat: ui.PixelFormat.rgba8888);

    ui.Codec codec = await id.instantiateCodec(
        targetHeight: image.height,
        targetWidth: image.width);

    ui.FrameInfo fi = await codec.getNextFrame();
    ui.Image uiImage = fi.image;

    return uiImage;
  }

}



///自定义的组件，主要用来绘制image
class ImagePainter extends CustomPainter {
  Paint? mPaint;

  ui.Image? mImage;

  ImagePainter(ui.Image img) {
    mPaint = Paint()
      ..isAntiAlias = true;
    mImage = img;
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // TODO: implement paint
    if (mPaint == null || mImage == null) {
      debugPrint(" null member");
    } else {
      canvas.drawImage(mImage!, const ui.Offset(0, 0), mPaint!);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return true;
  }
}
