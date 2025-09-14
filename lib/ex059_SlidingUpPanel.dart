import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
///这个包的功能十分强大，各种想要的属性和功能都包含了，缺点是最近2年没有更新,与153的内容相匹配
///截止202509这个包也没有更新以后不需要考虑使用这个包。另外用了modal_bottom_sheet这个包，
///使用比较复杂，而且需要修改Scaffold组件.总之修改Scaffold的组件的三方插件要慎重。
///可以自己使用showModalBottomSheet+DraggableScrollableSheet+ListView来实现slidingUpPanel的效果。
///具体为：底部有内容，向上滑动此内容可以显示窗口，窗口内的所有内容可以滑动(inside scroll)，而且大小可以调节。
///也可以在底部没有内容，通过事件触发来弹出窗口。
class ExSlidingUpPanel extends StatefulWidget {
  const ExSlidingUpPanel({super.key});

  @override
  State<ExSlidingUpPanel> createState() => _ExSlidingUpPanelState();
}

class _ExSlidingUpPanelState extends State<ExSlidingUpPanel> {
  PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Sliding up panel'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: SlidingUpPanel(
        ///控制panel收缩时的值和展开时的值
        minHeight: 60,
        maxHeight: 500,
        ///控制panel的圆角，边框，阴影
        border: const Border(top:BorderSide(color: Colors.blue,width: 4,),),
        ///圆角和颜色不能同时设置
        // borderRadius: BorderRadius.circular(10),
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(20),
        //   topRight: Radius.circular(20),),
        boxShadow:const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 4,
          ),
        ],
        ///拉起panel时非panel部分显示的颜色,这个颜色不包含appBar及它顶部的颜色，
        ///如果想要修改需要把该组件的body设置为scaffold,而不是当前的column
        backdropEnabled: true,
        backdropColor: Colors.red,
        ///非panel部分颜色的透明度,默认值是1
        backdropOpacity: 1,
        ///点击非panel部分时是否关闭panel,默认值是true,表示可以关闭
        backdropTapClosesPanel: false,
        ///操作panel时的回调方法
        ///这个参数是panel展开的范围值，从0-1
        onPanelSlide: (position) => debugPrint('onPanelSlide $position'),
        ///panel完全关闭和展开时才回调这两个方法
        onPanelClosed: () => debugPrint('onPanelClosed'),
        onPanelOpened: () => debugPrint('onPanelOpened'),

        parallaxEnabled: true,
        parallaxOffset: 0.5,

        ///来源于官方示例：这个值设置为false,同时给panel添加边距可以实现panel悬浮效果
        renderPanelSheet: false,
        ///panel中显示的组件
        panel: Container(
          margin: const EdgeInsets.all(40),
          // color: Colors.yellowAccent,
          ///这个装饰是给悬浮效果用的，这样可以呈现出立体效果，正常的panel不需要,比如下面的代码是一个金光效果
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow:[
             BoxShadow(
               color: Colors.yellowAccent,
               spreadRadius: 8,
               blurRadius: 20,
             ),
            ]
          ),
          child:const Text('panel'),),
        ///panel隐藏时显示的组件
        collapsed:Container(
          margin: const EdgeInsets.all(40),
          color: Colors.green,
          alignment: Alignment.center,
          child: const Text('collapsed'),),

        ///这两个属性用处不大
        header: const Text('header'),
        footer: const  Text('footer'),

        ///panel顶部剩余空间的内容，展开panel时顶部的内容会向上滑动，因此最上面的内容会被隐藏掉
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('no panel'),
            const Icon(Icons.recommend_outlined),
            ElevatedButton(
              onPressed: showModalPanel,
              child: const Text('Show Modal Bottom Sheet'),
            ),
             ///通过panelControl打开、关闭panel
             ElevatedButton(
              onPressed: openPanel,
              child: const Text('open panel'),
            ),
            ElevatedButton(
              onPressed: closePanel,
              child: const Text('close panel'),
            ),
        ], ),
        controller:panelController ,
      ),
    );
  }

  void showModalPanel() {
    showModalBottomSheet(context: context,
        builder: (BuildContext ctx){
          return BottomSheet(onClosing: (){},
              builder: (BuildContext context) {
            return Container(
              color: Colors.blue,
              width: double.infinity,
              height: 300,
            );
              });
        },);
  }

  void openPanel() {
    panelController.open();
  }

  void closePanel() {
    panelController.close();
  }

}
