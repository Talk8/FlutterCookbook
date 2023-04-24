//本代码和第10回的代码匹配，主要介绍Button相关的内容
import 'package:flutter/material.dart';

class ExButton extends StatelessWidget {
  const ExButton({Key?key}):super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("All kinds of Button Example"),
        backgroundColor: Colors.purpleAccent,
      ),
      body:Column(
        children: [
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
          OutlinedButton(
            onPressed: () {},
            child: const Text("OutLineButton"),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("ElevatedButton"),
          ),
        ],
      )
    );
  }
}