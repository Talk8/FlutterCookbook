import 'package:flutter/material.dart';

class ExExpandList extends StatefulWidget {
  const ExExpandList({Key? key}) : super(key: key);

  @override
  State<ExExpandList> createState() => _ExExpandListState();
}

class _ExExpandListState extends State<ExExpandList> {
  bool isExpand = true;
  final Map<int,bool> _isExpandList = {0:false,1:false,2:false};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of ExpandList'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          ///扩展列表，包含多个item,每个item右侧有倒三角显示，点击时可以打开/关闭扩展。
          ///列表中的子项item是ExpansionPanel和listTile或者ExpansionTile,
          ///ExpansionPanel会自动在item右侧添加倒三角，以及divider,不过在扩展显示时会在item上下位置处有空隙,
          ///其它widget则不会自动添加倒三角和divider,不过在扩展显示时不会在item上下位置处有空隙
          ///官方热议是使用ExpansionPanel
          ExpansionPanelList(
            ///扩展图标的颜色，就是哪个倒三角,与canTapOnHeader属性关联:该属性为true时颜色值不起作用
            expandIconColor: Colors.green,
            dividerColor: Colors.red,
            ///点击列表中内容时的回调函数，通过此属性修改isExpanded属性中的值，实现扩展/隐藏列表的功能
            expansionCallback: (index,expanded){
              debugPrint('index: $index, value: $expanded');
              _isExpandList[index] = !expanded;
              setState(() {
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (context,isExpand){
                  ///通过sizedBox调整列表中子项的高度,也可以body中添加多个child，子项的高度会自动扩展
                  ///注意：子项目内容过多时考虑使用list，不然在扩展时有可能会超过屏幕大小，引起运行时错误（在屏幕上显示黄色警告)
                  return const SizedBox(height:30,child: Text('header 0'));
                },
                body: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ListTile(title: Text("item 1"),leading: Icon(Icons.podcasts),trailing: Icon(Icons.check),),
                    ListTile(title: Text("item 2"),leading: Icon(Icons.podcasts),trailing: Icon(Icons.check),),
                    ListTile(title: Text("item 3"),leading: Icon(Icons.podcasts),trailing: Icon(Icons.check),),
                    ListTile(title: Text("item 4"),leading: Icon(Icons.podcasts),trailing: Icon(Icons.check),),
                    ListTile(title: Text("item 5"),leading: Icon(Icons.podcasts),trailing: Icon(Icons.check),),
                  ],
                ),
                isExpanded: _isExpandList[0] ?? false,
                canTapOnHeader: true,
              ),
              ExpansionPanel(
                headerBuilder: (context,isExpand) {
                return const Text('header1');
              },
                body: const Text('body1'),
                ///默认是扩展还是隐藏，默认值为false
                // isExpanded: isExpand,
                isExpanded: _isExpandList[1] ?? false,
                ///点击header是否调用回调方法，默认是false,最好设置为true,不然只有点击倒三角时才有反应
                canTapOnHeader: true,
                backgroundColor: Colors.blue,
              ),
              ExpansionPanel(
                headerBuilder: (context,isExpand) {
                  return const Text('header2');
                },
                body: const ExpansionTile(
                  title: Text('body2'),
                  leading: Icon(Icons.abc),
                  trailing: Text('trailing'),
                ),
                isExpanded: _isExpandList[2] ?? false,
                canTapOnHeader: true,
              ),
            ],
          ),
          ///它可以通过children包含多个widget,并且默认隐藏这些widget,点击标题打开隐藏内容，再点击时隐藏内容
          ///它也可以当作列表中的一项内容嵌入到ExpansionPanelList中。总之它既可以扩展内容也可以被包含到扩展内容中
          ///它扩展内容时与ExpansionPaneList扩展内容的不同之处在于可以自动打开/关闭扩展内容，
          ///点击title可以打开/关闭扩展，而且title的颜色会自动改变 ,不过没有右侧的倒三角,也没有divider
          ///对比：ExpansionPaneList适合显示多条可扩展内容，ExpandTile只能照显示一条扩展内容
          ExpansionTile(
            title: const Text('signal expansionTile'),
            subtitle:const Text('sub signal expansionTile'),
            leading: const Icon(Icons.pages),
            trailing: const Text('end'),
            ///是否扩展显示children中的内容
            initiallyExpanded: false,
            onExpansionChanged: (value) {
              debugPrint('value: $value');
            },
            children: const [
              ListTile(title: Text("item 1"),leading: Icon(Icons.podcasts),trailing: Icon(Icons.check),),
              ListTile(title: Text("item 2"),leading: Icon(Icons.podcasts),trailing: Icon(Icons.check),),
              ListTile(title: Text("item 3"),leading: Icon(Icons.podcasts),trailing: Icon(Icons.check),),
              ListTile(title: Text("item 4"),leading: Icon(Icons.podcasts),trailing: Icon(Icons.check),),
              ListTile(title: Text("item 5"),leading: Icon(Icons.podcasts),trailing: Icon(Icons.check),),
            ],
          ),
          const Text('item of ExpansionPaneList'),
          const ListTile(title: Text("item 3"),leading: Icon(Icons.podcasts),trailing: Icon(Icons.check),),
          ElevatedButton(
            onPressed:() {
              debugPrint('hello');
              List<int> intList = List.generate(3, (index) => index+2);
            },
            child: const Text('Button'),
          ),
        ],
      ),
    );
  }
}
