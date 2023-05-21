import 'package:flutter/material.dart';
import 'package:fluttercookbook/ExLoadingPage.dart';
import 'package:fluttercookbook/ex004_GirdView.dart';
import 'package:fluttercookbook/ex005_Stack.dart';
import 'package:fluttercookbook/ex006_RouterNavigator.dart';
import 'package:fluttercookbook/ex007_Button.dart';
import 'package:fluttercookbook/ex009_TextField.dart';
import 'package:fluttercookbook/ex010_BottomNavigation.dart';
import 'package:fluttercookbook/ex011_progressIndicator.dart';
import 'package:fluttercookbook/ex013_Align_padding.dart';
import 'package:fluttercookbook/ex014_PointerEvent.dart';
import 'package:fluttercookbook/ex015_PageView.dart';
import 'package:fluttercookbook/ex016_Switch.dart';
import 'package:fluttercookbook/ex017_Gesture.dart';
import 'package:fluttercookbook/ex018_Dismissible.dart';
import 'ex001_ColumnRow.dart';
import 'ex002_ListView.dart';
import 'ex003_ImageWidget.dart';
import 'ex008_Text.dart';
import 'ex012_ConstrainedBox.dart';

void main() {
  runApp(const FlutterCookbookApp());
}

class FlutterCookbookApp extends StatelessWidget {
  const FlutterCookbookApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cookbook',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home: ExLoadingPage(),

      //这种方式的路由可以启动，但是有报错，与setState有关。
      routes: <String,WidgetBuilder>{
        "MyHomePage":(BuildContext context) => const MyHomePage(title: "My Home Page"),

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    ListTile listItem(
        String index, String title, BuildContext context, Widget drcWidget) {
      return ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              index,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
            const Icon(
              Icons.done_sharp,
              color: Colors.lightBlue,
            ),
          ],
        ),
        title: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return drcWidget;
            }));
          },
          child: Text(
            title,
          ),
        ),
      );
    }

    Widget listWidget = ListView(
      scrollDirection: Axis.vertical,
      children: [
        listItem("001", "Column and Row", context, const ExColumnRow()),
        listItem("002", "ListView", context, const ExListView()),
        listItem("003", "Image", context, const ExImage()),
        listItem("004", "GirdView", context, const ExGirdView()),
        listItem("005", "Stack", context, const ExStack()),
        listItem("006", "Router and Navigation", context, const SecondRouter(data: "send data")),
        listItem("007", "Button", context, const ExButton()),
        listItem("008", "Text", context, const ExText()),
        listItem("009", "TextField", context, const ExTextField()),
        listItem("010", "BottomNavigation", context, const ExBottomNavigation()),
        listItem("011", "ProgressIndicator", context, const ExProgressWidget()),
        listItem("012", "ConstrainedBox", context, const ExConstrainedBox()),
        listItem("013", "AlignAndPadding", context, const ExAlignAndPadding()),
        listItem("014", "PointerEvent", context, const ExPointerEvent()),
        listItem("015", "PageView", context, const ExPageView()),
        listItem("016", "Switch", context, const EXSwitch()),
        listItem("017", "Gesture", context, const ExGesture()),
        listItem("018", "Dismissble", context, const ExDismissble()),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: listWidget,
    );
  }
}
