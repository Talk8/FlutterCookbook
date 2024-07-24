import 'package:flutter/material.dart';

class ExThreeJsPage extends StatefulWidget {
  const ExThreeJsPage({super.key});

  @override
  State<ExThreeJsPage> createState() => _ExThreeJsPageState();
}

class _ExThreeJsPageState extends State<ExThreeJsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of ThreeJs"),
      ),
      body: Column(
        children: [
          Text("data"),
        ],
      ),
    );
  }
}
