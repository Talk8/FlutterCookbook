import 'package:flutter/material.dart';

///主要介绍如何使用wechat_assets_picker这个包来创建具有wechat风格的
///标题中使用了自定义的内容，可以当作单独的内容来看
class ExMediaPickerLikeWechat extends StatefulWidget {
  const ExMediaPickerLikeWechat({super.key});

  @override
  State<ExMediaPickerLikeWechat> createState() => _ExMediaPickerLikeWechatState();
}

class _ExMediaPickerLikeWechatState extends State<ExMediaPickerLikeWechat> {
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
      body: const Column(
        children: [
          Text("datahelll "),
        ],
      ),
    );
  }
}
