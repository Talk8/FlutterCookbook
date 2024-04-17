import 'package:flutter/material.dart';
import 'package:fluttercookbook/ex086_overlayEntry.dart';
import 'package:fluttercookbook/ex087_html_view.dart';
import 'package:get/get.dart';

class ExGetMaterialApp extends StatelessWidget {
  const ExGetMaterialApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // home: GetHomePage(),
      ///配置好路由后可以使用命名路由，配置方法和Material方法相同
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const GetHomePage(),),
        GetPage(name: '/overlay', page: () => const ExOverlayEntry(),),
        GetPage(name: '/html', page: () => const ExHtmlView(),),
      ],
      theme: ThemeData(
        ///建议打开Material主题，否则页面风格太难看
        useMaterial3: true,
      ),
    );
  }

}


class GetHomePage extends StatefulWidget {
  const GetHomePage({super.key});

  @override
  State<GetHomePage> createState() => _GetHomePageState();
}

class _GetHomePageState extends State<GetHomePage> {
  ///这个类型是RxString ,定义RxXXX类型有三种方法:.obs,RxString,Rx<String>
  ///推荐使用.obs.它会自动初始化变量。比如下面就把int类型的变量初始化为0.
  var stateValue = "default value".obs;
  var intValue = 0.obs;
  var boolValue = false.obs;

  ///生成数据模型对象,注意与find的区别，find是查找已经有的对象
  var getController = Get.put(ValueController());

  ///创建数据模型对象，使用Obx响应式状态管理
  var valueModel = ValueController().obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of GetMaterialApp"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("this is body"),
          ///******* 第一部分：显示snackBar的两种方式，一种使用固定的样式，另外一种使用自定义样式
          ElevatedButton(
            onPressed: () {
              ///这个snb默认透明色而且是在顶部显示
              Get.snackbar("title", "Message");
            },
            child: const Text("show SnackBar"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.showSnackbar(
                  const GetSnackBar(
                    title: "Title",
                    message: "Message",
                    ///需要加显示时间，默认一直显示
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.blue,
                    ///控制snb与屏幕的边距
                    margin:EdgeInsets.only(bottom: 80,left: 16,right: 16),
                    ///不能像原生的snb一样控制形状，但是可以控制圆角，默认是矩形
                    borderRadius: 16,
                    ///会在snb顶部显示水平滚动条
                    showProgressIndicator: true,
                    ///这两个属性决定了snackBar的默认在底部显示
                    // this.snackPosition = SnackPosition.BOTTOM,
                    // this.snackStyle = SnackStyle.FLOATING,
                  )
              );
            },
            child: const Text("show custom SNB"),
          ),

          ///******* 第二部分：显示Dialog。演示了两种类型的dialog,第一种类似overlay,第二种是正常的dialog.
          ElevatedButton(
            onPressed:() {
              ///和官方Overlay的效果完全一样,不像dialog
              Get.dialog(//const Text("This is dialog"),
                ///这里控制dialog中的组件，可以是简单的文本，也可以是多种组件的组合
                const Column(
                  children: [
                    Text("Row1"),
                    Text("Row2"),
                  ],
                ),
                barrierColor: Colors.lightBlueAccent,
                ///不设置此属性不会有淡入淡出的效果，这里相当于给模糊层设置了一个淡入淡出的效果
                transitionDuration: const Duration(seconds: 2,),
              );
            } ,
            child: const Text("show Dialog"),
          ),
          ElevatedButton(
            onPressed:() {
              ///这个才是正常的Dialog，不过大小是自适应的，无法调整窗口的大小
              Get.defaultDialog(
                title: "Title",
                backgroundColor: Colors.greenAccent,
                content: const Text("Content , this ia a long text, which will shown at dialog,please check the size of dialog"),
                ///文字居中显示，无法调整位置
                // confirm: const Text("Yes"),
                // cancel:  const Text("No"),
                ///把文字转换成button,布局上仍然是居中显示
                confirm: ElevatedButton(
                  onPressed: () {
                    ///java获取时间戳的代码，与dart对比一下
                    //        long timestamp = Instant.now().getEpochSecond();
                    //         long timestamp1 = Instant.parse("2024-04-14T10:50:00.000000000Z").getEpochSecond();
                    //
                    //         LocalDate localDate = LocalDate.of(2024,4,14);
                    //         long timestamp2 =  localDate.atStartOfDay(ZoneOffset.UTC).toInstant().getEpochSecond();
                    //
                    //         System.out.println("timeStamp: "+timestamp+" size: "+String.valueOf(timestamp).length());
                    //         System.out.println("timeStam1: "+timestamp1+" size: "+String.valueOf(timestamp1).length());
                    //         System.out.println("timeStam2: "+timestamp2+" size: "+String.valueOf(timestamp2).length());
                    //         System.out.println("timeStam1: "+Instant.now().toString());
                    ///获取时间戳，默认带时区，utc方法中的不带时区，而且可以指定到某个时间点的时间戳，与268内容匹配，
                    ///在其它文件中还有时间戳相关的代码，暂时找不到位置。
                    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
                    String timeStamp1 = DateTime.utc(2024,4,14,0,0,0,0,0).millisecondsSinceEpoch.toString();
                    String timeStamp2 = DateTime.utc(2024,4,14,10,50,0,0,0).millisecondsSinceEpoch.toString();

                    debugPrint("time: $timeStamp size:${timeStamp.length}");
                    debugPrint("tim1: $timeStamp1 size:${timeStamp1.length}");
                    debugPrint("tim2: $timeStamp2 size:${timeStamp2.length}");
                  },
                  child: const Text("Yes"),
                ),
                cancel:  ElevatedButton(
                  ///这个navigator就是navigatorKey属性对应的值,通过它关闭dialog
                  onPressed: ( ) {navigator?.pop();},
                  child: const Text("No"),
                ),
                ///在窗口最底部和confirm/cancel按钮在一行
                actions: [
                  // Text("Action1"),
                  // Text("Action2"),
                ],
                buttonColor: Colors.purpleAccent,
                navigatorKey:Get.key,
              );
            } ,
            child: const Text("show Dialog"),
          ),

