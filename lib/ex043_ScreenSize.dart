import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExScreenSize extends StatefulWidget {
  const ExScreenSize({Key? key}) : super(key: key);

  @override
  State<ExScreenSize> createState() => _ExScreenSizeState();
}

class _ExScreenSizeState extends State<ExScreenSize> {
  @override
  Widget build(BuildContext context) {
    XScreenUtil.init(context);



    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Screen'),
        backgroundColor: Colors.purpleAccent,
      ),
      ///screen util包最好在根目录进行初始化，用它包含MaterialApp比较好
      body: ScreenUtilInit(
        ///这里初始化为设计稿的尺寸为iphone6,单位是dp，flutter的单位都是dp和android一样
        ///我在这里输入的是分辨率，单位为px，没有转换成dp
        designSize:const Size(375.0,667.0),
        builder: (context,child) {
          return HomeWidget();
        },
        ///这个child的值和builder中参数的child相同
        child: HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Screen Size'),
        ///两个组件显示的大小相同，只是颜色不同，说明自己写的适配和三方包中的适配效果一样
        ///使用自己设计的屏幕适配类来适配屏幕
        Container(
          color: Colors.orange,
          // width: XScreenUtil.setFitRatio(200),
          // height: XScreenUtil.setFitRatio(200),
          width: 200.0.w,
          height: 200.0.w,
          child: const  Icon(Icons.pages),
        ),
        ///使用screenutil包中值来适配屏幕
        Container(
          color: Colors.green,
          width: 200.w,
          height: 200.w,
          child: const  Icon(Icons.face),
        ),
      ],
    );
  }
}

///自己设计的屏幕适配类,转换单位为dp
class XScreenUtil {
  static double baseSize = 0;
  static double physicalWidth = 0;
  static double physicalHeight = 0;
  static double realWidth = 0;
  static double realHeight = 0;
  static double dpr = 0;
  static double statusBarHeight = 0;
  ///计算好的屏幕比率
  static double fitRatio = 0;
  ///计算好的屏幕比率,单位为像素
  static double fitRatioPx = 0;



  ///pt类似dp，ios中的屏幕单位point的缩写，px是像素缩小，在设计中使用广泛
  ///baseSize以iPhone6为基准，默认值是750px,375dp
  static void init(BuildContext context,[baseSize=375]) {
    ///获取屏幕物理分辨率,单位是px
    physicalWidth = View.of(context).physicalGeometry.width;
    physicalHeight = View.of(context).physicalGeometry.height;

    ///获取屏幕物理分辨率,单位是pt
    realWidth = MediaQuery.of(context).size.width;
    realHeight = MediaQuery.of(context).size.height;

    ///屏幕的比率，比如2x,3x
    dpr = View.of(context).devicePixelRatio;

    ///状态栏的高度，除以dpr才是屏幕中实际的的高度
    statusBarHeight = MediaQuery.of(context).padding.top / dpr;

    ///屏幕适配时以宽度为单位进行适合，screenutil包中分宽度和高度两种适配方式，w为宽度，h为度，ex200.w,200.h.
    ///实际项目中以宽度和高度中数值比较小的一个进行适配
    fitRatio = realWidth / baseSize;
    fitRatioPx = physicalWidth / baseSize * 2; ///iphone6的dp和px转换需要乘以2

    ///iphone6时实际值如下：
    // fitRatio = realWidth / 375;
    // fitRatioPx = physicalWidth / 750; ///iphone6的dp和px转换需要乘以2

    debugPrint('PWidth: $physicalWidth, PHeight: $physicalHeight, RWidth: $realWidth, RHeight: $realHeight dpr: $dpr, top: $statusBarHeight');
  }

  ///以pt为单位时使用此方法
  static double setFitRatio(double value) {
    return value * fitRatio;
  }

  ///以px为单位时使用此方法
  static double setFitRatioPx(double value) {
    return value * fitRatioPx;
  }
}

///使用extension语法对double进行扩展，这样就可以使用2.0.w这样的语法来做适配，使的代码更加简洁
///这个语法参考了screenutil包中的语法，因为该包中有这样的使用方法。
extension DoubleExtension on double {
  double get w {
    return XScreenUtil.setFitRatio(this);
  }
  double get wx {
    return XScreenUtil.setFitRatioPx(this);
  }
}
