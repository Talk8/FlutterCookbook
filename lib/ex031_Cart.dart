import 'package:flutter/material.dart';

class ExCard extends StatefulWidget {
  const ExCard({Key? key}) : super(key: key);

  @override
  State<ExCard> createState() => _ExCardState();
}

class _ExCardState extends State<ExCard> {
  final List<String> _dataList = ["One","Two","Three","Four"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Card"),
        backgroundColor: Colors.purpleAccent,
      ),
      //把card嵌套在List中用来展示多个card
      body:ListView(
        children:_dataList.map((e){
          //用card充当容器布局，在容器中使用Column排列子组件
          //card没有指定大小的属性，它的大小等于所有子组件叠加在一起的大小
          //card自带圆角和立体阴影效果，比较好看,不过需要自己排列card里的内容
          //下面的设计比较好看，可以当作信息展示，我觉得card自带的阴影和边框就足够用了
          //不需要再设置边框，阴影以及背景，去掉这些设置更加好看一些
          return Card(
            //设置card屏幕的边距
            margin:const EdgeInsets.all(20) ,
            //控制阴影的范围，值越大阴影越明显
            elevation: 20,
            //设置阴影的颜色
            shadowColor: Colors.redAccent,
            //设置card的背景颜色
            color: Colors.green,
            //设置card外层的边框
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: const BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
            //自行设置card内的组件排列效果
            child: Column(
              children: [
                //第一行显示一个图片
                const AspectRatio(
                aspectRatio: 16/9,
                //图片外层嵌套ClipRRect用来设置圆角,不然图片会覆盖card的圆角
                child: ClipRRect(
                  //四个方向都设置圆角
                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                  //只有顶部两个方向都设置圆角
                  borderRadius: BorderRadius.only(
                    //card自带的圆角是16，
                    topLeft:Radius.circular(16),
                    topRight:Radius.circular(16),
                  ),
                  child:Image(
                    image: AssetImage("images/ex.png"),
                    fit:BoxFit.cover,),
                  ),
                ),
                //第二行显示说明，包含主标题和子标题
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                  ),
                  title: Text(e),
                  subtitle: Text("This is $e"),
                ),
                //第三行显示详细信息
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("the details of $e it is a useful information and  it contains many of characters.",
                  //文字内容显示的最大行数
                  maxLines: 1,
                  //超过最大行数后显示三个点
                  overflow: TextOverflow.ellipsis,),
                ),
                //第四行显示按钮,
                //把多个按钮组件在一起使用
                ButtonBar(
                  children: [
                    TextButton(onPressed: (){}, child: const Text("Read")),
                    TextButton(onPressed: (){}, child: const Text("Skip")),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
