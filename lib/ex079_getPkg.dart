import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:timezone/timezone.dart'as tz;
import 'package:timezone/data/latest.dart' as tz;

class ExGetPkg extends StatefulWidget {
  const ExGetPkg({super.key});

  @override
  State<ExGetPkg> createState() => _ExGetPkgState();
}

class _ExGetPkgState extends State<ExGetPkg> {
  ///在这里创建对象，对象中的名称需要和main中初始化的名字相同，否则读取不到数据
  ///在main中不初始化也读取不到数据.
  final storage = GetStorage("db");

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();

  }
  
  
  @override
  Widget build(BuildContext context) {
    debugPrint(" read data: ${storage.read("test_key")}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Package: Get"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: (){
              Get.showSnackbar(
                const GetSnackBar(
                  title: "Notice",
                  messageText: Text("Today is a holiday"),
                ),
              );
            },
            child:const  Text("show SanckBar"),
          ),
          ///readMore插件，需要添加约束类容器，如果在column或者row中时没有效果。
          Container(
            width:  300,
            height: 260,
            color: Colors.lightGreen,
            child: const ReadMoreText(
              "this is a long text,aaaaaaaaaaaaaaaaaaaa,bbbbbbbbbbbbbbb,ccccccccccc,adfiiiiiidfdfdfd,afsfdfdll",
              // "Flutter is Google's mobile UI open source framework to build high-quality native(super fast) interfaces for IOS and Android Apps with the unified codebase",
              trimLines: 2,
              ///切换成length后不会省略内容
              trimMode: TrimMode.Line,
              colorClickableText: Colors.pink,
              trimCollapsedText: "Show more",
              trimExpandedText: "Show Less",
              moreStyle: TextStyle(color: Colors.purpleAccent),
              ///在正常文本前面显示的内容
              preDataText: "AMANDA",
            ),
          ),

          ///正常文件组件与readMore对比
          const Text( "Flutter is Google's mobile UI open source framework to build high-quality native(super fast) interfaces for IOS and Android Apps with the unified codebase",
          ),

          ///想试验一下3.0版本的新功能，但是无法通过编译
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: ReadMoreText(
              "This is sample test with a #hashtag, a mention<@123>, and a URL: https://pub.dev.",
              trimMode: TrimMode.Line,
              trimLines: 2,
              colorClickableText: Colors.pink,
              ///3.0版本才开始添加此功能,但是我的3.0版本无法通过编译
              // annotations:[
              //   Annotation(
              //       regExp: RegExp(r'#([a-zA-Z0-9_]+)'),
              //       ///这个参数是函数类型
              //       spanBuilder: ({required String text, TextStyle? textStyle}) => TextSpan(
              //         text: text,
              //         style: textStyle?.copyWith(color: Colors.yellow),
              //       ),
              //   ),
              // ],
            ),
          ),
          ///获取时区的方法，与267与265内容匹配
          ElevatedButton(onPressed: () async {
            ///获取时区，在future中获取,输出：future timeZone: Asia/Shanghai
            var timeZone = FlutterTimezone.getLocalTimezone().then((value){
              debugPrint("future timeZone: ${value.toString()}");
            });

            ///获取时区，通过异步中获取
            getTimeZone();
            ///获取时区，不起作用,需要使用future
            debugPrint("timeZone: ${timeZone.toString()}");

            ///使用await获取后需要该行代码运行完成后才能运行它后面的代码，注意该方法前面是async修饰。
            ///如果不加这两行代码，那么intl的Log先输了然后才是timeZone的log
            var value = await FlutterTimezone.getLocalTimezone();
            debugPrint("await timeZone: ${value.toString()}");


            ///使用timezone包获取时区,它包含了所有的时区，不过没有提供获取时区的接口，
            ///这个包主要用来转换时区时间
            var tzLocation = tz.timeZoneDatabase.locations;
            ///输出时区的key和value，不过都一样，eg:[US/Hawaii - US/Hawaii],这种格式也叫时区标识符
            ///这个输出的数据库，不过一共有430个而且还在更新
            for(int i=0; i<tzLocation.values.length; i++) {
              // debugPrint("tz $i timeZone: [${tzLocation.keys.toList()[i]} - ${tzLocation.values.toList()[i]}]");
            }


            ///BJ时间和lonton时间进行转换 Europe/London - Europe/London]
            var bjTime= DateTime.now();
            var bjTimezone = tz.getLocation("Asia/Shanghai");
            var ldTimezone = tz.getLocation("Europe/London");
            ///通过时间获取时区
            var ltTimeZones = ldTimezone.timeZone(bjTime.millisecondsSinceEpoch);
            var bjTimeZones = bjTimezone.timeZone(bjTime.millisecondsSinceEpoch);
            debugPrint("bjTimeZone is $bjTimeZones, ltTimeZone: $ltTimeZones");


            ///转换时间：北京时间8点转换成伦敦时间是几点？通过输出内容可以看到
            var ltTime = tz.TZDateTime.from(bjTime,ldTimezone);
            debugPrint("bjTime is $bjTime, ltTime: $ltTime");

            ///把2024-1-1-12：13这个时间转换成北京时区下的时间
            var time = tz.TZDateTime(bjTimezone,2024,1,1,12,13);
            debugPrint("change to bjTime is $time");

            ///获取语言区域
            debugPrint("intl timeZone: ${Intl.getCurrentLocale()}");
          }, child: const Text("timeZoned"),
          ),
          ///get_storage的示例
          ElevatedButton(
            onPressed: (){
              debugPrint("write data");
              storage.writeIfNull("test_key", "stored data");
            },
            child: const Text("write data"),),
        ],
      ),
    );
  }
  void getTimeZone () async {
    ///获取时区，输出：async timeZone: Asia/Shanghai
    var value = await FlutterTimezone.getLocalTimezone();
    debugPrint("async timeZone: ${value.toString()}");
  }
}
