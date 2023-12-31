import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: Text("Example of Package: Get"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: (){
              Get.showSnackbar(
                GetSnackBar(
                  title: "Notice",
                  messageText: Text("Today is a holiday"),
                ),
              );
            },
            child:const  Text("show SanckBar"),
          ),
          ReadMoreText(
            "this is a long text,aaaaaaaaaaaaaaaaaaaa,bbbbbbbbbbbbbbb,ccccccccccc,",
            trimLines: 3,
            trimMode: TrimMode.Line,
            trimCollapsedText: "Show more",
            trimExpandedText: "Show Less",
            moreStyle: TextStyle(color: Colors.purpleAccent),

          ),

        ],
      ),
    );
  }
}
