import 'package:flutter/material.dart';

class ExBoxDecoration extends StatefulWidget {
  const ExBoxDecoration({Key? key}) : super(key: key);

  @override
  State<ExBoxDecoration> createState() => _ExBoxDecorationState();
}

class _ExBoxDecorationState extends State<ExBoxDecoration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example of BoxDecoration"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //容器的内辖边距
            margin:const EdgeInsets.all(30),
            child: const Icon(
              Icons.swipe,
              size: 80.0,
              color: Colors.white,
            ),
            //添加装饰器
            decoration: const BoxDecoration(
                color: Colors.greenAccent,
                //添加边框,可以只添加部分，或者全添加
                border: Border(
                  top: BorderSide(
                      color: Colors.red, width: 5, style: BorderStyle.solid),
                  bottom: BorderSide(color: Colors.yellow, width: 5),
                ),
                // border: Border.all(
                //   color: Colors.yellow,
                //   width: 3,
                // ),

                //设置圆角边框,角度超过35就变成了圆形
                // borderRadius: BorderRadius.circular(20),
                //上面是所有边框都设置圆角，也可能在某一侧设置圆角边框
                // borderRadius: BorderRadius.only(topRight: Radius.circular(30)),

                //调整box的形状，形状是圆形时不能使用圆角属性，否则报错
                shape: BoxShape.rectangle,
                // shape: BoxShape.circle,

                //给Box添加阴影,可以添加多个阴影
                boxShadow: [
                  BoxShadow(
                    //阴影偏移距离，第一个是x，第二个是y
                    offset: Offset(30, 20),
                    color: Colors.purpleAccent,
                    //值越小越模糊
                    blurRadius: 10,
                    //模糊范围
                    spreadRadius: 2,
                  )
                ]),
          ),
          Container(
            alignment: Alignment.center,
            child: Icon(Icons.shop,size: 80,),
          ),
        ],
      ),
    );
  }
}
