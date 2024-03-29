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
  List<XFile>? _multiMediaFileList;

  final ImagePicker imagePicker = ImagePicker();

  VideoPlayerController? _controller;

  XFile? _videoFile;

  double imgWidth = 200;
  double imgHeight = 400;

  ///注意获取图片需要异步操作
  Future<XFile?> getImageFile() async {
    var imgFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: imgWidth,
      maxHeight: imgHeight,
      imageQuality: 10,
    );
    return imgFile;
  }

  ///获取多张图片：注意获取图片需要异步操作
  Future<List<XFile>> getImageFiles() async {
    debugPrint('get img file future running');
    var list = await imagePicker.pickMultiImage(
        maxWidth: imgWidth, maxHeight: imgHeight, imageQuality: 10);
    return list;
  }

  Future<XFile?> getVideoFiles() async {
    var list = await imagePicker.pickVideo(source: ImageSource.gallery);
    return list;
  }

  Future<XFile?> getVideoByCamera() async {
    var list = await imagePicker.pickVideo(source: ImageSource.camera);
    return list;
  }

  ///获取单个图片或者视频文件，需要对获取到的文件判断文件类型
  Future<XFile?> getMedia() async {
    var file = await imagePicker.pickMedia(
        maxHeight: imgHeight, maxWidth: imgWidth, imageQuality: 100);
    return file;
  }

  ///加一个判断文件类型的操作
  Future<List<XFile>> getMultiMedia() async {
    var list = await imagePicker.pickMultipleMedia(
        maxHeight: imgHeight, maxWidth: imgWidth, imageQuality: 100);
    return list;
  }

  ///预览视频文件
  void preViewVideo(XFile file) async {
    _controller = VideoPlayerController.file(File(file.path));
    await _controller?.setVolume(0.0);
    await _controller?.initialize();
    await _controller?.setLooping(true);
    await _controller?.play();

    // return AspectRatioVideo(_controller);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double row1Height = screenHeight / 30;
    double row2Height = screenHeight * 3 / 30;
    double row3Height = screenHeight * 5 / 30;
    double row4Height = screenHeight * 7 / 30;
    double row5Height = screenHeight * 8 / 30 + 24;
    double row6Height = screenHeight * 11 / 30;
    double row7Height = screenHeight * 14 / 30;

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
                    getImageFile().then((value) {
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
                _mediaFile == null
                    ? const Icon(Icons.image)
                    : (_mediaFile!.path.isEmpty
                        ? const Text("do not select image")
                        : Image.file(
                            File(_mediaFile!.path),
                            width: imgWidth,
                            height: imgHeight,
                            errorBuilder: (context, error, trace) {
                              return Text("load image error: $error");
                            },
                          ))
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
              child: const Text("load multi image"),
            ),
          ),

          ///第三行内容：配合第二行显示多张图片，用水平列表显示
          Positioned(
            top: row3Height,
            left: 0,
            width: screenWidth,
            height: screenHeight / 3,

            ///这是一个水平方向的列表
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _mediaFileList == null ? 1 : _mediaFileList?.length,
              itemBuilder: (context, index) {
                return (_mediaFileList == null
                    ? const Text("default image")
                    : (_mediaFileList!.isEmpty
                        ? const Text("do not select image")
                        : Row(
                            children: [
                              Image.file(
                                File(_mediaFileList![index].path),
                                width: imgWidth,
                                height: imgHeight,
                                errorBuilder: (context, error, trace) {
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
                          )));
              },
            ),
          ),

          ///第四行内容：点击按钮添加视频
          Positioned(
            top: row4Height,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    getVideoFiles().then((value) {
                      // getVideoByCamera().then((value) {
                      debugPrint('get video file future->then running');

                      ///因为是异步，所以需要通过setState更新数据源
                      setState(() {
                        ///返回的路径是app下的缓冲目录：data/user/0/com.cookbook.flutter.fluttercookbook/cache/scaled_1000000010.jpg
                        // debugPrint("path: v${value[0].path}");
                        _videoFile = value;
                        preViewVideo(_videoFile!);
                      });
                    });
                  },
                  child: const Text("load video"),
                ),
                _videoFile == null
                    ? const Text("no video file")
                    : (_videoFile!.path.isEmpty
                        ? const Text("do not select video file")
                        :
                        // Text("video is playing")
                        Container(
                            width: 240,
                            height: 320,
                            alignment: Alignment.center,
                            child: AspectRatioVideo(_controller),
                          )),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),

          ///第五内容：
          Positioned(
            top: row5Height,
            left: 0,
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    getMultiMedia().then((value) {
                      setState(() {
                        _multiMediaFileList = value;
                      });
                    });
                  },
                  child: const Text("load multiMedia"),
                ),
                const Icon(Icons.add)
              ],
            ),
          ),

          ///第六行内容：配合第五行显示多张图片或者视频，用水平列表显示
          Positioned(
            top: row6Height,
            left: 0,
            width: screenWidth,
            height: screenHeight / 3,

            ///这是一个水平方向的列表
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount:
                  _multiMediaFileList == null ? 1 : _multiMediaFileList?.length,
              itemBuilder: (context, index) {
                return (_multiMediaFileList == null
                    ? const Text("default image")
                    : (_multiMediaFileList!.isEmpty
                        ? const Text("do not select image")
                        : Row(
                            children: [
                              Image.file(
                                File(_multiMediaFileList![index].path),
                                width: imgWidth,
                                height: imgHeight,
                                errorBuilder: (context, error, trace) {
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
                          )));
              },
            ),
          ),

          ///第七行内容：用来显示视频播放按钮，显示播放或者暂停，点击时可以播放或者暂停视频，这个视频位于第四行
          Positioned(
            top: row7Height,
            left: 16,
            child: Container(
              width: 64,
              color: Colors.green,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _controller!.value.isPlaying
                        ? _controller?.pause()
                        : _controller?.play();
                  });
                },
                icon: _controller == null
                    ? const Icon(Icons.video_call)
                    : (Icon(_controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo(this.controller, {super.key});

  ///用来控制视频的播放，停止，暂停等功能
  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        ///控制视频的宽高比
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    } else {
      return Container();
    }
  }
}
