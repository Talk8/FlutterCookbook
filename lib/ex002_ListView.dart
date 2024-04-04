// 这个代码和第5，28，29,30,88回中的内容相对应
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
        subtitle: Text("subtitle: $index"),
        onTap:(){debugPrint(" Item $index onClicked");} ,
      );
    }


    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      //offset并不是ListView中的索引值
      debugPrint("offset---: ${scrollController.offset}");
      //Position的信息多，包含了offset
      debugPrint("position---: ${scrollController.position}");
      debugPrint("pixels___: ${scrollController.position.pixels}");
      //这两个是底部和顶部的offset
      debugPrint("max___: ${scrollController.position.maxScrollExtent}");
      debugPrint("min___: ${scrollController.position.minScrollExtent}");
      // debugPrint(scrollController.jumpTo(1));
    });

    Widget listEx = ListView(
      controller: scrollController,
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
      shrinkWrap: true,
      controller: scrollController,
      itemCount: 8,
      itemExtent: 96,
      itemBuilder: (BuildContext context, int index) {
        //不添加任何装饰
        // return listItem(Icons.ice_skating, "$index",index);
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

        //通过column把Divider和listItem组合成新组件进而实现分隔线的效果
        return Column(
          children: [
            listItem(Icons.ice_skating, "$index",index),
            const Divider(
              color: Colors.grey,
              //用来控制分隔线的宽度,默认值是0.0
              thickness: 1.0,
              //用来控制分隔线的前后与屏幕边缘的间距
              indent: 32,
              endIndent: 12,
            ),
          ],
        );
      },
    );


    //通过separatorBuilder属性来设定divider
    Widget listEx02 = ListView.separated(
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          debugPrint("index : $index");
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


    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double res = MediaQuery.of(context).devicePixelRatio;
    ///bottom有区别
    MediaQuery.of(context).viewPadding.top;

    debugPrint("height: $screenHeight, top： $statusBarHeight, ratio:$res");
    return Scaffold(
      appBar: AppBar(
        title: const Text("ListView example AppBar"),
        backgroundColor: Colors.purpleAccent,
      ),
      ///这个程序可以巧妙地计算出appBar的高度，通过运行时的错误，我的是56
      ///A RenderFlex overflowed by 56 pixels on the bottom.
      body: Column(
        children: [
          ///在列表外层嵌套一个容器，实现局部动态列表，不然页面显示异常，而且列表无法滚动
         ///详细内容可以参考114回局部动态列表相关的内容
          Container(
            color: Colors.lightGreen,
            width: screenWidth,
            height: (screenHeight - statusBarHeight)/3,
              child: listEx,
          ),
          Container(
            color: Colors.lightBlueAccent,
            width: screenWidth,
            height: (screenHeight - statusBarHeight)/3,
            child: listEx01,
          ),
          Container(
            color: Colors.orangeAccent,
            width: screenWidth,
            height: (screenHeight - statusBarHeight)/3,
            child: listEx02,
          ),
        ],
      ),
      // body: listEx02,
    );
  }
}