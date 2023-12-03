
import 'dart:core';

import 'package:flutter/material.dart';

class ExDropDownMenu extends StatefulWidget {
  const ExDropDownMenu({super.key});

  @override
  State<ExDropDownMenu> createState() => _ExDropDownMenuState();
}

class _ExDropDownMenuState extends State<ExDropDownMenu> {
  List<DropdownMenuEntry<String>> list = [
    const DropdownMenuEntry<String>(value:"1", label: "One"),
    const DropdownMenuEntry<String>(value:"2", label: "Two"),
    const DropdownMenuEntry<String>(value:"3", label: "Three"),
  ];

  List<DropdownMenuItem<String>> itemList = [
    ///value和onChanged中的value一致，child是菜单项中显示的内容
    const DropdownMenuItem(value: "one",child:Text("niceDay"), ),
    const DropdownMenuItem(value: "two",child: Text("today"),),
    const DropdownMenuItem(value: "three",child: Text("yesterday"),),
  ];

  ///下拉菜单显示的默认值，这个值的类型与DropdownMenuEntry中指定的泛型类型相同
  String selectedValue = "default";

  ///下拉菜单显示的默认值，这个值的类型与DropdownMenuItem中指定的泛型类型相同，而且值只是它们中的数值，不能乱指定
  String itemSelectedValue = "two";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of DropdownMenu"),
      ),
      body: Column(
        children: [
          Center(
            child: DropdownMenu(
              width: 300,
              menuHeight: 400,
              ///下拉菜单中显示的内容
              dropdownMenuEntries: list,
              ///在显示内容前面的图标
              leadingIcon: const Icon(Icons.numbers),
              ///没有下拉时菜单中显示的内容
              label: Text(selectedValue),
              ///菜单右侧显示的图标，默认是一个实心的倒三角
              trailingIcon: const Icon(Icons.arrow_downward),
              ///下拉菜单时回调该方法
              onSelected: (value) {
                setState(() {
                  selectedValue = value.toString();
                });
              },
            ),
          ),
          const SizedBox(height: 88,),
          DropdownButton(
            ///这个显示的是被选择菜单项的值，它的类型与DropdownMenuItem中的泛型一致
            value: itemSelectedValue,
            ///下拉菜单的背景颜色
            dropdownColor: Colors.yellow,
            ///下拉菜单中文字的颜色
            style: const TextStyle(color: Colors.blue),
            iconSize: 32,
            icon: const Icon(Icons.schedule),
            items: itemList,
            onChanged: (value){
              debugPrint("it is : $value");
              setState(() {
                itemSelectedValue = value.toString();
              });
            },
          ),

        ],
      ),
    );
  }
}
