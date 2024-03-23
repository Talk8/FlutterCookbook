import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

///主要介绍如何使用wechat_assets_picker这个包来创建具有wechat风格的
///标题中使用了自定义的内容，可以当作单独的内容来看
class ExMediaPickerLikeWechat extends StatefulWidget {
  const ExMediaPickerLikeWechat({super.key});

  @override
  State<ExMediaPickerLikeWechat> createState() => _ExMediaPickerLikeWechatState();
}

class _ExMediaPickerLikeWechatState extends State<ExMediaPickerLikeWechat> {
  AssetEntity? assetEntity ;
  List<AssetEntity>? assetEntityList;
  ///用来配置选择图片时的界面
  final AssetPickerConfig pickerConfig = const AssetPickerConfig(
    ///最多选择图片的数量，默认值为9
    maxAssets: 3,
    ///选择器网格数量，默认值为4
    gridCount: 2,
    ///图片文件大小，默认是80
    pageSize: 20,
  );

  final CameraPickerConfig cameraPickerConfig = const CameraPickerConfig(
    enableRecording: true, ///是否支持录像功能
    enableTapRecording: true, ///是否可以单击录像
    shouldAutoPreviewVideo: true,
    shouldDeletePreviewFile: true,
    resolutionPreset: ResolutionPreset.high, ///设定分辨率
    maximumRecordingDuration: Duration(seconds: 10),
    minimumRecordingDuration: Duration(seconds: 3),
  );

