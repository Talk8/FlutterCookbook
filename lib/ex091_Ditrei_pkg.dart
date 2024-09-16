import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:image/image.dart' as img;

import 'package:ditredi/ditredi.dart';
// import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

///这个示例代码主要介绍ditredi和flutter_3d_controller这两个插件的用法，
///它们都可以绘制简单的3d效果,详细介绍可以看yaml中的介绍
///另外本文件中还使用了image插件中的方法来显示pgm文件，不过失败了。

class ExTestThree extends StatefulWidget {
  const ExTestThree({super.key});

  @override
  State<ExTestThree> createState() => _ExTestThreeState();
}

class _ExTestThreeState extends State<ExTestThree> {


  ///通过Image插件读取PGM文件的代码和方法，可以看到List中的内容，但是无法解码此格式的文件
  Uint8List _pgmFile = Uint8List(0);

  List<Face3D> _face3DList = [];

  Map<String,dynamic> parseHeader(List<String> headerLines) {
    final headInfo = <String,dynamic>{};

    ///第二行是图片的长度和宽度
    final dimensions = headerLines[1].split(' ');
    headInfo['width'] = int.parse(dimensions[0]);
    headInfo['height'] = int.parse(dimensions[2]);

    ///第三行是图片的最大灰度值
    headInfo['maxGrayLevel'] = int.parse(dimensions[3]);

    return headInfo;
  }

  Future<Image?> decodeImage(int width,int height, Uint8List imageData) async {

    Image? image ;
    await decodeImageFromList(imageData).then((value) => image = value as Image);

    return image;
  }


  ///直接读取文件内容
  Future<void> loadPGMImage() async {
    // final bytes = await File("/images/aj02map.pgm").readAsBytes();
    // return bytes;
    ///images下的文件会被打包到apk中，读取这类资源文件时需要使用rootBundle还不是通过file读取文件
    ///后续换成文件系统中的内容比较好，这样不需要打包apk,直接读取文件系统中的文件就可以
    final bytes = await rootBundle.load('images/aj02map.pgm');
    final content = utf8.decode(bytes.buffer.asUint8List());

    final allLines = content.split('\n');

    ///跳过前3行的内容
    // final skippedLines = allLines.skip(3).toList();
    ///这个文件的前3行多了一行注释，在第二行
    final skippedLines = allLines.skip(4).toList();

    ///恢复成原来的内容，也就是带行
    final remainingContent = skippedLines.join('\n');

    _pgmFile = utf8.encode(remainingContent);

    final headerInfo = parseHeader(allLines.take(4).toList());
    final width = headerInfo['width'];
    final height = headerInfo['height'];

    decodeImage(width,height,_pgmFile);

    setState(() {
      // _text = content.buffer.asUint8List().toHex().toString();
      // _pgmFile = content.buffer.asUint8List(4);
      // _pgmFile = skippedLines;
      // _text = _pgmFile.toHex().toString();

      // debugPrint(" pgm data: ${_text}");
    });
  }

  ///把文件内容读取成可读的字符串
  Future<List<vector.Vector3>> loadPGMImageAsString() async {
    // final bytes = await File("/images/aj02map.pgm").readAsBytes();
    // return bytes;
    ///images下的文件会被打包到apk中，读取这类资源文件时需要使用rootBundle还不是通过file读取文件
    final contents = await rootBundle.loadString('images/cloudGlobal.pcd');
    final contentsWithLine = contents.split('\n');
    List<vector.Vector3> pointList = [];
    bool dataSectionFound = false;


    debugPrint("loadPGMImageAsString ");

    ///跳过数据头找到数据行
    for(var line in contentsWithLine) {
      if( line.startsWith('DATA ascii')){
        dataSectionFound = true;
        continue;
      }

      ///读取数据
      if(dataSectionFound) {
        final values = line.split(' ').where((element) => element.isNotEmpty).map((e) => double.parse(e)).toList();
        ///每行4个数据
        if(values.length >= 4) {
          pointList.add(vector.Vector3(values[0]*1, values[1]*1, values[2]*1));
          // debugPrint(" get String: ${values.toString()}");
        }else {
          debugPrint(" String length: ${values.toString()}");
        }
      }
    }

    return Future.value(pointList);
  }

  ///从文件中读取face数据
  Future<List<Face3D>> _getFace3D ()async {
    return await ObjParser().loadFromResources("images/pool.obj");
  }

  ///生成立方体数据
  List<Face3D> _facesFuture = [];
  List<Cube3D> _cubesFuture = [];

