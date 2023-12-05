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
      body: Column(
        children: [
          ///列中的长文本可以自动换行
          const Text( " Text Widget WidgetWidgetWidgetWidgetWidgetWidgetWidget",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                backgroundColor: Colors.cyan,
              ),
          ),
          const SizedBox(height: 16,),
          ///行中的长文本不可以自动换行，需要嵌套一个Expander组件
          const Row(
            children: [
              Expanded(
                child: Text( " Text Widget WidgetWidgetWidgetWidgetWidgetWidgetWidget",
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  backgroundColor: Colors.cyan,
                ),
                ),
              ),
            ],
          ),
          Container(
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
              //文字内容显示的最大行数
              maxLines: 1,
              //超过最大行数后显示三个点
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
