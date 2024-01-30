//代码和16l回的内容相匹配
import 'package:flutter/material.dart';

class ExTextField extends StatefulWidget {
  const ExTextField({Key? key}) : super(key: key);
  @override
  State<ExTextField> createState() => _ExTextField();
}

class _ExTextField extends State<ExTextField> {
  // _onTextChanged(String text) {
  //   debugPrint(' text $text changed');
  // }

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
        title: const Text("Example of TextField"),
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
  final TextEditingController _controller = TextEditingController();

  bool isPasswordVisible = false;
  String pwdValue = "";
  ///配合focus，用来判断输入的password是否为空
  bool isPwdEmpty = false;

  ///输入框不同需要不同的focusNode,不然会出现两个输入框中都有光标的现象
  final FocusNode pwd1FocusNode = FocusNode();
  // final FocusNode pwd2FocusNode = FocusNode();


  void _handlePwd1FocusChanged() {
    if(!pwd1FocusNode.hasFocus) {
      setState(() {
        if(pwdValue == "" || pwdValue.isEmpty) {
          isPwdEmpty = true;
        }else {
          if(pwdValue.length<6) {
            isPwdEmpty = true;
          }else {
            isPwdEmpty = false;
          }
        }
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //给控制器设置初始值
    _controller.text = "123456";
    //给控制器添加监听器，用来监听输入值的变化
    _controller.addListener(() {
      debugPrint("hello  listener ${_controller.text}");
    });

    ///添加监听器
    pwd1FocusNode.addListener(_handlePwd1FocusChanged);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //界面退出时需要销毁控制器不然会有内存渔泄漏的风险
    _controller.dispose();

    ///移除监听器
    pwd1FocusNode.addListener(_handlePwd1FocusChanged);
    pwd1FocusNode.dispose();

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
            ///设置初始值，可以监听值的变化,和onChanged中得到的值一样
            controller: _controller,
            keyboardType: TextInputType.number,
            ///这个值是输入框中所有的内容，而不是当前输入的某个内容
            onChanged: (value) {
              debugPrint("hello onchanged $value");
            },
            //这个值是输入框中所有的内容
            onSubmitted: (value){
              debugPrint("hello onSubmited $value");
            },
            decoration: const InputDecoration(
              //在输入框上显示
              labelText: "Label",
              hintText: "Name",
              //在输入框下方位置显示
              errorText: "It is wrong",
              ///通过修改Icon的大小，可以修改textFiled的大小
              // prefixIcon: Image(width: 80,image: AssetImage("assetName"),
              //输入框前面和后面的图标
              prefixIcon: Icon(Icons.login,),
              suffixIcon: Icon(Icons.panorama_fish_eye),
              border: OutlineInputBorder(),
              //无边框,无边框时不要设置label，不然会和hint重叠在一起
              // border: InputBorder.none,
              ///这两个值需要同时修改才有效果
              filled: true,
              fillColor: Colors.blue,
            ),
            //是否显示为密码形式，true时显示为小圆点
            obscureText: false,
          ),
        ),
        const Icon(Icons.drag_handle_rounded),
        ///实现一个密码输入框主要功能：显示隐藏密码
        Container(
          padding: const EdgeInsets.all(16),

          child: TextField(
            obscureText: !isPasswordVisible,
            keyboardType: TextInputType.text,
            ///添加光标监听器
            focusNode: pwd1FocusNode,

            decoration: InputDecoration(
              ///这两个一起使用才有填充颜色
              filled: true,
              fillColor: Colors.grey[200],

              ///属性值不为空时(!= null)显示errorText,
              errorText: isPwdEmpty? "password is empty": null,

              ///用来去掉输入框下面的横线
              border: InputBorder.none,
              ///实现显示和隐藏密码功能
              suffixIcon: IconButton(
                icon:isPasswordVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),

              ///失去焦点并且errorTest的值不为null时就显示
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color:Colors.red,width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              ///获得售点并且errorTest的值不为null时就显示
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color:Colors.red,width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            ///这里的值配合光标监听器和两个border一起实现红色边框错误提示功能
            onChanged: (value) {
              setState(() {
                if(value == "" || value.isEmpty) {
                  pwdValue = "";
                  isPwdEmpty = true;
                }else {
                  pwdValue = value;
                  isPwdEmpty = false;
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
