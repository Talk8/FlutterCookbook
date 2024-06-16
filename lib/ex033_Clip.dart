import 'package:flutter/material.dart';

///与70回剪切类组件内容匹配
class ExClip extends StatefulWidget {
  const ExClip({Key? key}) : super(key: key);

  @override
  State<ExClip> createState() => _ExClipState();
}

class _ExClipState extends State<ExClip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of all kinds of Clip Widget"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //原始图片
            Container(
              width: 200, height: 100,
              color: Colors.grey,
              child: Image.asset("images/ex.png",width: 90,),
            ),
            //剪裁成椭圆或者圆形形状
            Container(
              width: 100, height: 100,
              color: Colors.grey,
              child: ClipOval(
                child: Image.asset("images/ex.png",width: 50,height: 80,),
              ),
            ),
            //Avatar剪裁效果好
            CircleAvatar(
              radius: 40,
              child: Image.asset("images/ex.png",width: 50,height: 80,),
            ),
            //剪裁成椭圆或者圆形形状,使用自定义的剪裁尺寸，效果比默认的好一些
            Container(
              width: 100, height: 100,
              color: Colors.grey,
              child: ClipOval(
                clipper: DIYCliper(),
                child: Image.asset("images/ex.png",width: 50,height: 80,),
              ),
            ),
            //剪裁效果是？
            Container(
              width: 100, height: 100,
              color: Colors.grey,
              child: ClipRect(
                child: Image.asset("images/ex.png",width: 90,),
              ),
            ),
            //剪切成圆角矩形
            Container(
              width: 100, height: 100,
              color: Colors.grey,
              child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset("images/ex.png",width: 90,height: 90,),
              ),
            ),
            ///使用Material也可以实现剪裁功能，它类型于Container中的属性
            ///type的功能了也很强大，默认是canvas,可以设置为圆形矩形等形状，还可以设置成无组件
            Material(
              type: MaterialType.canvas,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(30),
              child: Image.asset("images/ex.png",width: 90,height: 90,),
            ),
          ],
        ),
      ),
    );
  }
}

//自定义剪裁的尺寸
class DIYCliper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    // TODO: implement getClip
    //从左上右下四个方向指定尺寸处剪裁
    return const Rect.fromLTRB(10, 10, 90, 90);

    //从左上指定尺寸处剪裁固定的宽度和高度
    // return Rect.fromLTWH(30, 0, 90, 90);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
