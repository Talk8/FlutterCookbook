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
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //给控制器设置初始值
    _controller.text = "123456";
    //给控制器添加监听器，用来监听输入值的变化
    _controller.addListener(() {
      print("hello  listener ${_controller.text}");
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    //界面退出时需要销毁控制器不然会有内存渔泄漏的风险
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("This is the Text Widget"),
        Container( //Contain可以省略掉，这里只是为了控制TextField的大小
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10.0),
          width: 400,
          height: 90,
          child: TextField(
            autofocus: true,
            //设置初始值，可以监听值的变化,和onChanged中得到的值一样
            controller: _controller,
            keyboardType: TextInputType.number,
            //这个值是输入框中所有的内容，而不是当前输入的某个内容
            onChanged: (value) {
              print("hello onchanged $value");
            },
            //这个值是输入框中所有的内容
            onSubmitted: (value){
              print("hello onSubmited $value");
            },
            decoration: const InputDecoration(
              //在输入框上显示
              labelText: "Label",
              hintText: "Name",
              //在输入框下方位置显示
              errorText: "It is wrong",
              //输入框前面和后面的图标
              prefixIcon: Icon(Icons.login),
              suffixIcon: Icon(Icons.panorama_fish_eye),
              border: OutlineInputBorder(),
              //无边框,无边框时不要设置label，不然会和hint重叠在一起
              // border: InputBorder.none,
            ),
            //是否显示为密码形式，true时显示为小圆点
            obscureText: false,
          ),
        ),
        const Icon(Icons.drag_handle_rounded),
      ],
    );
  }
}
