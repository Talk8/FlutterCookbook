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
import 'package:fluttercookbook/ex039_SharedPreferences.dart';
import 'package:fluttercookbook/ex040_FileOperation.dart';
import 'package:fluttercookbook/ex041_SharedData.dart';
import 'package:fluttercookbook/ex042_Animation.dart';
import 'package:fluttercookbook/ex045_Bluetooth.dart';
import 'package:fluttercookbook/ex043_ScreenSize.dart';
import 'package:fluttercookbook/ex044_ExDynamicList.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'ex001_ColumnRow.dart';
import 'ex002_ListView.dart';
import 'ex003_ImageWidget.dart';
import 'ex008_Text.dart';
import 'ex012_ConstrainedBox.dart';

void main() {
  // runApp(const FlutterCookbookApp());
  ///共享数据是自定义的viewModel
  ///在整个应用的顶层设置Notifier,
  ///在整个应用的任何位置都可以使用viewModel中共享的数据
  ///多个ChangeNotifierProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider( create:(context) => ViewModel(), child: const FlutterCookbookApp(),)
      ],
      child:const FlutterCookbookApp(),),
  );
  ///单个ChangeNotifierProvider
  // runApp(
  //   ChangeNotifierProvider(
  //     create:(context) => ViewModel(),
  //     child: const FlutterCookbookApp(),
  //   )
  // );
}

class FlutterCookbookApp extends StatelessWidget {
  const FlutterCookbookApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///只在Android有效果，在最近程序的缩略图中显示这个名称
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
      ///适配深色模式
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
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
        ///控制的范围比primaryColor大
        primarySwatch: Colors.blue,
        ///主要控制顶部导航和底部native bottom的颜色
        primaryColor: Colors.blue,

        ///组件背景颜色
        // canvasColor: Colors.blue[100],
        ///字体主题，通过Theme.of(context).TextTheme.xxx方式使用
        textTheme: const TextTheme(
          bodySmall: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 20),
          bodyLarge: TextStyle(fontSize: 22),
        )
        ///程序的亮度
        // brightness: Brightness.dark,///默认值是light
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ///注释掉程序中的splashScreen
      // home: ExSplashScreen(),

      //这种方式的路由可以启动，但是有报错，与setState有关。
      routes: <String,WidgetBuilder>{
        "MyHomePage":(BuildContext context) => const MyHomePage(title: "My Home Page"),
        'SecondRouter':(BuildContext context) => const SecondRouter(data: 'data from home'),
      },
      ///主要用来拦截不在routes属性中定义的路由，需要和pushNamed方法配合使用才能回调该属性对应的方法
      onGenerateRoute:(settings) {
        if(settings.name == 'SecondRouter') {
          debugPrint('setting: ${settings.toString()}');
          ///通过路由拦截器对个别的页面进行拦截，进而实现界面切换时的动画效果
          ///这里使用了PageRouteBuilder类和FadeTransition类
          return PageRouteBuilder(
              ///把动画传递给路由,annimation可以自己定义也可以使用参数中的默认值,不过2没有值
              pageBuilder:(context,animation1,animation2) {
                ///创建渐变组件主要使用了它的opacity属性
                return FadeTransition(
                  opacity: animation1,
                  child: SecondRouter(data: "animation",),);
              },
            fullscreenDialog: true,
            ///用来控制动画播放时长
            transitionDuration:const Duration(seconds: 3),
          );
          /*
          return MaterialPageRoute(builder: (context){
            return SecondRouter(data: 'data from home');
          },
              ///用来控制窗口的进入方式，默认从右到左，设置为true后从下到上，类似IOS中的modal窗口
              ///用这种方式弹出的窗口，左侧是一个x图标，而不是常用的back图标
              fullscreenDialog: true,
              ///如果路由中包含参数，一定要给这个属性赋值，不然路由中的参数为null
              settings: settings);
           */
        }else {
          debugPrint('setting: ${settings.toString()}');
          return null;
        }
      },
      ///主要用来拦截不在routes属性中定义的路由，需要和pushNamed方法配合使用才能回调该属性对应的方法
      ///优先级低于onGenerateRoute,只有onGenerateRoute方法返回Null时才回调此属性对应的方法
      onUnknownRoute: (settings) {
        debugPrint('unknown setting: ${settings.toString()}');
        return MaterialPageRoute(builder: (context){
          ///这里可以创建一个未知错误的界面，遇到未知路由则跳转到该界面
          return SecondRouter(data: 'data from home');
        });
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
            if(index == '006') {///通过参数来传递数据，数据类型是Object
              debugPrint('second router clicked');
              ///创建两个路由,SecondRouter不会被拦截，因为routers属性对应的路由表中有该属性
              ///ThirdRouter会被拦截，因它不在路由表中，先是onGenerateRoute拦截，但是没有处理，转到onUnknownRoute中
              Navigator.pushNamed(context, 'SecondRouter',arguments: 'data from arguments');
              Navigator.pushNamed(context, 'ThirdRouter',arguments: 'data from arguments');
            }else {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return drcWidget;
              }));
            }
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
        listItem("039", "SharedPreferences", context, const ExSharedPreferences()),
        listItem("040", "FileStored", context, const ExFileStored()),
        listItem("041", "SharedData/StateManaged", context, const EXSharedData()),
        listItem("042", "Animation ", context, const ExAnimation()),
        listItem("043", "Screen Size Auto fit", context, const ExScreenSize()),
        listItem("044", "ScrollView and Dynamic List", context, const ExDynamicList()),
        listItem("045", "BLE ", context, const ExBle()),
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
    super.initState();
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
    super.dispose();
    debugPrint('HomePage dispose');
  }

  @override
  void activate() {
    super.activate();
    debugPrint('HomePage activate');
  }

  @override
  void deactivate() {
    super.deactivate();
    debugPrint('HomePage deactivate');
  }

  @override
  void reassemble() {
    super.reassemble();
    debugPrint('HomePage reassemble');
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(widget);
    debugPrint('HomePage didUpdateWidget');
  }
}
