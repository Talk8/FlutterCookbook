//代码和16l回的内容相匹配
import 'package:flutter/material.dart';

class ExTextField extends StatefulWidget {
  const ExTextField({Key?key}):super(key: key);
  @override
  State<ExTextField> createState() => _ExTextField();
}

class _ExTextField extends State<ExTextField> {
  _onTextChanged(String text) {
    print(' text $text changed');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const StateTextField();
  }
}

class StateTextField extends StatefulWidget {
  const StateTextField({super.key});
  @override
  State<StatefulWidget> createState() => _stateTextField();
}

class _stateTextField extends State<StateTextField> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Example of TextField"),
      ),
      body:const TextField(
        autofocus: true,
        keyboardType: TextInputType.number,
        onChanged: (value) => print(value);
        decoration: InputDecoration(
          labelText: "Label",
          hintText: "Name",
          errorText: "It is wrong",
          prefixIcon: Icon(Icons.login),
          suffixIcon: Icon(Icons.panorama_fish_eye),
          border: OutlineInputBorder(),
        ),
        // obscureText: true,
      ),
    );
  }
}