import 'package:flutter/material.dart';

class EXSwitch extends StatefulWidget {
  const EXSwitch({Key? key}) : super(key: key);

  @override
  State<EXSwitch> createState() => _EXSwitchState();
}

class _EXSwitchState extends State<EXSwitch> {
  bool setValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: const Text("Example of Switch Widget"),
      ),
      body: Container(
        color: Colors.lightBlue,
        alignment: Alignment.center,
        width: 92,
        height: 92,
        child: Switch(
          //开关打开时的颜色
          activeColor: Colors.purpleAccent,
          //开关没有打开时的颜色
          inactiveThumbColor: Colors.yellow,
          inactiveTrackColor: Colors.yellow,
          value: setValue,
          onChanged: (v) {
            print("value is ${v}");
            setState(() {
              setValue = v;
            });
          },
        ),
      ),
    );
  }
}
