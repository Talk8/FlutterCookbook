import 'package:flutter/material.dart';

class Ex096PullDown extends StatefulWidget {
  const Ex096PullDown({super.key});

  @override
  State<Ex096PullDown> createState() => _Ex096PullDownState();
}

class _Ex096PullDownState extends State<Ex096PullDown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Sliding up panel'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Text("data"),
    );
  }
}