  List<Cube3D> _getCubes ()  {
    final colors = [
      Colors.grey.shade200,
      Colors.grey.shade300,
      Colors.grey.shade400,
      Colors.grey.shade500,
      Colors.grey.shade600,
      Colors.grey.shade700,
      Colors.grey.shade800,
      Colors.grey.shade900,
    ];

    debugPrint("_getCubes ");
    List<Cube3D> result = [];

    int count = 0;
    loadPGMImageAsString()
    .then((value) {
      count = value.length;
      // debugPrint("check data count : ${count}");
      for(int i=0; i<count; i++) {
        // debugPrint("check data: ${value[i].toString()}");
        result.add(Cube3D(0.2, value[i], color: colors[(colors.length - i) % colors.length],),);
      }

      debugPrint(" --- setState --");
      setState(() {
        // debugPrint("show data: ${result.toString()}");
        _cubesFuture = result;
      });
      return result;
    })
    .onError((error, stackTrace) => result)
    .whenComplete(() => result);

    return result;
  }

  ///生成平面数据
  List<Face3D> _getFaces ()  {
    final colors = [
      Colors.grey.shade200,
      Colors.grey.shade300,
      Colors.grey.shade400,
      Colors.grey.shade500,
      Colors.grey.shade600,
      Colors.grey.shade700,
      Colors.grey.shade800,
      Colors.grey.shade900,
    ];

    debugPrint("_getFaces");
    List<Face3D> result = [];

    int count = 0;
    loadPGMImageAsString()
        .then((value) {
      count = value.length;
      // debugPrint("check data count : ${count}");
      for(int i=0; i<count-2; i++) {
        // debugPrint("check data: ${value[i].toString()}");
        result.add(Face3D.fromVertices(value[i],value[i+1],value[i+2], color: colors[(colors.length - i) % colors.length],),);
      }

      debugPrint(" --- setState --");
      setState(() {
        // debugPrint("show data: ${result.toString()}");
         _facesFuture = result;
      });
      return result;
    })
        .onError((error, stackTrace) => result)
        .whenComplete(() => result);

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    loadPGMImage();
    super.initState();
    _getCubes();
    _getFaces();
    _getFace3D().then((value) {
      setState(() {
        _face3DList = value;
      });
    });

    _flutter3dController.pauseAnimation();
  }

  final Flutter3DController _flutter3dController = Flutter3DController();

