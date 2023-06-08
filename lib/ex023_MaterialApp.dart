import 'package:flutter/material.dart';

class ExMaterialApp extends StatefulWidget {
  const ExMaterialApp({Key? key}) : super(key: key);

  @override
  State<ExMaterialApp> createState() => _ExMaterialAppState();
}

class _ExMaterialAppState extends State<ExMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //如果MaterialApp有嵌套，那么每个都需要设置，特别是最外层的MaterialApp
      //外层设置后这里也要设置，不然不起作用，仍然显示Debug字样
      debugShowCheckedModeBanner: false,

      home: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Example of Material App"),
              bottom: TabBar(
                labelColor: Colors.green,
                indicatorColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                onTap: (index){
                  print("$index is selected");
                },
                tabs: const [
                  Icon(Icons.web),
                  Icon(Icons.favorite),
                  Icon(Icons.self_improvement),
                ],
              ),
            ),
            body:const TabBarView(
              children: [
                Text("First TabBarView"),
                Text("Seconde TabBarView"),
                Text("Third TabBarView"),
              ],
            ),
        ),
      ),
      theme: ThemeData(
        //用来控制主要的颜色，比如AppBar,button和默认颜色
        primarySwatch: Colors.deepPurple,
        //用来控制body体内的主要颜色
        scaffoldBackgroundColor: Colors.blueGrey,
      ),
    );
  }
}
