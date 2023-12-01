import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///自定义Radio组件，类似单选按钮，可以自行修改组件外观.与184的内容相匹配
///难点是实现互斥状态，也就间单选功能，一组按钮中有且仅有一个能被选择

class ExMutexWidget extends StatefulWidget {
  const ExMutexWidget({super.key});

  @override
  State<ExMutexWidget> createState() => _ExMutexWidgetState();
}

class _ExMutexWidgetState extends State<ExMutexWidget> {
  int groupId = 0;

  ///在页面启动前设置为竖屏，在页面退出后恢复原来的设置,与185内容相匹配
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of CusMutexWidget"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        ///使用多个组件，主要是实现修改组id的方法，同时使用setState方法刷新所有组件的状态
        child: ListView(
          children: [
            MutexWidget(groupValue: groupId, index:1, itemSelected: (v){
              setState(() {
                groupId = v;
              });
            }),
            const SizedBox(height: 16,),
             MutexWidget(groupValue: groupId, index:2, itemSelected: (v){
              setState(() {
                groupId = v;
              });
            }),
            const SizedBox(height: 16,),
             MutexWidget(groupValue: groupId, index:3, itemSelected: (v){
              setState(() {
                groupId = v;
              });
            }),
            const SizedBox(height: 16,),
             MutexWidget(groupValue: groupId, index:4, itemSelected: (v){
              setState(() {
                groupId = v;
              });
            }),
            const SizedBox(height: 16,),
             MutexWidget(groupValue: groupId, index:5, itemSelected: (v){
              setState(() {
                groupId = v;
              });
            }),
            const SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }
}

///修改组id的方法类型
typedef ItemSelected<T> = void Function(T value);

///单个Radio组件
class MutexWidget extends StatefulWidget {
  const MutexWidget({super.key,required this.groupValue, required this.index,
    required this.itemSelected,
  });

  ///索引id和组id,以及修改组id的方法都写成组件的属性
  final int groupValue;
  final int index;
  final ItemSelected<int> itemSelected;

  @override
  State<MutexWidget> createState() => _MutexWidgetState();
}

class _MutexWidgetState extends State<MutexWidget> {
  bool isWidgetSelected = false;

  @override
  Widget build(BuildContext context) {
    debugPrint("init index: ${widget.index}, group: ${widget.groupValue}");

    ///如果这两个id相等，那么当前Radio处于被选择状态，反之处于末选择状态
    if (widget.index == widget.groupValue) {
      isWidgetSelected = true;
    } else {
      isWidgetSelected = false;
    }

    return Listener(
      ///响应点击事件，把事件对外开放，在外层修改当前组件的组id.
      onPointerDown: (event) {
        if (widget.index == widget.groupValue) {
          isWidgetSelected = true;
        } else {
          isWidgetSelected = false;
        }
        widget.itemSelected(widget.index);
      },

      ///组件的外观在这里，可以自定义
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Item ${widget.index}"),
            Checkbox(
              activeColor: Colors.blue,
              side: const BorderSide(
                width: 3, color: Colors.grey,),
              shape: const CircleBorder(),
              value: isWidgetSelected,
              onChanged: (value) {},)
          ],
        ),
      ),
    );
  }
}

