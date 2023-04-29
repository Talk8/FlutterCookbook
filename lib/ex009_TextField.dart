//代码和16l回的内容相匹配
import 'package:flutter/material.dart';

class ExTextField extends StatefulWidget {
  const ExTextField({Key? key}) : super(key: key);
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
      //如果在这里单独使用TextField,那么无法使用onChanged属性,必须嵌套一个statefull widget.
      //而且将它包含在布局类widget中，这也是代码中使用column包含它的原因
      body: const TextFieldStatefull(),
    );
  }
}

class TextFieldStatefull extends StatefulWidget {
  const TextFieldStatefull({Key? key}) : super(key: key);

  @override
  State<TextFieldStatefull> createState() => _TextFieldStatefullState();
}

class _TextFieldStatefullState extends State<TextFieldStatefull> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("This is the Text Widget"),
        Container( //Contain可以省略掉，这里只是为了控制TextField的大小
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10.0),
          width: 300,
          height: 60,
          child: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              print(value);
            },
            decoration: const InputDecoration(
              labelText: "Label",
              hintText: "Name",
              errorText: "It is wrong",
              prefixIcon: Icon(Icons.login),
              suffixIcon: Icon(Icons.panorama_fish_eye),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
        ),
        const Icon(Icons.drag_handle_rounded),
      ],
    );
  }
}
