import 'package:flutter/gestures.dart';
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
          Container(
            width: 300,
            height: 64,
            color: Colors.grey,
            ///这个组件不能单独使用，需要嵌套到其它组件中才可以，不然无法被显示到页面上
            ///TextSpan不能单独使用，需要RichText把它渲染到屏幕上
            child: RichText(text: TextSpan(
              ///默认显示白色文字
              text: "Hello",
              ///通过此属性组合多个TextSpan组件在一起，形成一个完整文本
              children: [
                ///这里不能使用此组件
                // Text("good"),
                ///第一个文本
                TextSpan(text: "Flutter",
                  ///通过style让不同的文本显示不同的内容
                  style: const TextStyle(color: Colors.lightBlue,
                  ///用来显示下划线，删除线等
                  decoration: TextDecoration.underline,
                  ),
                  ///添加手势事件
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      debugPrint("it is Gesture event");
                    }
                ),
                ///第二个文本,和第一个文本组成完整的文本
                const TextSpan(text: ",We are coming!"),
              ]
            ),
            ),
          ),
        ],
      ),
    );
  }
}
