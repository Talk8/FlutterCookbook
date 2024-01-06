import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class ExGetPkg extends StatefulWidget {
  const ExGetPkg({super.key});

  @override
  State<ExGetPkg> createState() => _ExGetPkgState();
}

class _ExGetPkgState extends State<ExGetPkg> {
  @override
  Widget build(BuildContext context) {
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
          const ReadMoreText(
            "this is a long text,aaaaaaaaaaaaaaaaaaaa,bbbbbbbbbbbbbbb,ccccccccccc,",
            trimLines: 3,
            trimMode: TrimMode.Line,
            trimCollapsedText: "Show more",
            trimExpandedText: "Show Less",
            moreStyle: TextStyle(color: Colors.purpleAccent),

          ),

          ElevatedButton(onPressed: (){
            ///获取时区，在future中获取,输出：future timeZone: Asia/Shanghai
            var timeZone = FlutterTimezone.getLocalTimezone().then((value){
              debugPrint("future timeZone: ${value.toString()}");
            });

            ///获取时区，通过异步中获取
            getTimeZone();
            ///获取时区，不起作用,需要使用future
            debugPrint("timeZone: ${timeZone.toString()}");

            ///获取语言区域
            debugPrint("intl timeZone: ${Intl.getCurrentLocale()}");
          }, child: const Text("timeZoned"),
          ),
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