          ///******* 第三部分：状态管理:定义一个变量，后续用obs修饰，修改时使用.value修改，监听通过Obx组件。
          ///使用就这么三个步骤，非常简单和方便.Get包中还有两个状态管理组件GetX()和GetBuilder();
          ///这两个组件早于Obx()，使用上不如Obx方便，作者建议使用Obx()。可以查看官方文档。其中Obx和GetX是响应式状态管理
          ///GetBuilder是简单式状态管理,用法类型Provider.Obx是响应式的状态管理
          ///我使用后发现切换页面后Obx中的数据会恢复到初始化值，但是GetBuilder中的数据不会。
          ElevatedButton(
            ///在按钮事件中修改变量，按钮下方的Obx就可以监听到变量的变化并且更新组件
            onPressed: () {
              ///Obx更新当前页面中的数据
              stateValue.value = "new value";
              intValue.value = 666;
              boolValue.value = true;
              ///GetBuilder更新数据：下面两种方式都可以，推荐使用当前没有注释掉的方法
              // Get.find<ValueController>().updateValue();
              getController.updateValue();

              ///Obx更新数据模型中的数据,注意更新数据的方法
              valueModel.update((val) {
                val?.iValue = 999;
                val?.strValue = "String Value";
              });
            },
            ///官方文档中需要使用controller.stateValue,但是不需要，而且有语法错误
            // child: Obx(() => Text(${controller.stateValue}),),
            ///   obx是Observer of Rx的缩写
            child:Obx(() => Text("State management value: $stateValue"),),
          ),
          ///单独使用Obx组件,Obx监听当前页面中的数据
          Obx(() => Text("intValue: ${intValue.toString()}, boolValue: ${boolValue.toString()}"),),
          ///Obx监听数据模型类中的数据,页面再次进入时数据恢复默认值
          Obx(() => Text("intValue: ${valueModel.value.iValue.toString()}, strValue: ${valueModel.value.strValue}"),),
          ///使用GetBuilder监听数据更新
          GetBuilder<ValueController>(
            ///init可以加也可以不加，GetBuilder会自动获取该对象
            init: ValueController(),
            builder: (controller) {
              return Text("intValue: ${controller.iValue.toString()}, strValue: ${controller.strValue}");
            }
          ),

          ///******* 第四部分：路由管理
          ElevatedButton(onPressed: () {
            Get.defaultDialog(
              navigatorKey: Get.key,
              cancel: ElevatedButton(onPressed: () {
                ///必须给navigatorKey赋值，否则无法退出dialog.
                Get.back();
              }, child: const Text("cancel"),),
            );
          },
              child: const Text(" Show / Hidden Dialog"),
          ),
          Row(
            children: [
              ///正常跳转到下一个页面
              ElevatedButton(
                onPressed: () {
                  ///下面两种路由方法等效。
                  // Get.to(const ExHtmlView());
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExHtmlView()));
                },
                child: const Text("Go "),
              ),
              ///跳转到下一个页面，并且取消下一个页面的导航(返回箭头),从ExHtmlView页面返回后不会返回当前页面
              ///而是返回当前页面的上一个页面,下面两种方法等效。
              ElevatedButton(
                onPressed: () {
                  // Get.off(ExHtmlView());
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ExHtmlView()));
                },
                child: const Text("Off"),
              ),
              ///继续其它的路由方法
            ],
          ),

        ],
      ),
    );
  }
}

///这个是配合Obx和GetBuilder使用的数据模型类，用法类似Provider中的ViewModel
class ValueController extends GetxController {
  int iValue = 0;
  String strValue = "default string";

  void updateValue() {
    iValue = 666;
    strValue = "new String Value";
    update();
  }
}


