import 'package:flutter/material.dart';

class ExModalBarrier extends StatefulWidget {
  const ExModalBarrier({Key? key}) : super(key: key);

  @override
  State<ExModalBarrier> createState() => _ExModalBarrierState();
}

class _ExModalBarrierState extends State<ExModalBarrier> {
  final List<String> _list = List.generate(5, (index) => "This is item: ${index + 1}");
  var _showModal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of ModalBarrier'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Stack(
        alignment: Alignment.center,
          children: [
        ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return SizedBox(height: 60, child: Text(_list[index]));
            }),
        SizedBox(
          width: 200,
          height: 300,
          child: ModalBarrier(
            // onDismiss: () => Navigator.maybePop(context),
            // onDismiss: () => Navigator.of(context).pop(),
            onDismiss: () => Navigator.of(context).removeRoute(ModalRoute.of(context) as Route),
            color: Colors.blue,
            semanticsOnTapHint: "hello",
          ),
        ),
            // if(_showModal) {
            //   return Text('a');
            // },
      ]),
    );
  }
}
