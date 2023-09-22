import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

///使用flutter_slidable包实现一个滑动菜单，可以向左，向右滑动，向上，向下滑动,滑动时拉菜单。
///这个滑动菜单实现使用场景不多,与153的内容相匹配
class ExSlidingAnyDirection extends StatefulWidget {
  const ExSlidingAnyDirection({super.key});

  @override
  State<ExSlidingAnyDirection> createState() => _ExSlidingAnyDirectionState();
}

class _ExSlidingAnyDirectionState extends State<ExSlidingAnyDirection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Sliding any direction'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Slidable(
        key: const ValueKey(0),
        ///控制滑动的方向，默认值是水平方向滑动，换方向后显示效果不好，因为菜单大小没有变化
        // direction: Axis.vertical,
        ///添加滑动时显示的菜单，向右或者向下滑动时显示的菜单
        startActionPane: ActionPane(
          dismissible: DismissiblePane(onDismissed: (){},),
          ///控制滑动时菜单显示的动画效果
          // motion: const ScrollMotion(),
          motion: const DrawerMotion(),
          ///数量超过2个后就显示不全了
          children: [
            SlidableAction(
              onPressed:(BuildContext cxt){} ,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "Delete",
            ),
            SlidableAction(
              onPressed:(BuildContext cxt){} ,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.green,
              icon: Icons.share,
              label: "Share",
            ),
             SlidableAction(
              onPressed:(BuildContext cxt){} ,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "Delete",
            ),
          ],
        ),
        ///添加滑动时显示的菜单，向左或者向上滑动时显示的菜单
        endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                flex: 2,
                onPressed:(BuildContext cxt){} ,
                backgroundColor: Colors.yellowAccent,
                foregroundColor: Colors.redAccent,
                icon: Icons.archive,
                label: "Archive",
              ),
              SlidableAction(
                onPressed:(BuildContext cxt){} ,
                backgroundColor: Colors.yellowAccent,
                foregroundColor: Colors.redAccent,
                icon: Icons.save,
                label: "Save",
              ),
            ],
        ),
        ///拉出菜单的高度与child的高度相同，修改滑动方向后最好放大高度，不然菜单都显不全
        child: const SizedBox(
            height: 500,
            child: ListTile(title: Text('Slid me'),),
        ),
      )
    );
  }
}