  ///显示和播放视频时使用
  VideoPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // title: Text("Example of Video Image Picker like wechat"),
        ///控制title内容与返回箭头之间的距离
        titleSpacing: 0.0,
        ///自定义的标题，取代简单的Text Widget组件,通过自定义可以实现一些复杂的标题.与400内容相匹配
        title: SizedBox(
          width: screenWidth/4,
          child: const Row(
            children: [
              ///使用Expand是为了显示长字符
              Expanded(
                child: Text("Example of Video Image Picker like wechat",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.favorite),
            ],
          ),
        ),
        ///Action的优先级大于Title，它会占用Title的空间，如果它的空间过大时会把Title覆盖掉
        ///比如把action3-5打开后就会覆盖Title的内容.与401内容相匹配
        actions: [
          SizedBox(
            width: 80,
              child: TextButton(
                onPressed: (){
                  showMenu(
                    context:context,
                    ///这个坐标值不好调整，下面我的经验值，位置在手指点击点的左下方，想往左移动给110+数字 往下移动180加数字
                    position: const RelativeRect.fromLTRB(170, 180, 110, 10),
                    items: [
                      ///建议指定value属性
                      PopupMenuItem<String>(
                        value: 'one',
                        onTap: ()=> debugPrint('tap one'),
                        child: const Text('1'),
                      ),
                      PopupMenuItem<String>(
                        value:'two',
                        onTap: ()=> debugPrint('tap two'),
                        child: const Text('2'),
                      ),
                      PopupMenuItem<String>(
                        value:'three',
                        onTap: ()=> debugPrint('tap three'),
                        child: const Text('3'),
                      ),
                    ],);
                },
                child: const Text("action1")),
          ),
          const SizedBox(
            width: 80,
            child: Text("action2"),
          ),
          // const SizedBox(
          //   width: 80,
          //   child: Text("action3"),
          // ),
          // const SizedBox(
          //   width: 80,
          //   child: Text("action4"),
          // ),
          // const SizedBox(
          //   width: 60,
          //   child: Text("action5"),
          // ),
        ],
      ),
      body: Column(
        children: [
          ///充当标题
          const Center(
              child: Text(" Picked image and video"),
          ),
          ///依据选择的文件类型显示所选择的内容，类型包含：image,video,audio,other，当前只能显示图片和视频
          Builder(builder: (context) {
           if(assetEntity == null)  {
             return const Text("selected nothing");
           }else {
             ///显示单张图片，图片大小为原图大小，没有缩放，没有选择文件时显示上面的文字.
             if(assetEntity?.type == AssetType.image) {
               return Image(image: AssetEntityImageProvider(assetEntity!,isOriginal: false),);
             }else if(assetEntity?.type == AssetType.video) {
               ///显示视频文件
               debugPrint("file path: ${assetEntity?.file.toString()}");
               ///如果controller为空就不去显示视频,因为获取controller是异步操作
               if(controller == null) {
                 return const Text("video is initializing");
               }else {
                 return Container(
                   color: Colors.white60,
                   width: assetEntity!.width.toDouble()/2,
                   height: assetEntity!.height.toDouble()/4,
                   child: AspectRatioVideo(controller),
                 );
               }
             }else {
               return const Text("Audio or other type");
             }
           }
          },),

          ///选择图片，此时会弹出图片Picker，和微信中的风格完全相同
          ///遗留问题：如何让picker通过context获取到Local,因为当前默认是中文文字，而且我的环境是英文？
          ///只要不在materialApp中通过locale属性指定当前语言环境就可以，context自动可以获取到当前语言环境
          ElevatedButton(
            onPressed: () async {
              debugPrint(" picker button clicked");
              ///选择下一个视频时清空当前的视频
              if(controller != null) {
                controller = null;
              }

              assetEntityList = await AssetPicker.pickAssets(context,pickerConfig: pickerConfig);
              ///如果选择了图片就更新assetEntity中的值，否则不去处理
              if(assetEntityList != null && assetEntityList!.isNotEmpty) {
                setState(() {
                  debugPrint(" update file of picker");
                  assetEntity = assetEntityList![0];
               });

                ///如果选择了视频就从assetEntity中的获取文件，然后再去创建controller
                ///注意：这个过程包含两个异步操作：获取assetEntity对象，然后从assetEntity对象中获取视频文件
                if(assetEntity != null && assetEntity!.type == AssetType.video) {
                    // assetEntity!.originFile.then((value) {
                  ///两种file都可以，不过要注意是异步操作
                    assetEntity!.file.then((value) {
                      ///这里获取到的是文件真实的路径：/storage/emulated/0/DCIM/Camera/xxx.mp4
                      debugPrint(" file path: ${value?.path}");
                      if(value != null) {
                        setState(() {
                          preViewVideo(value);
                        });
                      }
                    });
                  }
              }
            },
            child: const Text("Pick Image"),
          ),

          ///显示多张图片，可以做成provide，这样就可以使用consumer来显示图片
          Builder(
            builder: (context) {
              if(assetEntityList != null && assetEntityList!.length >1) {
                ///用来当作相框，用来限制相框的大小
                return Container(
                  color: Colors.lightBlue,
                  width: 80,
                  height: 100,
                  child: ListView(
                    scrollDirection:Axis.horizontal,
                    children: List.generate(assetEntityList!.length,
                            (index) => Padding( ///主要用来控制图片之间边距
                              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: Image(image: AssetEntityImageProvider(assetEntityList![index],isOriginal: false),
                                width: 40,height: 40,
                              ),
                            ),
                    ),
                  ),
                );
              }else {
                return const Text("image size is less then 2");
              }
            }
          ),
          ///通过cameraPicker来获取图片和视频，界面和wechat一样：轻按拍照长按录像，不过录像功能不能用，无法录制视频
          ElevatedButton(
            onPressed: () async {
              debugPrint("");
              ///可以不带config获取图片，但是不能获取视频
              // assetEntity = await CameraPicker.pickFromCamera(context);
              ///可以通过config获取图片和视频，并且对图片和视频做相关的配置，不过录像时按钮依次填充完，感觉不如直接显示录像时间好用
              ///这里没有添加显示视频的功能，只能显示拍照后的图片，不能显示录制后的视频。可以参考picImage按钮上的功能来实现
              assetEntity = await CameraPicker.pickFromCamera(context,pickerConfig: cameraPickerConfig);

              ///如果选择了图片就更新assetEntity中的值，否则不去处理
              if(assetEntity != null) {
                setState(() {});
              }
            },
            child: const Text("Pick Image by Camera"),
          ),
        ],
      ),
    );
  }

  ///预览视频文件,主要是初始化controller
  void preViewVideo(File file) async {
    debugPrint("init video controller");
    controller = VideoPlayerController.file(file);
    await controller?.setVolume(0.0);
    await controller?.initialize();
    await controller?.setLooping(true);
    await controller?.play();
  }
}


///从ex81中获取的类，用来显示和播放视频文件
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
      debugPrint(" video is not mounted");
      return;
    }

    if(controller == null) {
      return;
    }

    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      debugPrint(" update video controller state: ${initialized.toString()}");
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if(controller == null) {
      return;
    }
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void deactivate() {
    if (controller != null) {
      controller!.setVolume(0.0);
      controller!.pause();
    }

    super.deactivate();
  }

  @override
  void dispose() {
    if(controller == null) {
      return;
    }
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      debugPrint("show video");
      return Center(
        ///控制视频的宽高比
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    } else {
      return  const Text("video is not initialized");
    }
  }
}