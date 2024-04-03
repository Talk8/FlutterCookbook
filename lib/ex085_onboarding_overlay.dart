import 'package:flutter/material.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

///主要是onboardingOverlay的示例，该组件用来实现首次使用时功能引导说明。
///在某个功能上显示功能的介绍，功能区域高亮显示（本组件称其为hole)，其它区域模糊显示(本组件称其为overlay)。
///点击模糊区域时跳转到下一个功能说明(组件中称为step).开发人员需要做的是把scaffold组件当作child赋值给Onboarding。
///然后在需要解析的功能上通过Focus组件添加解析说明。说明的内容通过OnboardingStep实现。
///这个包比overlay_tooltip在解析框外多了箭头，使用相对繁杂一些，整体的使用思路类似
class ExOnboardingOverlay extends StatefulWidget {
  const ExOnboardingOverlay({super.key});

  @override
  State<ExOnboardingOverlay> createState() => _ExOnboardingOverlayState();
}

class _ExOnboardingOverlayState extends State<ExOnboardingOverlay> {
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ///这个FocusNode相当于OnboardingStep的key，它把页面中的功能和OnboardingStep关联起来
  var focusNodeList = List<FocusNode>.generate(5,
          (index) => FocusNode(debugLabel: "FocusNode $index",),
      growable: false,
    );

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1,),() {
        // onboardingKey.currentState?.show();
      ///stepIndexes should contain initialIndex
        onboardingKey.currentState?.showWithSteps(0, [0,1,2]);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Onboarding(
      key: onboardingKey,
      autoSizeTexts: true,
      ///这个会在body外层显示一个红色方框，不能打开，使用默认的false就可以
      debugBoundaries: false,
      ///这里只处理最后一个索引时关闭模糊显示，从一个step到下一个step中跳转是控件
      ///自己在处理，不需要添加任何事件
      onChanged: (index) {
        if(index == 2) {
          onboardingKey.currentState?.hide();
        }
      },
      steps: [
        OnboardingStep(focusNode: focusNodeList[0],
          titleText: "FocusNode 1 title",
          bodyText: "FocusNode 1 body",
          hasArrow: true,
          hasLabelBox: true,
          arrowPosition: ArrowPosition.autoVertical,
          fullscreen: true,
        ),
        OnboardingStep(focusNode: focusNodeList[1],
          ///stepBuilder中没有内容时显示title和body，有内容则优先显示stepBuilder中的内容
          ///这两个内容可以看作是对模糊层上高亮内容的解释，写任意一个就行
          titleText: "FocusNode 2 title",
          bodyText: "FocusNode 2 body",
          ///这两个颜色默认都是白色
          titleTextColor: Colors.blue,
          bodyTextColor: Colors.yellow,
          ///配置body外层的边框和内边距
          labelBoxPadding: const EdgeInsets.all(8,),
          ///需要添加默认的边框相当于是透明的，什么也没有
            ///如果设置了stepBuilder这个边框也会显示在它的外层
          labelBoxDecoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
          ),

          ///模糊层的颜色
          overlayColor: Colors.purpleAccent,
          ///只有fullscreen属性设置为false后才有效果,而且是从左上角开始呈现放射形状
          // overlayShape: const RoundedRectangleBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(30.0),),
          // ),
          // overlayShape:const CircleBorder(),
          ///模糊层上高亮显色内容的形状，默认是矩形
          // shape: CircleBorder(
          // ),
          ///模糊层上高亮显色内容的内边距
          // margin: EdgeInsets.only(left: 90,),
          ///只有labelBoxDecoration赋值后才有效果
          hasArrow: true,
          hasLabelBox: true,
          ///body外层窗口的箭头位置
          arrowPosition: ArrowPosition.topCenter,
          ///设置成translucent后点击模糊区域无法跳转到下一个step,这个属性的值有多种，功能不同，
            ///主要用来控制在哪里响应点击事件，功能值可以查看官方文档
          overlayBehavior: HitTestBehavior.translucent,
          fullscreen: true,
          onTapCallback: (TapArea area, VoidCallback next, VoidCallback close){
          ///它的值分三种：hole:就是模糊层上高亮部分，overlay:就是模糊层, label：就是文本部分
          debugPrint("onTapCallback: area:$area");

          debugPrint("onTapCallback: next :${next.toString()}");
          debugPrint("onTapCallback: stop:${close.toString()}");

          ///这里无法区分next和close,只要点击模糊区和stepBuilder控制的地方都会调用这个方法
          ///如果想在点击区域时关闭或者跳转到下一个区域，那么调用close和next中的任意一个方法
          ///我的建议是在 Onboarding中的 onChanged方法中跳转，而不是在这里做跳转
          // next();
          // close();
          },
          ///如果觉得只两个title和body两个文本比较简单，可以实现此属性，它主要用来实现自定义的内容
          ///不过该内容仍然会包含在body的边框中，可以通过labelBoxDecoration修饰边框的颜色，圆角等风格
          stepBuilder: (context,renderInfo) {
          ///建议通过容器类组件控制大小，不然会铺满整个屏幕
          return Container(
            color: Colors.lightGreenAccent,
            height: 320,
            width: 300,
            child: Column(
              children: [
                ///这两个文本就是titleText和bodyText中的内容,不过字体比较大
                Text(renderInfo.titleText),
                Text(renderInfo.bodyText),
                ElevatedButton(
                  onPressed: () {
                    debugPrint("next: :${renderInfo.nextStep.toString()}");
                    renderInfo.nextStep();
                  },
                  child: const Text("Next"),
                ),
                ElevatedButton(
                  onPressed: () => renderInfo.close(),
                  child: const Text("Stop"),
                ),
              ],
            ),
          );
          }
        ),
        OnboardingStep(focusNode: focusNodeList[2],
          titleText: "FocusNode 3 title",
          bodyText: "FocusNode 3 body",
          hasArrow: true,
          hasLabelBox: true,
          arrowPosition: ArrowPosition.autoVertical,
          fullscreen: true,
        ),

      ],
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Example of onboardingOverlay"),
          actions: [
            Focus(
              focusNode: focusNodeList[0],
                child: const Text("show focus"),
            ),
          ],
        ),
        body: Column(
          children: [
            const Text("body of scaffold "),
            IconButton(onPressed: (){
              onboardingKey.currentState?.show();
            }, icon: const Icon(Icons.delete),focusNode: focusNodeList[1],),
            Focus(
              focusNode: focusNodeList[2],
              child: const Text("show focus"),
            ),
          ],
        ),
      ),
    );
  }
}
