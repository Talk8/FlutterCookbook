import 'package:flutter/material.dart';

///与121，122扩展列表和扩展内容相匹配
///与124 Flexible相关的内容匹配
///与125，list，map转换知识相匹配
///与126 级联操作知识相匹配
///与127 空安全相关的知识匹配
class ExExpandList extends StatefulWidget {
  const ExExpandList({Key? key}) : super(key: key);

  @override
  State<ExExpandList> createState() => _ExExpandListState();
}

class _ExExpandListState extends State<ExExpandList> {
  bool isExpand = true;
  final Map<int,bool> _isExpandList = {0:false,1:false,2:false};
  late final ListView _listView;

  ///可空类型不需要初始化，非可空类型必须初始化不然报错
  int ? nonIntValue;
  TestObject? nonTObj;
  // int intValue;

  @override
  void initState() {
    // TODO: implement initState
    ///List和map相互转换
    List<int> intList = List.generate(3, (index) => index+2);
    List<String> strList = ['one','two','three','four','five'];
    List<int> filterList = intList.map((e) => e+3).toList();
    Map<int,int> iMap = {1:1,2:2};
    ///list转换成map时索引值从0开始，与索引值对应的value就是list中的元素的值
    ///map[key,value]，list= [];key=index...,value=list[index];
    Map<int,int> intMap = intList.asMap();
    Map<int,String> strMap = strList.asMap();
    ///map的key和value可以单独转换成list
    List<int> exchangeIntList = intMap.values.toList();
    List<int> exchangeIntListKey = intMap.keys.toList();
    List<String> exchangeStrList = strMap.values.toList();
    ///字符串拼接
    String values = strMap.values.join('-');

    ///list添加单个元素
    strList.add(values);
    ///list使用级联操作符添加多个元素。级联操作符是两个点，可以使用同一个对象多次调用对象中的方法。
    ///它的第一个点可以理解为返回this，也就是当前对象
    strList
      ..add('six')
      ..add('seven')
      ..remove('two')
      ..add('eight');

    ///在对象上使用级联操作符，多次调用了类的属性和func方法
    TestObject tObj = TestObject(1, 'a');
    tObj.func();
    tObj
      ..a = 3
      ..b = 'b'
      ..func();

    ///三个点的使用方法：用来给List赋值，相当把一个List完全复制给另外一个List
    List<Text> textList = [Text('a'),Text('b'),Text('c'),];
    List<ListTile> tileList = [ListTile(title: Text('aa'),),ListTile(title: Text('bb'),),ListTile(title: Text('cc'),),];

    _listView = ListView(
      shrinkWrap: true,
      children: [
        ...strList.map((e) => ListTile(title: Text(e)),).toList(),
        ...textList.map((e) => ListTile(title: e,),).toList(),
        ...tileList.map((e) => e,).toList(),
      ],
    );

    Future<String> future = Future.value("one");
    future.then((value) => debugPrint(value))
        .onError((error, stackTrace) => debugPrint('error: ${error.toString()}'))
        .whenComplete(() => debugPrint('complete')) ;

    debugPrint('intList: ${intList.toString()}');
    debugPrint('strList: ${strList.toString()}');
    debugPrint('intMap: ${intMap.toString()}');
    debugPrint('strMap: ${strMap.toString()}');
    debugPrint('ex_intList: ${exchangeIntList.toString()}');
    debugPrint('ex_intList: ${exchangeIntListKey.toString()}');
    debugPrint('ex_strList: ${exchangeStrList.toString()}');
    debugPrint('strValue: $values');

    ///空安全相关内容
    nonIntValue = 3;
    TestObject temp = TestObject(1, 'good');
    ///非空变量可以赋值给可空变量，但是可空变量不能赋值给非空变量
    // nonTObj = temp;
    // temp = nonTObj;
    ///使用可空对象,如果对象为空则不做任何操作，不会访问对象的属性a
    debugPrint('value: ${nonTObj?.a}');

    ///变量的值肯定不为空，这样做不太好，虽然可以通过编译，但是会引起运行时异常
    // debugPrint('value: ${nonTObj!.a}');

    ///判断对象是否为空：如果为空则括号中的值为temp,否则为nonTObj
    debugPrint('value: ${(nonTObj ?? temp).toString()}');
    if(nonTObj == null) {
      debugPrint('nonTobj is null');
    } else {
      debugPrint('nonTobj is not null');
    }

    ///三元操作符
    (nonTObj == null) ? debugPrint('nonTobj is null'): debugPrint('nonTobj is not null');


    super.initState();
  }
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
            },
            child: const Text('Button'),
          ),
          ///Flexible可以填充满整个屏幕的剩余空间，如果有多个Flexible,可以通过flex属性控制容器的占比
          Flexible(
            ///用来控制容器占用的比例
            flex: 2,
            child: _listView,
          ),
          ///这里使用scrollView当作外层容器也会报错，
          // SingleChildScrollView(
          Flexible(
            child: _listView,
          ),
        ],
      ),
    );
  }
}

///测试类，主要用来演示级联操作在对象上的用法
class TestObject {
  int a;
  String b;

  TestObject(this.a, this.b);

  void func(){
    debugPrint('func: a= $a,b= $b');
  }

  @override
  String toString() {
    // TODO: implement toString
    return ('a = $a, b = $b');
  }
}