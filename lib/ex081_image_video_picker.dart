import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

///这个文件是基于imagePicker官方示例自己实现的内容，也就是ex081_filePicker中的内容
class ExImageVideoPicker extends StatefulWidget {
  const ExImageVideoPicker({super.key});

  @override
  State<ExImageVideoPicker> createState() => _ExImageVideoPickerState();
}

class _ExImageVideoPickerState extends State<ExImageVideoPicker> {

  XFile? _mediaFile;
  List<XFile>? _mediaFileList;
  final ImagePicker imagePicker = ImagePicker();

  XFile? _videoFile;

  double imgWidth = 200;
  double imgHeight = 400;

 ///注意获取图片需要异步操作
  Future<XFile?> getImageFile () async {
    var imgFile =  await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth:imgWidth,
        maxHeight: imgHeight,
        imageQuality: 10, );
    return imgFile;
  }
  ///获取多张图片：注意获取图片需要异步操作
  Future<List<XFile>> getImageFiles () async {
    debugPrint('get img file future running');
    var list =  await imagePicker.pickMultiImage(
        maxWidth:imgWidth,
        maxHeight: imgHeight,
        imageQuality: 10);
    return list;
  }

  Future<XFile?> getVideoFiles() async {
    var list = await imagePicker.pickVideo(source: ImageSource.gallery);
    return list;
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double row1Height = screenHeight/30;
    double row2Height = screenHeight*3/30;
    double row3Height = screenHeight*5/30;
    double row4Height = screenHeight*7/30;
    double row5Height = screenHeight*8/30;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: const Text("Example of Image and Video Picker"),
      ),
      body: Stack(
        children: [
          Positioned(
            top: row1Height,
            left: 0,
            child: Row(
              children: [

                ///第一行：点击按钮添加单张图片
                ///方法:通过imagePicker.pickMultiImage()获取图片，弹出的文件选择器由包提供
                ///开始时文件目录为null，点击按钮后可以获取文件按钮，如果没有选择图片那么目录不为空但是为empty
                ///点击按钮后开始更新操作，注意异步处理
                ElevatedButton(
                    onPressed: () {
                     getImageFile()
                     .then((value) {
                       ///因为是异步，所以需要通过setState更新数据源
                       setState(() {
                         ///返回的路径是app下的缓冲目录：data/user/0/com.cookbook.flutter.fluttercookbook/cache/scaled_1000000010.jpg
                         // debugPrint("path: v${value[0].path}");
                         _mediaFile = value;
                       });
                     });
                    },
                    child: const Text("Load Image"),
                ),
                ///最开始运行时为空，没有选择图片时为empty,
                _mediaFile == null? const Icon(Icons.image) :
                (_mediaFile!.path.isEmpty ? const Text("do not select image") :
                  Image.file(
                    File(_mediaFile!.path),
                    width: imgWidth,
                    height: imgHeight,
                    errorBuilder: (context,error,trace) {
                      return Text("load image error: $error");
                    },
                  )
                )
              ],
            ),
          ),
          ///第二行：点击按钮添加多张图片
          Positioned(
            top: row2Height,
            left: 0,
            child: ElevatedButton(
              onPressed: () {
                debugPrint('bt clicked');
                getImageFiles().then((value) {
                  debugPrint('get img file future->then running');
                  ///因为是异步，所以需要通过setState更新数据源
                  setState(() {
                    ///返回的路径是app下的缓冲目录：data/user/0/com.cookbook.flutter.fluttercookbook/cache/scaled_1000000010.jpg
                    // debugPrint("path: v${value[0].path}");
                    _mediaFileList = value;
                  });
                });
              },
              child: const Text("load multi image"),),
          ),
          ///第三行内容：配合第二行显示多张图片，用水平列表显示
          Positioned(

            top: row3Height,
            left: 0,
            width: screenWidth,
            height: screenHeight/3,
            ///这是一个水平方向的列表
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _mediaFileList == null ? 1 :_mediaFileList?.length,
                itemBuilder: (context,index) {
                  return (_mediaFileList == null? const Text("default image"):
                      (_mediaFileList!.isEmpty? const Text("do not select image") :
                          Row(
                            children: [
                              Image.file(
                                File(_mediaFileList![index].path),
                                  width: imgWidth,
                                  height: imgHeight,
                                  errorBuilder: (context,error,trace) {
                                    return Text("load image error: $error");
                                  },
                              ),
                              ///thickness用来控制分隔线的高度
                              Container(
                                color: Colors.lightGreen,
                                width: 4,
                                  height: imgHeight,
                                  ///单独使用divider没有效果，需要在外层嵌套一个容器,感觉水平时不好用，不如直接用容器
                                  // child: Divider(color: Colors.purpleAccent,thickness: imgHeight,height:20),
                                  child: const SizedBox.shrink(),
                              ),
                            ],
                          )
                      )
                  );
                },
            ),
          ),
          ///第四行内容：点击按钮添加视频
          Positioned(
            top: row4Height,
            left: 0,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    getVideoFiles().then((value) {
                      debugPrint('get video file future->then running');
                      ///因为是异步，所以需要通过setState更新数据源
                      setState(() {
                        ///返回的路径是app下的缓冲目录：data/user/0/com.cookbook.flutter.fluttercookbook/cache/scaled_1000000010.jpg
                        // debugPrint("path: v${value[0].path}");
                        _videoFile = value;
                      });
                    });
                  },
                  child: const Text("load video"),
                ),
                _videoFile == null ? Text("no video file") :
                (_videoFile!.path.isEmpty? Text("do not select video file"):
                    Text("no video file")
                ),


              ],
            ),
          )
        ],
      ),
    );
  }
}
