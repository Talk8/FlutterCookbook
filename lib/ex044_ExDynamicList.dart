import 'package:flutter/material.dart';

class ExDynamicList extends StatefulWidget {
  const ExDynamicList({Key? key}) : super(key: key);

  @override
  State<ExDynamicList> createState() => _ExDynamicListState();
}

class _ExDynamicListState extends State<ExDynamicList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of DynamicList"),
        backgroundColor: Colors.purpleAccent,
      ),
      ///body是一个可以滚动的widget,类似Android中的screenView,IOS中的UIScreenView
      ///它可以包含比屏幕尺寸大的widget，比如listView,这样可以滚动显示
      body: SingleChildScrollView(
        child: Column(
          ///这里没有指定column的主轴和从轴对齐方式，从轴默认为center,column中的child的大小
          ///默认为所有children中宽度最大的一个，可以指定最小宽度
          children: [
            const Image(
              width: double.infinity,
              height: 200,
              image: AssetImage("images/ex.png"),
              fit:BoxFit.fill, ),
            const Text('data sample'),
            Container(
              decoration:BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8)) ,
              height: 200,
              child: ListView.builder(
                ///column中嵌套ListView会报hassize类型的的错误，即使指定list数量也不行
                ///Failed assertion: line 1966 pos 12: 'hasSize
                ///解决方法1:在ListView外层嵌套一个容器，指定容器大小来限定ListView的大小。
                ///该方法相当于创建了个局部List,容器内的List可以自由滚动,也可以通过physics属性让它不滚动
                ///解决方法2：使用shrinkWrap属性，
                itemCount: 10,
                ///设置该属性后ListView中的item不再滚动,但是它外层的scrollView可以滚动
                ///相当于屏蔽了自己的滚动事件，而是去响应外层的滚动事件
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index){
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("List item"),
                  ),
                );
                  },),
            ),
            Container(
              color: Colors.lightBlue,
              child: ListView.builder(
                ///用来控制List内部的边距，包含head和tail,如果去掉head和tail可以使用only方法
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
                itemBuilder:(context,index){
                  return const Card(
                    color: Colors.orange,
                    child: Padding(
                      ///这个padding可以控制card的大小，也就是listItem的大小
                      padding: EdgeInsets.all(8),
                      child: Text('Another List Item'),
                    ),
                  );
                },),
            ),
          ],
        ),
      ),
    );
  }
}
