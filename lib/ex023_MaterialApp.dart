import 'package:flutter/material.dart';

/*
这个示例包含了MaterialApp中的属性示例，AppBar属性示例，
TabBar,TabView,TabController属性示例
Drawer示例，以及drawer中用户头像信息header
 */
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
            //默认使用系统设置，为true
            centerTitle: false,
            //会控制AppBar内所有的Icon
            iconTheme: const IconThemeData(
              color: Colors.yellow,
              size: 40.0,
            ),
            //只能控制AppBar内Actions里的Icon
            actionsIconTheme: const IconThemeData(
              color: Colors.green,
              size: 20.0,
            ),
            //如果主动添加了leading,，那么点击后不能弹出drawer,
            //给drawer赋值后会自动添加leading，而且在点击后弹出drawer
            // leading:const Icon(Icons.menu),
            actions: [
              const Icon(Icons.download),
              IconButton(
                  onPressed: () {
                    print("share value button clicked");
                  },
                  icon: Icon(Icons.share)),
            ],
            bottom: TabBar(
              labelColor: Colors.green,
              indicatorColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              onTap: (index) {
                print("$index is selected");
              },
              tabs: const [
                Icon(Icons.web),
                Icon(Icons.favorite),
                Icon(Icons.self_improvement),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Text("First TabBarView"),
              Text("Seconde TabBarView"),
              Text("Third TabBarView"),
            ],
          ),
          //drawer无法控制大小，可以在外层嵌套一个容器来调整大小
          // drawer: SizedBox(
          //   width: 200,
          //   height: 300,
          //   child: _drawer,
          // ),
         drawer: _drawer,
          // drawer: ExDrawer(),
          onDrawerChanged: (changed) {
            print("changed: $changed");
          },
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

//把drawer做成一个独立的对象
  final Drawer _drawer = Drawer(
    //设置整个drawer的背景颜色
    backgroundColor: Colors.lightGreen,
    width: 200,
    child: ListView(
      //drawer内部的list对drawer边缘的间距
      padding: const EdgeInsets.all(8),
      children: const [
        //使用sizebox调整header的大小没有效果
        SizedBox(
          width: 200,
          height: 200,
          child:
        //用来控制drawer最上部分的区域
        DrawerHeader(
          child: Text("The Header"),
          decoration: BoxDecoration(
            //只控制header区域的颜色，不设置时默认为主题的primerColor
            color: Colors.yellow,
            //使用图片当作boxdecoration的背景
            image: DecorationImage(
              image: AssetImage("images/ex.png"),
              //图像填充，这里的值是铺满整个屏幕
              fit: BoxFit.cover,
              //给背景图片添加颜色滤镜
              colorFilter:
                  ColorFilter.mode(Colors.greenAccent, BlendMode.hardLight),
            ),
          ),
        ),
        ),
        //drawer中的选项，也就是list中的item
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          //控制整个Listtile的颜色，而不只是title的颜色
          tileColor: Colors.blue,
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text("Messages"),
        ),
      ],
    ),
  );
}

//把drawer封装成一个widget
class ExDrawer extends StatefulWidget {
  const ExDrawer({Key? key}) : super(key: key);

  @override
  State<ExDrawer> createState() => _ExDrawerState();
}

class _ExDrawerState extends State<ExDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.lightGreen,
      child: ListView(
        padding: EdgeInsets.all(8),
        children: [
          //创建用户信息的头部
          UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("User Mail"),
            currentAccountPicture:CircleAvatar(
              backgroundImage:AssetImage("images/ex.png") ,
            ) ,
            otherAccountsPictures:const [
              CircleAvatar(
                backgroundColor: Colors.yellow,
              ),
              CircleAvatar(
                backgroundColor: Colors.pinkAccent,
              )
            ],
            //只有设置了otherAccountsPictures时才夫显示
            //和name,mail位于同一行，不过是在tail位置显示。
            arrowColor: Colors.redAccent,
            //name,mail和arraw中任何一个点击时回调此方法
            onDetailsPressed: (){print("details pressed");},
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              //header背景色与drawer背景色的混合效果
              backgroundBlendMode: BlendMode.hardLight,
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            //控制事个Listtile的颜色，而不只是title的颜色
            tileColor: Colors.blue,
            //点击这个条目关闭drawer,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text("Messages"),
          ),
        ],
      ),
    );
  }
}
