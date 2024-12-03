import 'package:flutter/material.dart';

class Ex094Notification extends StatefulWidget {
  const Ex094Notification({super.key});

  @override
  State<Ex094Notification> createState() => _Ex094NotificationState();
}

class _Ex094NotificationState extends State<Ex094Notification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 90,
            child:Text("data"),
          ),

          Positioned(
            top: 120,
            child:ElevatedButton(
              onPressed: () { },
              child: const Text("show notification"),
            ),
          ),
        ],
      ),
    );
  }
}
