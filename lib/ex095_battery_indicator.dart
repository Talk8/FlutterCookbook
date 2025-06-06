import 'package:flutter/material.dart';

class Ex095BatteryIndicator extends StatefulWidget {
  const Ex095BatteryIndicator({super.key});

  @override
  State<Ex095BatteryIndicator> createState() => _Ex095BatteryIndicatorState();
}

class _Ex095BatteryIndicatorState extends State<Ex095BatteryIndicator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of BatteryIndicator"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
