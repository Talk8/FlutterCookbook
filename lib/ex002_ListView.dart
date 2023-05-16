// 这个代码和第5，28，29回中的内容相对应
import 'package:flutter/material.dart';

class ExListView extends StatelessWidget {
  const ExListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    //在参数是会入索引，然后通过onTap来响应索引
    ListTile listItem(IconData icon, String content,int index) {
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
        onTap:(){print(" Item $index onClicked");} ,
      );
    }


    ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      //offset并不是ListView中的索引值
      print("offset---: ${_scrollController.offset}");
      //Position的信息多，包含了offset
      print("position---: ${_scrollController.position}");
      print("pixels___: ${_scrollController.position.pixels}");
      //这两个是底部和顶部的offset
      print("max___: ${_scrollController.position.maxScrollExtent}");
      print("min___: ${_scrollController.position.minScrollExtent}");
      // print(_scrollController.jumpTo(1));
    });

    Widget listEx = ListView(
      controller: _scrollController,
      //指定每个Item的高度
      itemExtent: 56,
      scrollDirection: Axis.vertical,
      //在listItem中引入index参数后可以使用下面的代码替换被注释掉的代码，这样的代码简洁
      children: List.generate(15,
              (index) {return listItem(Icons.face,index.toString(),index);}
      ),
      // children: [
      //   listItem(Icons.face, "One",0),
      //   listItem(Icons.face, "One",1),
      //   listItem(Icons.face, "One",2),
      //   listItem(Icons.phone, "One",3),
      //   listItem(Icons.cabin, "One",4),
      //   listItem(Icons.cable, "One",5),
      // ],
    );

    //通过边框线来设定Divider,在第一行的顶部也会有，把边框设置为圆角后就可以看出来
    Widget listEx01 = ListView.builder(
      controller: _scrollController,
      itemCount: 8,
      itemExtent: 60,
      itemBuilder: (BuildContext context, int index) {
        //不添加任何装饰
        return listItem(Icons.ice_skating, "$index",index);
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
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          print("index : ${index}");
          return listItem(Icons.cabin, "$index",index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            endIndent: 5,
            height: 1,
            color: Colors.lightBlue,
          );
        },
        itemCount: 19,
    );


    return Scaffold(
      appBar: AppBar(
        title: const Text("ListView example AppBar"),
        backgroundColor: Colors.purpleAccent,
      ),
       body: listEx,
      // body: listEx02,
      // body: listEx02,
    );
  }
}