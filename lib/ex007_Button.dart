///本代码和第10回的代码匹配，主要介绍Button相关的内容
import 'package:flutter/material.dart';

class ExButton extends StatelessWidget {
  const ExButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("All kinds of Button Example"),
          backgroundColor: Colors.purpleAccent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //普通文字按钮
            TextButton(
              onPressed: () {},
              child: const Text(
                "This is Test Button",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                ),
              ),
            ),
            //描边按钮
            OutlinedButton(
              onPressed: () {},
              child: const Text("OutLineButton"),
            ),
            //带背景的按钮
            ElevatedButton(
              ///把onPressed属性设置为null后按钮处于disable状态：变灰色，而且没有任何点击效果
              ///可以依据相关的条件来disable/enable
              // onPressed: null,
              onPressed: () {},
              ///这个style可以button中文字和背景的配色：黑底白字
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text("ElevatedButton"),
            ),
            //同时带有文字和图标的按钮
            TextButton.icon(
              icon: const Icon(
                Icons.add,
                size: 36.0,
                color: Colors.lightGreen,
              ),
              onPressed: () {},
              label: const Text("TextButton"),
            ),
            OutlinedButton.icon(
                onPressed: (){},
                icon: const Icon(Icons.delete),
                label:const Text("Delete"),
            ),
            ElevatedButton.icon(
                onPressed: (){},
                icon: const Icon(Icons.search_rounded),
                label: const Text('search'),
            ),

            //水波效果，这个需要使用stack/position添加到某个组件上面
            //不然看不到透明色，只有点击时才有效果。
            Container(
              width: 300,
              height: 30,
              child: Material(
                //必须是透明色，否则没有效果
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.yellow.withOpacity(0.4),
                  highlightColor: Colors.greenAccent.withOpacity(0.8),
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
    );
  }
}
