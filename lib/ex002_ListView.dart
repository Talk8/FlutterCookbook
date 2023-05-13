// 这个代码和第五回中的内容相对应
import 'package:flutter/material.dart';

class ExListView extends StatelessWidget {
  const ExListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ListTile listItem(IconData icon, String content) {
      return ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
        ),
        title: Text(
          content,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      );
    }

    Widget listEx = ListView(
      scrollDirection: Axis.vertical,
      children: [
        listItem(Icons.face, "One"),
        listItem(Icons.face, "One"),
        listItem(Icons.face, "One"),
        listItem(Icons.phone, "One"),
        listItem(Icons.cabin, "One"),
        listItem(Icons.cable, "One"),
      ],
    );

    //通过边框线来设定Divider,在第一行的顶部也会有，把边框设置为圆角后就可以看出来
    Widget listEx01 = ListView.builder(
      itemCount: 8,
      itemExtent: 60,
      itemBuilder: (BuildContext context, int index) {
        //不添加任何装饰
        return listItem(Icons.ice_skating, "$index");
        //使用装饰来添加分隔线
        // return Container(
        //   decoration: BoxDecoration(
        //     //只添加底部的边框线
        //     // border: Border(bottom: BorderSide(width: 1, color: Colors.lightBlue)),
        //     //添加一个边框
        //     // border: Border.fromBorderSide(BorderSide(width: 1,color: Colors.yellow)),
        //     border: Border.all(color: Colors.greenAccent, width: 1),
        //     //给边框设置半径，就是让装饰器的边框呈现圆角
        //     borderRadius: BorderRadius.circular(30),
        //   ),
        //   child: listItem(Icons.ice_skating, "$index"),
        // );
      },
    );

    //通过separatorBuilder属性来设定divider
    Widget listEx02 = ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return listItem(Icons.cabin, "$index");
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            endIndent: 1,
            height: 1,
            color: Colors.lightBlue,
          );
        },
        itemCount: 6);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ListView example AppBar"),
        backgroundColor: Colors.purpleAccent,
      ),
      // body: listEx,
      body: listEx01,
      // body: listEx02,
    );
  }
}