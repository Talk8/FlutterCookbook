import 'package:flutter/material.dart';

class ExDismissble extends StatelessWidget {
  const ExDismissble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> arrayList =
        List<String>.generate(8, (index) => "Item $index of List");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: const Text("Example of Dismissible"),
      ),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return Dismissible(
            // key: Key(arrayList[index]),
            //使用上面方法中的key会有运行时错误，提示如下：
            //A dismissed Dismissible widget is still part of the tree.
            key: UniqueKey(),

            //是否确定删除当前的item,返回true删除，否则不删除
            confirmDismiss: (dirction) async {
              bool _result = false;
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Notice"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          arrayList.removeAt(index);
                          print("$index is deleted");
                          // arrayList.removeAt(index);
                          _result = true;
                        },
                        child: Text("Yes"),
                      ),
                      TextButton(
                        onPressed: () {
                          _result = false;
                          Navigator.of(context).pop();
                        },
                        child: Text("No"),
                      ),
                    ],
                  );
                },
              );
              return _result;
            },

            //确定删除后调用，在confirmDismiss后调用
            onDismissed: (direction) {
              print("onDismissed");
            },
            child: ListTile(
              title: Text(arrayList[index]),
            ),
          );
        },
      ),
    );
  }
}
