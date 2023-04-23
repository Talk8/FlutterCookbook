//本代码和第七回的内容匹配，主要介绍GridView这个Widget

import 'package:flutter/material.dart';

class ExGirdView extends StatelessWidget {
  const ExGirdView({Key? key}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget girdViewEx = GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 0.5,
      children: const [
        Icon(Icons.light),
        Icon(Icons.arrow_back),
        Icon(Icons.light),
        Icon(Icons.hail),
        Icon(Icons.nat),
        Icon(Icons.hail),
        Icon(Icons.mail),
        Icon(Icons.hail),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("GirdView Example"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: girdViewEx,
    );
  }
}