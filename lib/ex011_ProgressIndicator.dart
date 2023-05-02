import 'package:flutter/material.dart';

class ExProgressWidget extends StatefulWidget {
  const ExProgressWidget({Key? key}) : super(key: key);

  @override
  State<ExProgressWidget> createState() => _ExProgressWidgetState();
}

class _ExProgressWidgetState extends State<ExProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Example of Progress indicator"),
          backgroundColor: Colors.purpleAccent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            LinearProgressIndicator(
              backgroundColor: Colors.blue,
              valueColor: AlwaysStoppedAnimation(Colors.purpleAccent),
              value: 0.5,
            ),
            CircularProgressIndicator(
              strokeWidth: 9,
              backgroundColor: Colors.blue,
              valueColor: AlwaysStoppedAnimation(Colors.yellow),
              value: 0.3,
            ),
            RefreshProgressIndicator(
              backgroundColor: Colors.blue,
              valueColor: AlwaysStoppedAnimation(Colors.yellow),
              value: 0.9,
            ),
          ],
        )
    );
  }
}
