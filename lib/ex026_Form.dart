import 'dart:ffi';

import 'package:flutter/material.dart';

//对应Form以及TextFormField组件，以及验证，保存数据功能
class ExForm extends StatefulWidget {
  const ExForm({Key? key}) : super(key: key);

  @override
  State<ExForm> createState() => _ExFormState();
}

class _ExFormState extends State<ExForm> {
  final formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  String? _name = "Default Name";
  String? _pwd = "Defaulte_pwd";

  void loginWithForm() {
    //合法性验证成功则保存数据,否则打开自动验证功能，这样在用户输入后会自动关闭错误提示，这种体验比较好
    if (formKey.currentState!.validate()) {
      // _autoValidate = AutovalidateMode.disabled;
      //它会回调TextFormFiled中的onSave方法
      formKey.currentState?.save();
    } else {
      setState(() {
        _autoValidate = AutovalidateMode.always;
      });
    }
    //它会回调validator对应的回方法，成功返回true,错误返回错误信息（在验证方法中），显示在helperText位置
    // formKey.currentState?.validate();
    debugPrint("login clicked");
  }

  //返回有内容时会显示在help位置，而且边框颜色变成红色，返回为Null时不会显示出来
  String? _validateName(String? n) {
    if (n!.isEmpty)
      return "name is empty";
    else
      return null;
  }

  //返回有内容时会显示在help位置，而且边框颜色变成红色，返回为Null时不会显示出来
  String? _validatePwd(String? n) {
    if (n!.isEmpty) {
      debugPrint("pwd is empty");
      return "pwd is empty";
    } else {
      debugPrint("pwd is not empty");
      // return "pwd is not empty";
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example of Form"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Form(
        //通过key获取FormState
        key: formKey,
        child: Padding(
          //添加边距，不然会直接贴着边排列
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //FormField自身没有物理形状，它显示的内容是子组件的内容
              FormField(builder: (context) {
                return const Text("This is FormField");
              }),
              TextFormField(
                decoration: const InputDecoration(
                  //主要用来显示输入框的功能
                  labelText: "Name:",
                  //主要用来显示错误信息
                  helperText: "",
                  border: OutlineInputBorder(),
                  //无焦点时错误的颜色,默认是红色
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                    ),
                  ),
                  //有焦点时错误的颜色,最好和errorBorder一致,默认是红色
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                    ),
                  ),
                  //有售点时边框的颜色，默认是蓝色
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                //验证输入值的合法性
                validator: _validateName,
                //启用自动验证，默认是关闭状态，不建议打开,建议动态修改
                // autovalidateMode:AutovalidateMode.always,
                autovalidateMode: _autoValidate,
                //保存输入值
                onSaved: (value) {
                  _name = value;
                },
              ),
              //和name对应的TextFormField属性不一致，可以和对比它们之间不同的效果
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Pwd:",
                  //这个border修改无效果，参考上一个TextFormField组件中的修改
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                validator: _validatePwd,
                onSaved: (value) {
                  _pwd = value;
                },
              ),
              Container(
                width: double.infinity,
                height: 56.0,
                child: ElevatedButton(
                  onPressed: () => loginWithForm(),
                  child: Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
