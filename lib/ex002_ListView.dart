// 这个代码和第五回中的内容相对应
import 'package:flutter/material.dart';

class ExListView extends StatelessWidget {
  const ExListView({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ListTile listItem(IconData icon, String content) {
      return ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
        ),
        title: Text(
          content,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      );
    }

    Widget listEx = ListView(
      scrollDirection: Axis.vertical,
      children: [
        listItem(Icons.face, "One"),
        listItem(Icons.face, "One"),
        listItem(Icons.face, "One"),
        listItem(Icons.phone, "One"),
        listItem(Icons.cabin, "One"),
        listItem(Icons.cable, "One"),
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title:const Text("ListView example AppBar") ,
          backgroundColor: Colors.purpleAccent,
        ),
        body: listEx,
      );
  }
}