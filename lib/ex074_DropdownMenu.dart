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

  ///下拉菜单显示的默认值，这个值的类型与DropdownMenuEntry中指定的泛型类型相同
  String selectedValue = "default";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of DropdownMenu"),
      ),
      body: Center(
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
    );
  }
}
