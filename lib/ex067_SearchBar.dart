import 'package:flutter/material.dart';

class ExSearchBar extends StatefulWidget {
  const ExSearchBar({super.key});

  @override
  State<ExSearchBar> createState() => _ExSearchBarState();
}

class _ExSearchBarState extends State<ExSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of SearchBar"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(bottom: 16),),
          const SearchBar(hintText:"Default SearchBar", ),
          const Padding(padding: EdgeInsets.only(bottom: 16),),
          const SearchBar(
            hintText:"add Icon SearchBar",
            leading: Icon(Icons.earbuds),
            trailing: [
              Icon(Icons.mic),
              Icon(Icons.search_rounded),
            ]
          ),
          const Padding(padding: EdgeInsets.only(bottom: 16),),
          SearchBar(
            hintText: "custom SearchBar",
            //修改背景颜色
            backgroundColor: const MaterialStatePropertyAll<Color>(Colors.grey),
            //控制内容与搜索框的边距
            padding:const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16),
            ),
            //修改形状
            shape: MaterialStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
            ),
            onTap: (){debugPrint("onTap:");},
            onChanged: (value){debugPrint("onChanged: $value");},
          )
        ],
      ),
    );
  }
}
