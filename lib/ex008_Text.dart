import 'package:flutter/material.dart';

class ExText extends StatelessWidget {
  const ExText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text Example"),
      ),
      body: Container(
        width: 300,
        height: 200,
        margin:const EdgeInsets.only(left:50,top:20,right: 0,bottom: 0) ,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.amberAccent,
          borderRadius:BorderRadius.all(Radius.circular(20)),
        ),
        child: const Text(
          " Text Widget WidgetWidgetWidgetWidgetWidgetWidgetWidget",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            backgroundColor: Colors.cyan,
          ),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
