
import 'package:flutter/material.dart';

///与182的内容相匹配
class ExSlideNumber extends StatefulWidget {
  const ExSlideNumber({super.key});

  @override
  State<ExSlideNumber> createState() => _ExSlideNumberState();
}

class _ExSlideNumberState extends State<ExSlideNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Slide Number"),
      ),
      body: const CusTimePicker(width: 200,height: 360,minValue: 0,maxValue: 29,),

      ///用来显示绘制图形时绘制出的阴影效果
      /*
      body: Center(
        child: CustomPaint(
          size: const Size(120,120),
          painter: DrawShadow(),
        ),
      ),
      */
    );
  }
}

class CusTimePicker extends StatefulWidget {
  const CusTimePicker({super.key,
    required this.width, required this.height,
    required this.minValue, required this.maxValue,
  });

  final double width;
  final double height;
  final double minValue;
  final double maxValue;

  @override
  State<CusTimePicker> createState() => _CusTimePickerState();
}

class _CusTimePickerState extends State<CusTimePicker> {
  double _currentValue = 0;


  void onValueChanged(double value) {
    setState(() {
      _currentValue = value;
    });
  }

  double value = 100;

  @override
  Widget build(BuildContext context) {
    ///显示文字的位置,与组件的宽度和高度有关
    double textTop = widget.height/2;
    double textLeft = widget.width/5;


    ///刻度尺的位置,与组件的宽度和高度有关
    double rulerTop = 0;
    double rulerLeft = widget.width*2/5;

    ///显示滑块的位置,与组件的宽度和高度有关,注意它的值从右侧开始计算，所以减去30
    double thumbLeft = widget.width - 30;

    ///刻度尺的长度和宽度,与组件的宽度和高度有关
    double ruleWidth = widget.width*3/5;
    double ruleHeight = widget.height-rulerTop;

    ///刻度线之间的间隔
    double space =  widget.height /(widget.maxValue - widget.minValue);
    ///刻度线的宽度
    const double lineHeight = 3.0;
    ///刻度线的长度,这个值本来想通过组件宽度来计算，感觉不好控制，所以写在固定值
    const double lineWidth = 90;

    ///刻度线的数量,原来语法在智能提示修改成了现有语法
    // int lineCount = widget.height/(space + lineWidth).toInt();
    int lineCount = (widget.maxValue - widget.minValue).toInt();

    ScrollController scrollController = ScrollController();
    ///可以添加监听器来查看List的滚动数值，在滑轮可以这样做，不过这里是滑块在移动所以没有使用它
    scrollController.addListener(() {
    });

    return GestureDetector(
      child: Container(
        color: Colors.black12,
        width: widget.width,
        height: widget.height,

        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: textLeft,
              top: textTop,
              child: Text("${_currentValue.toInt().toString().padLeft(2, "0")} : 00"),
            ),
            Positioned(
              left: rulerLeft,
              top: rulerTop,

              ///整个刻度尺
              child: Container(
                ///控制刻度尺右侧的线
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  border:Border(
                    right: BorderSide(color: Colors.black,width: 2,),
                  ),

                ),
                ///整个刻度尺的长度和宽度
                width: ruleWidth,
                height: ruleHeight,

                ///使用ListView的divider来充当刻度线
                child: ListView(
                  controller: scrollController,
                  ///通过List中item的高度控制刻度线之间的间隔
                  // itemExtent: 12,
                  itemExtent: space,
                  ///List的长度除以2就是刻度的长度,list不能太长，长了会滚动
                  children: List.generate(lineCount, (index) {
                    if(index %2 != 0 ) {
                      return Container(
                        ///这个颜色需要和整个组件的背景颜色一样，或者做成透明色
                        color: Colors.transparent,
                        child: const SizedBox.shrink(),
                      );
                    }else {
                      return const Divider(
                        ///线的宽度
                        thickness: lineHeight,
                        ///总宽度减去此值为线的长度
                        indent: lineWidth,
                        color: Colors.blue,
                      );
                    }
                  }),
                ),
              ),
            ),
            ///滑块
            Positioned(
              top: value,
              left: thumbLeft,
                child: Container(
                  color: Colors.transparent,
                  child: const Icon(Icons.face,color: Colors.redAccent,),
                ), ),
          ],
        ),
      ),

      onPanUpdate: (event) {
        setState(() {
          value += event.delta.dy;
          _currentValue = value;
          debugPrint("$value");

          ///转换滑动值为刻度值，
          ///控制滑动的移动范围，不然会滑动到刻度尺外面
        });
      },
    );
  }
}



///在canvas绘制图像时，通过设置画笔的maskFilter来实现阴影效果
class DrawShadow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    ///通过maskFilter来添加发光效果，看上去就是阴影效果
    ///colorFilter通常用来给图像添加阴影效果，绘制图形时体现不出来它的效果
    ///这里创建的阴影使用了单一颜色
    Paint paintA = Paint()
      ..color = Colors.blue.withOpacity(1)
      // ..colorFilter = ColorFilter.mode(Colors.redAccent, BlendMode.dst)
      ..strokeWidth = 4
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 20);

    ///这里创建的阴影使用了渐变颜色
    RadialGradient gradient = const RadialGradient(
      ///用来控制中间颜色的位置
      center: Alignment(-1, -1),

      ///用来控制中间颜色的区域大小,需要和rect一起控制才可以
      radius: 0.6,
      colors: [Colors.black, Colors.black, Colors.black38],
    );

    ///rect的长和宽需要和圆形的半径有关联，不能太大也不能太小
    Rect rect = const Rect.fromLTWH(0, 0, 100, 100);
    Paint paintB = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 20)
      ..shader = gradient.createShader(rect);

    ///渐变色的阴影最好偏移为0，不然效果不明显
    Offset offsetA = const Offset(150, 0);
    Offset offsetB = const Offset(0, 0);

    canvas.drawCircle(offsetA, 60, paintA);
    canvas.drawCircle(offsetB, 60, paintB);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // throw UnimplementedError();
    return true;
  }
}
