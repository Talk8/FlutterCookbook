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
      body: Column(
        children: [
          TextButton(onPressed: () {
            showBottomSheet(context: context, builder: (context){
              return BottomSheet(onClosing: (){}, builder: (context){
                return Container(
                  child: Text("bottom sheet"),
                );
              });

            });
          }, child: Text("show bottomSheet"),),
          Text("data"),
        ],
      ),
    );
  }
}