  @override
  Widget build(BuildContext context) {

    // var _displayMode = DisplayMode.cubes;

    final cubes = _generateCubes();
    final points = _generatePoints().toList();


    ///旋转相关的控制器
    final ditController = DiTreDiController(
      // rotationX: -20,
      // rotationY: 30,
      rotationX: 0,
      rotationY: 60,
      rotationZ: 60,
      light: vector.Vector3(-0.5,-0.5,0.5),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Example for load 3D file"),
      ),
      ///这个代码是Image插件读取PGM格式文件的代码，无法读取文件信息，可以看注释
      /*
      body: Builder(
        builder: (context) {

          final image = img.Image(width: 300,height: 300);
          debugPrint(" data: ${_text}");


          for(var pixl in image) {
            pixl..r = pixl.x;
            pixl..g = pixl.y;
            // debugPrint(" pixel: ${pixl.toString()}");
          }


          final png;
          if(_pgmFile.isEmpty) {
            debugPrint(" load create image");
            png = img.encodePng(image);
            return Image.memory(png,fit: BoxFit.contain,);
          }else {
            ///下面两个方法都无法解码pgm格式的文件
            // img.Image? pgmImage = img.decodePnm(_pgmFile);
            img.Image? pgmImage = img.decodeImage(_pgmFile);
            if(pgmImage == null) {
              png = img.encodePng(image);
              debugPrint(" load create image _pgm: ${_pgmFile.toString()}");
              debugPrint(" load create image because decode null image");
              return Image.memory(png,fit: BoxFit.contain,);
            }else {
              var pgm2png = img.encodePng(pgmImage!);
              debugPrint(" load pgm image ");
              return Image.memory(pgm2png,fit: BoxFit.contain,);
            }
          }
        }
      ),
       */
      body: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.vertical,
        children: [
          const Text("test data"),
          Builder(
            builder: (context) {
              img.Image? pnmImage;
              ///这个方法读取不到数据
              img.decodePnmFile("/images/aj02map.pgm").then((value) {
                setState(() {
                  pnmImage = value;
                });
              });
              if(pnmImage == null) {
                return const Text("image is null");
              } else {
                // return img.Image.from(pnmImage);
                return const Text("image is null");
              }
            }
          ),

          Container(
            color: Colors.blueAccent,
            width: 400,
            height: 300,
            ///带Draggable的可以滑动到不同的角度来观看,两个XXXDraggable组件都可以使用
            // child: DiTreDiDraggable(
            child: DiTreDiAlternativeDraggable(
              controller: ditController,
              child: DiTreDi(
                ///该数据会产生类似魔方的效果
                figures: cubes.toList(),
                ///显示不同数据源产生的效果
                // figures: _cubesFuture ?? cubes.toList(),
                // figures: _facesFuture,
                ///这个没有效果
                // figures: _generateMesh().toList(),
                // figures: Face3D.fromVertices(vector.Vector3(-10,-20,2), vector.Vector3(0,2,0), vector.Vector3(2,0,0)).toLines(),
                ///该数据会产生散热片效果
                // figures: _getData(),
                controller: ditController,
              ),
              // child: DiTreDi(
              //   figures: _face3DList ?? [] ,
              //   controller: ditController,
              // ),
            ),

            ///使用Flutter3DController显示3d图形
            // child: Flutter3DViewer(
            //   progressBarColor: Colors.yellowAccent,
            //   controller: _flutter3dController,
            //   ///只支持glb,gltf格式
            //   src: 'images/pool.obj',
            // ),
          ),

          Container(
            color: Colors.blue,
            width: 400,
            height: 100,
            child: DiTreDi(
              figures: points,
              controller: ditController,
              config: const DiTreDiConfig(
                defaultLineWidth: 100,
                supportZIndex: false,
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*本例子中没有使用这段代码
class MyCustomPathHandler extends CustomPathHandler {
  MyCustomPathHandler({required super.path});


  @override
  Future<WebResourceResponse?> handle(String path) async{
    // TODO: implement handle
    try {
      final assetPath = path.replaceFirst("flutter_assets/", "");
      final data = await rootBundle.load(assetPath);

      return WebResourceResponse(
        contentType: lookupMimeType(path),
        data: data.buffer.asUint8List(),
      );
    } catch (e) {
      if(kDebugMode) {
        print(e);
      }
    }
    // return super.handle(path);
    return WebResourceResponse(data: null);
  }
}

InAppWebViewSettings settings = InAppWebViewSettings(
    webViewAssetLoader: WebViewAssetLoader(
        pathHandlers: [
          AssetsPathHandler(path: "/images/")
        ]
    )
);
 */

///生成多个立方体数据
Iterable<Cube3D> _generateCubes () sync* {
  final colors = [
    Colors.grey.shade200,
    Colors.grey.shade300,
    Colors.grey.shade400,
    Colors.grey.shade500,
    Colors.grey.shade600,
    Colors.grey.shade700,
    Colors.grey.shade800,
    Colors.grey.shade900,
  ];

  const count = 8;
  for(var x = count; x > 0; x--){
    for(var y = count; y > 0; y--) {
      for(var z= count; z > 0; z--) {
        yield Cube3D(0.9,///控制第一个点的大小，超过1后就快生成面了
          vector.Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          ),
          color: colors[(colors.length - y) % colors.length],
        );
      }
    }
  }
}

///生成数据的方法相同，只是数据类型不同，都是参考官网的示例
Iterable<Point3D> _generatePoints() sync* {
  const count = 10;
  for(var x = 0; x < count; x++){
    for(var y = 0; y < count; y++) {
      for(var z= 0; z < count; z++) {
        yield Point3D(
          vector.Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          ),
        );
      }
    }
  }
}


///生成数据的方法相同，只是数据类型不同，都是参考官网的示例
Iterable<Mesh3D> _generateMesh() sync* {
  // Iterable<Face3D> _generateMesh() sync* {
  final colors = [
    Colors.grey.shade200,
    Colors.grey.shade300,
    Colors.grey.shade400,
    Colors.grey.shade500,
    Colors.grey.shade600,
    Colors.grey.shade700,
    Colors.grey.shade800,
    Colors.grey.shade900,
  ];

  List<Face3D> face3dList = [];

  const count = 10;
  for(var x = 0; x < count; x++){
    for(var y = 0; y < count; y++) {
      for(var z= 0; z < count; z++) {
          vector.Vector3 v1 = vector.Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          );

          vector.Vector3 v2 = vector.Vector3(
            x.toDouble() * 2 + 4,
            y.toDouble() * 2 + 4,
            z.toDouble() * 2 + 4,
          );

          vector.Vector3 v3 = vector.Vector3(
            x.toDouble() * 2 -4,
            y.toDouble() * 2 -4,
            z.toDouble() * 2 -4,
          );

          debugPrint("${Face3D.fromVertices(v1, v2, v3,color: colors[(colors.length - y) % colors.length]).triangle.point0}");
          // yield Face3D.fromVertices(v1, v2, v3,color: colors[(colors.length - y) % colors.length]);

        face3dList.add( Face3D.fromVertices(v1, v2, v3,color: colors[(colors.length - y) % colors.length]) );
        debugPrint("Mesh3d : ${Mesh3D(face3dList).toString()}");
        yield Mesh3D(face3dList);
      }
    }
  }
}

///生成面相关的数据，效果就是像散热片或者暖气片一样的效果
List<Face3D> _getData() {
  List<Face3D> face3dList = [];
  // List<Point3D> face3dList = [];
  // face3dList.add(Face3D.fromVertices(vector.Vector3(0,0,2), vector.Vector3(0,2,0), vector.Vector3(2,0,0),color: Colors.redAccent));
  // face3dList.add(Face3D.fromVertices(vector.Vector3(3,9,4), vector.Vector3(8,9,1), vector.Vector3(2,8,2),color: Colors.purple));
  // face3dList.add(Face3D.fromVertices(vector.Vector3(0,4,8), vector.Vector3(7,2,1), vector.Vector3(1,9,3),color: Colors.yellow));
  // Mesh3D();
  int count = 8;
  int yCount = 16;
  double pointWidth = 32;

  for(var x = 0; x < count; x++){
    for(var y = 0; y < yCount; y++) {
      for (var z = 0; z < count; z++) {
        if(x == 0) {
          double xx = x * 2.0;
          double yy = y * 2.0;
          double zz = z * 2.0;
          // face3dList.add(Point3D( vector.Vector3(xx, yy, zz), width: pointWidth, color: Colors.redAccent));
          face3dList.add(Face3D.fromVertices(vector.Vector3(xx,yy,zz), vector.Vector3(zz,yy,xx), vector.Vector3(xx,zz,yy),color: Colors.redAccent));
        }
        if(x == count-1) {
          double xx = x * 2.0;
          double yy = y * 2.0;
          double zz = z * 2.0;
          // face3dList.add(Point3D( vector.Vector3(xx, yy, zz), width: pointWidth, color: Colors.redAccent));
          face3dList.add(Face3D.fromVertices(vector.Vector3(xx,yy,zz), vector.Vector3(xx,yy,zz), vector.Vector3(xx,yy,zz),color: Colors.redAccent));
        }

        if(y == 0) {
          double xx = x * 2.0;
          double yy = y * 2.0;
          double zz = z * 2.0;
          // face3dList.add(Point3D( vector.Vector3(xx, yy, zz), width: pointWidth, color: Colors.blue));
          face3dList.add(Face3D.fromVertices(vector.Vector3(xx,yy,zz), vector.Vector3(xx,yy,zz), vector.Vector3(xx,yy,zz),color: Colors.blue));
        }
        if(y == yCount-1) {
          double xx = x * 2.0;
          double yy = y * 2.0;
          double zz = z * 2.0;
          // face3dList.add(Point3D( vector.Vector3(xx, yy, zz), width: pointWidth, color: Colors.blue));
          face3dList.add(Face3D.fromVertices(vector.Vector3(xx,yy,zz), vector.Vector3(xx,yy,zz), vector.Vector3(xx,yy,zz),color: Colors.blue));
        }

        if(z == 0) {
          double xx = x * 2.0;
          double yy = y * 2.0;
          double zz = z * 2.0;
          // face3dList.add(Point3D( vector.Vector3(xx, yy, zz), width: pointWidth, color: Colors.yellow));
          face3dList.add(Face3D.fromVertices(vector.Vector3(xx,yy,zz), vector.Vector3(xx,yy,zz), vector.Vector3(xx,yy,zz),color: Colors.yellow));
        }
        if(z == count-1) {
          double xx = x * 2.0;
          double yy = y * 2.0;
          double zz = z * 2.0;
          // face3dList.add(Point3D( vector.Vector3(xx, yy, zz), width: pointWidth, color: Colors.yellow));
          // face3dList.add(Face3D.fromVertices(vector.Vector3(xx,yy,zz), vector.Vector3(xx,yy,zz), vector.Vector3(xx,yy,zz),color: Colors.redAccent));
        }
      }
    }
  }
  return face3dList;
}