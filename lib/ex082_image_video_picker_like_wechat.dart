import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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
  final AssetPickerConfig pickerConfig = const AssetPickerConfig(
    ///最多选择图片的数量，默认值为9
    maxAssets: 3,
    ///选择器网格数量，默认值为4
    gridCount: 2,

  );

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
              child: Text(" Picked image"),
          ),
          ///显示单张图片，没有选择时显示文字：no image
          (assetEntity == null) ? const Text("no image")
          :Image(image: AssetEntityImageProvider(assetEntity!,isOriginal: false),),

          ///选择图片，此时会弹出图片Picker，和微信中的风格完全相同
          ElevatedButton(
            onPressed: () async {
              debugPrint("");
              assetEntityList = await AssetPicker.pickAssets(context,pickerConfig: pickerConfig);
              ///如果选择了图片就更新assetEntity中的值，否则不去处理
              if(assetEntityList != null && assetEntityList!.isNotEmpty) {
                setState(() {
                  assetEntity = assetEntityList![0];
                });
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
                            ),),
                  ),
                );
              }else {
                return const Text("image size is less then 2");
              }
            }
          ),
        ],
      ),
    );
  }
}
