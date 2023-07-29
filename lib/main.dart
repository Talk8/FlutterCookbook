import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttercookbook/ex024_Radio.dart';
import 'package:fluttercookbook/ex035_SplashScreen.dart';
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
import 'package:fluttercookbook/ex019_Dialog.dart';
import 'package:fluttercookbook/ex020_SnackBar.dart';
import 'package:fluttercookbook/ex021_TimePickerDialog.dart';
import 'package:fluttercookbook/ex022_Checkbox.dart';
import 'package:fluttercookbook/ex023_MaterialApp.dart';
import 'package:fluttercookbook/ex025_BoxDecoration.dart';
import 'package:fluttercookbook/ex026_Form.dart';
import 'package:fluttercookbook/ex027_Slider.dart';
import 'package:fluttercookbook/ex028_Chip.dart';
import 'package:fluttercookbook/ex029_DataTable.dart';
import 'package:fluttercookbook/ex030_PaginatedDataTable.dart';
import 'package:fluttercookbook/ex031_Card.dart';
import 'package:fluttercookbook/ex032_Localization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttercookbook/ex033_Clip.dart';
import 'package:fluttercookbook/ex034_IconCustom.dart';
import 'package:fluttercookbook/ex036_networkDIO.dart';
import 'package:fluttercookbook/ex037_CustomRatingBar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
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
      //locale属性可以手动指定当前app使用的语言和地区，如果不指定，默认为跟随系统语言
      // locale: Locale('zh','CN'),
      locale: Locale('es'),
      localizationsDelegates: [
        ///添加自己定义的多语言文字
        AppLocalizations.delegate,
        ///添加这三个delegate后界面上的文字就会自动适配手机当前的语言
        ///这三个库包含系统自带组件中使用的文字，比如日期组件中的年月日
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      //添加多国语言和语言对应的地区，IOS的版本在info.plist中添加
      supportedLocales: [
        Locale('en',"US"),
        Locale('zh',"CN"),
        Locale('es'),
      ],
      //这行代码可以替代上面的配置，因为它已经自动生成上面的配置
      // supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
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
      ///注释掉程序中的splashScreen
      // home: ExSplashScreen(),

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
  Logger logger = Logger(
    printer: PrettyPrinter(
        methodCount: 0,
        printEmojis: false,
        printTime: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    debugPrint('HomePage build');

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
        listItem("018", "Dismissible", context, const ExDismissble()),
        listItem("019", "Dialog and BottomSheet", context, const ExDialog()),
        listItem("020", "SnackBar and ToolTip", context, const ExSnackBar()),
        listItem("021", "Time and Date Picker Dialog", context, const ExTimeDatePicker()),
        listItem("022", "Checkbox and Transform", context, const ExCheckbox()),
        listItem("023", "MaterialApp", context, const ExMaterialApp()),
        listItem("024", "Radio and RadioListTitle", context, const ExRadio()),
        listItem("025", "BoxDecoration", context, const ExBoxDecoration()),
        listItem("026", "Form and TextFormField", context, const ExForm()),
        listItem("027", "Slider ", context, const ExSlider()),
        listItem("028", "Chip and Wrap", context, const ExChip()),
        listItem("029", "DataTable", context, const ExDataTable()),
        listItem("030", "PaginatedDataTable", context, const ExPaginatedDataTable()),
        listItem("031", "Card", context, const ExCard()),
        listItem("032", "Localization", context, const ExLocalization()),
        listItem("033", "Clip", context, const ExClip()),
        listItem("034", "Icon&FontIcon Future&Stream", context, const ExIconCustom()),
        listItem("035", "SplashScreen", context, const ExSplashScreen()),
        listItem("036", "NetworkDio", context, const ExNetworkDio()),
        ///使用自定义的评分条：三种不同的评分条，只有评分的形状不同
        listItem("037", "CustomRatingBar - Star", context, CustomRatingBar(rating:7.0)),
        listItem("037", "CustomRatingBar - DianZan", context, CustomRatingBar(rating: 7.0,countOfStar: 5,
          paramRatingedWidget:Icon(FontAwesomeIcons.thumbsUp) ,paramUnRatingedWidget:Icon(FontAwesomeIcons.thumbsUp),)),
        listItem("037", "CustomRatingBar - Face ", context, CustomRatingBar(rating: 7.0,countOfStar: 5,
          paramRatingedWidget:Icon(FontAwesomeIcons.faceSmile) ,paramUnRatingedWidget:Icon(FontAwesomeIcons.faceSmile),)),
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

  @override
  void initState() {
    debugPrint('HomePage initState');
    ///测试各种log输出
    // logger.v('initState');
    // logger.i('initState');
    // logger.w('initState');
    // logger.d('initState');
    // logger.e('initState');
  }

  @override
  void dispose() {
    debugPrint('HomePage dispose');
  }

  @override
  void activate() {
    debugPrint('HomePage activate');
  }

  @override
  void deactivate() {
    debugPrint('HomePage deactivate');
  }

  @override
  void reassemble() {
    debugPrint('HomePage reassemble');
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    debugPrint('HomePage didUpdateWidget');
  }
}
