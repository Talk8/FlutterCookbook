
import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

///与179和180的内容相匹配

///定义回调方法的类型
typedef ValueChanged<T> = void Function(T value);

///自定义的switch，滑动通过Gesture实现，track是一个带有开关状态的图片，thumb是一个图片。
///两个图片通过stack叠加，位置通过position控制
class ExSlideImage extends StatefulWidget {
  const ExSlideImage({super.key});

  @override
  State<ExSlideImage> createState() => _ExSlideImageState();
}

class _ExSlideImageState extends State<ExSlideImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of SlideImage"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 100,width: 300,),
          const SlideImageA(width: 60,height: 160,),
          const SizedBox(height: 100,),
          SlideImageB(width: 60, height: 160,
              trackImage:const AssetImage("images/pickup.png"),
              thumbImage:const AssetImage("images/pickdown.png"),
              onValueChanged: (v){
                debugPrint("check value: $v");
              },),
          // CusWheelPicker(),
          const SizedBox(height: 16.0,),
          ///演示两种阴影效果:BoxDecoration控制的效果在周围，呈发散形状。对应180的内容
          ///card的阴影效果只在下方位置，有立体效果
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ///正常的阴影,阴影效果在组件周围四个方向
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  boxShadow:[ BoxShadow(
                    color: Colors.yellow,
                    blurRadius: 24.0,
                  ),
                  ],
                ),
              ),
              ///在正常的阴影的基础通过offset控制阴影的位置
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  boxShadow:[ BoxShadow(
                    color: Colors.yellow,
                    ///控制阴影的位置
                    offset: Offset(0, 10),
                    ///控制阴影的大小
                    blurRadius: 24.0,
                  ),
                  ],
                ),
              ),
              ///card的阴影在组件下方，无法控制阴影的位置
              const Card(
                color: Colors.blue,
                shadowColor: Colors.yellow,
                ///控制阴影的大小
                elevation: 24,
                child: SizedBox(width: 100,height: 100,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///这个组件通过stack组合container和WheelChooser一起实现的选择器。只是在被选择的内容周围嵌套
///一个边框，边框用Container实现，可以自定义边框的宽度和颜色.
class CusWheelPicker extends StatelessWidget {
  const CusWheelPicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          width: 160,
          height: 60,
          child: WheelChooser(
            listWidth: 160,
            listHeight: 60,
            ///控制滑动方向
            horizontal: true,
            ///这个值不知道用来做什么
            // perspective: 0.003,
            ///使用装饰可以在选择的内容上方和下方显示一条横线，不过这个线不会起wheel
            selectTextStyle: const TextStyle(
              ///单独使用和复合使用装饰
              // decoration: TextDecoration.overline,
              // decoration: TextDecoration.combine([TextDecoration.underline,TextDecoration.overline]),
            ) ,
            ///是否循环显示
            isInfinite: false,
            onValueChanged: (s) => debugPrint('$s selected'),
            datas: const [1,2,3,4],
          ),
        ),
        Container(
          width: 50,
          height: 60+8, ///list宽度加边框宽度
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.redAccent,width: 4.0,style: BorderStyle.solid)
          ),
        ),
      ],
    );
  }
}


///使用自定义View画可以滑动的图片开关，这个方法有时间了再尝试，主要是drawImage()方法需要的image对象不好创建
class SlideImage extends StatefulWidget {
  const SlideImage({super.key});

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ImagePainter(),
    );
  }
}

class ImagePainter extends CustomPainter {
  @override
  Future<void> paint(Canvas canvas, Size size) async {
    // TODO: implement paint
    Paint paint = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 2.0;

    var offset = const Offset(0, 0);
    double radius = 8;
    ///画圆：第一个参数指定Offset,表示圆的左上角为基准进行偏移而不是以圆心为基准
    canvas.drawCircle(offset,radius,paint);
    //
    //   (await rootBundle.load("images/pickup.png")) as Uint8List,
    // ) as Image;
    // canvas.drawImage(_image, _offset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return true;
  }
}

///stateless组件无法刷新状态，或者说无法调用setState()方法
class SlideImageA extends StatelessWidget {
  const SlideImageA({
    required this.width,
    required this.height,
    super.key});

  final double width;
  final double height;

  final double slideValue = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ///背景图片
          Image(
            width: width,
            height: height,
            image: const AssetImage("images/pickup.png"),
            fit: BoxFit.fill,
          ),
          ///可以滑动的图片
          GestureDetector(
            child: Transform.translate(
              offset: Offset(0,slideValue),
              child: Image(
                width: width,
                height: height-40,
                image: const AssetImage("images/pickdown.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SlideImageB extends StatefulWidget {
  const SlideImageB({super.key, required this.width, required this.height,
    required this.trackImage, required this.thumbImage, required this.onValueChanged});

  ///这个长度和宽度是容器的大小也是图片的大小，图片不够时会进行拉伸。这样操作的缺点是没有边距
  final double width;
  final double height;
  ///轨道和滑块的图片
  final ImageProvider<Object> trackImage;
  final ImageProvider<Object> thumbImage;

  final ValueChanged<bool>? onValueChanged;

  @override
  State<SlideImageB> createState() => _SlideImageBState();
}

class _SlideImageBState extends State<SlideImageB> {

  ///控制滑动的范围,它是背景图片与滑动图片高度的差值，也就是未滑动前可以看到的背景图片大小
  double scrollRange = 60;
  ///这个值默认是scrollRange的一半
  double slideValue = 60;
  bool switchOn = false;

  @override
  Widget build(BuildContext context) {
    // debugPrint("init: $slideValue");

    return Container(
      color: Colors.green,
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ///背景图片
            Image(
              width: widget.width,
              height: widget.height,
              // image: const AssetImage("images/pickup.png"),
              image: widget.trackImage,
              fit: BoxFit.fill,
            ),
            ///可以滑动的图片
            ///使用Listener和GestureDetector都不过transform的坐标不好控制
        /*
            GestureDetector(
              onPanUpdate: (event){
                setState(() {
                  // slideValue = event.localPosition.dy-widget.height;
                  slideValue += event.delta.dy;
                  if(slideValue > scrollRange) {
                    slideValue = scrollRange/2;
                  }
                  if(slideValue < 0) {
                    slideValue = -scrollRange/2;
                  }
                  debugPrint("value： $slideValue");
                });
              },
              child: Transform.translate(
                offset: Offset(0,slideValue),
                // offset: Offset(0,0),
                child: Image(
                  width: widget.width,
                  height: widget.height-scrollRange,
                  image: const AssetImage("images/pickdown.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            */
            ///使用Position控制坐标
            Positioned(
              left: 0,
              top: slideValue,
              child: Image(
                  width: widget.width,
                  height: widget.height-scrollRange,
                  // image: const AssetImage("images/pickdown.png"),
                  image: widget.thumbImage,
                  fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        ///响应滑动事件
        onPanUpdate: (event){
          setState(() {
            slideValue += event.delta.dy;

            // debugPrint("value: $slideValue");
            if(slideValue > scrollRange) {
              slideValue = scrollRange;
              switchOn = true;
              // debugPrint("true");
            }
            if(slideValue < 0) {
              slideValue = 0;
              switchOn = false;
              // debugPrint("false");
            }

            ///使用了call语法
            // widget.onValueChanged?.call(switchOn);
          });
        },
        ///通过回调传递开关的结果需要在手势滑动结束后，不能在手势滑动过程中
        onPanEnd: (details){
          ///使用了call语法
          widget.onValueChanged?.call(switchOn);
        },
      ),
    );
  }
}




