import 'package:flutter/material.dart';
import 'package:fluttercookbook/ex007_Button.dart';

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
   final ThemeData _customTheme = ThemeData(
         //控制AppBar以及它上面内容的背景色
         primarySwatch: Colors.orange,
         canvasColor: Colors.redAccent,
         //控制AppBar以下界面的背景色
         scaffoldBackgroundColor:Colors.blue,
   );

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return MaterialApp(
      //如果MaterialApp有嵌套，那么每个都需要设置，特别是最外层的MaterialApp
      //外层设置后这里也要设置，不然不起作用，仍然显示Debug字样
      debugShowCheckedModeBanner: false,
     //指定根路由，根路由变化后当前页面也会变成根路由中指定的页面
      //通俗点讲就是home属性对应的页面换成了根路由对应的页面
     // initialRoute: "/" ,

      home: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Example of Material App"),
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
                    debugPrint("share value button clicked");
                  },
                  icon: const Icon(Icons.share)),
            ],
            bottom: TabBar(
              labelColor: Colors.green,
              indicatorColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              onTap: (index) {
                debugPrint("$index is selected");
              },
              tabs: [
                const Icon(Icons.web),
                //使用主题覆盖单独修改第二个图标的颜色
                Theme(
                  data: themeData.copyWith(
                    iconTheme: themeData.iconTheme.copyWith(color: Colors.red),
                  ),
                    child:const Icon(Icons.favorite),
                ),
                const Icon(Icons.self_improvement),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TextButton(
                child: const Text("First TabBarView"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder:(context){
                      return const ExButton();
                    },
                    ///用来控制窗口的进入方式，默认从右到左，设置为true后从下到上，类似IOS中的modal窗口
                    fullscreenDialog: true,)
                  );
                },
              ),
              const Text("Seconde TabBarView"),
              const Text("Third TabBarView"),
            ],
          ),
          //drawer无法控制大小，可以在外层嵌套一个容器来调整大小
          // drawer: SizedBox(
          //   width: 200,
          //   height: 300,
          //   child: _drawer,
          // ),
          // drawer: _drawer,
          drawer: const ExDrawer(),
          onDrawerChanged: (changed) {
            debugPrint("changed: $changed");
          },
        ),
      ),
      //创建命名路由
      routes: {
        //定义根路由,注意home属性有值后不能在此指定根路由，否则报错
        // "/": (context) => ExPageView(),
        // =>写法是一个语法糖，它和MaterialPageRoute中的build属性相同
        "/ButtonExample": (context) => const ExButton(),

      },
      //使用自定义的主题的两种方式
      theme: _customTheme,
      /*
      theme: ThemeData(
        //用来控制主要的颜色，比如AppBar,button和默认颜色
        primarySwatch: Colors.deepPurple,
        //用来控制body体内的主要颜色
        scaffoldBackgroundColor: Colors.blueGrey,
      ),
       */

      /*
      //对父应主题进行扩展，或者说覆盖父主题
      theme: Theme.of(context).copyWith(
          primaryColor: Colors.red,
          scaffoldBackgroundColor:Colors.redAccent, ),
       */
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
            child: Text("The Header"),
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
        padding: const EdgeInsets.all(8),
        children: [
          //创建用户信息的头部
          UserAccountsDrawerHeader(
            accountName: const Text("User Name"),
            accountEmail: const Text("User Mail"),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("images/ex.png"),
            ),
            otherAccountsPictures: const [
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
            onDetailsPressed: (){debugPrint("details pressed");},
            decoration: const BoxDecoration(
              color: Colors.greenAccent,
              //header背景色与drawer背景色的混合效果
              backgroundBlendMode: BlendMode.hardLight,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            //控制事个Listtile的颜色，而不只是title的颜色
            tileColor: Colors.blue,
            //点击这个条目关闭drawer,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text("Messages"),
            //点击这个条目跳转到其它页面r,
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context){
              //     return ExButton();
              //   })
              // );

              //下面代码是上面代码的语法糖式写法
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) => ExButton())
              // );

              //使用命名路由
              Navigator.pushNamed(context,"/ButtonExample");
            },
          ),
        ],
      ),
    );
  }
}
