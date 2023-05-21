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
            key: Key(arrayList[index]),
            onDismissed: (direction) {
              arrayList.removeAt(index);
              print("$index is deleted");
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
