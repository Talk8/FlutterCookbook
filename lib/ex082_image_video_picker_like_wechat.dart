import 'package:flutter/material.dart';

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
        titleSpacing: 60.0,
        title: SizedBox(
          width: screenWidth/2,
          child: Row(
            children: [
              Expanded(
                child: Text("Example of Video Image Picker like wechat",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.post_add),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: 30,
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
                child: Text("action1")),
          ),
          SizedBox(
            width: 30,
            child: Text("action2"),
          ),
          SizedBox(
            width: 30,
            child: Text("action3"),
          ),
          SizedBox(
            width: 30,
            child: Text("action4"),
          ),
        ],
      ),
      body: Column(
        children: [
          Text("datahelll "),
        ],
      ),
    );
  }
}
