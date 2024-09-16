import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:fluttercookbook/ex045_BleDemo/main.dart';
import 'package:fluttercookbook/ex045_BleTiDemo/main.dart';
import 'package:fluttercookbook/ex045_BleWithTTC.dart';
import 'package:fluttercookbook/ex045_BlueDemo.dart';
import 'package:fluttercookbook/ex045_Bluetooth.dart';
import 'package:fluttercookbook/ex043_ScreenSize.dart';
import 'package:fluttercookbook/ex044_ExDynamicList.dart';
import 'package:fluttercookbook/ex045_ExBleAll.dart';
import 'package:fluttercookbook/ex046_ExpandList.dart';
import 'package:fluttercookbook/ex047_ExAllKindsOfList.dart';
import 'package:fluttercookbook/ex048_ExModalBarrier.dart';
import 'package:fluttercookbook/ex049_ExMethodChannel.dart';
import 'package:fluttercookbook/ex050_StremProvider.dart';
import 'package:fluttercookbook/ex051_AsyncWidget.dart';
import 'package:fluttercookbook/ex052_WillPopScope.dart';
import 'package:fluttercookbook/ex053_WebView.dart';
import 'package:fluttercookbook/ex054_RedPoint.dart';
import 'package:fluttercookbook/ex055_AppIntroduce.dart';
import 'package:fluttercookbook/ex056_PageWithBg.dart';
import 'package:fluttercookbook/ex058_Rocker.dart';
import 'package:fluttercookbook/ex057_GestureGame.dart';
import 'package:fluttercookbook/ex059_SlidingUpPanel.dart';
import 'package:fluttercookbook/ex060_SlidingAnyDirection.dart';
import 'package:fluttercookbook/ex061_GeoLocator.dart';
import 'package:fluttercookbook/ex062_Slivers.dart';
import 'package:fluttercookbook/ex063_weather_app/app_main.dart';
import 'package:fluttercookbook/ex064_Picker.dart';
import 'package:fluttercookbook/ex065_BacgroundImage.dart';
import 'package:fluttercookbook/ex066_NavigationBar.dart';
import 'package:fluttercookbook/ex067_SearchBar.dart';
import 'package:fluttercookbook/ex068_ExSegmentedButton.dart';
import 'package:fluttercookbook/ex069_ExGradientColor.dart';
import 'package:fluttercookbook/ex070_ExSlideSwitcher.dart';
import 'package:fluttercookbook/ex071_SlideImage.dart';
import 'package:fluttercookbook/ex072_SliderNumber.dart';
import 'package:fluttercookbook/ex074_DropdownMenu.dart';
import 'package:fluttercookbook/ex075_CusTimePicker.dart';
import 'package:fluttercookbook/ex076_ScrollView.dart';
import 'package:fluttercookbook/ex077_DeviceAndPkgInfo.dart';
import 'package:fluttercookbook/ex078_liveData.dart';
import 'package:fluttercookbook/ex079_getMaterialApp.dart';
import 'package:fluttercookbook/ex079_getPkg.dart';
import 'package:fluttercookbook/ex080_keyboard.dart';
import 'package:fluttercookbook/ex081_filePicker.dart';
import 'package:fluttercookbook/ex081_image_video_picker.dart';
import 'package:fluttercookbook/ex082_image_video_picker_like_wechat.dart';
import 'package:fluttercookbook/ex083_lifecycle_of_page.dart';
import 'package:fluttercookbook/ex084_buble_windows.dart';
import 'package:fluttercookbook/ex085_onboarding_overlay.dart';
import 'package:fluttercookbook/ex086_overlay.dart';
import 'package:fluttercookbook/ex086_overlayEntry.dart';
import 'package:fluttercookbook/ex087_html_view.dart';
import 'package:fluttercookbook/ex088_riverpod.dart';
import 'package:fluttercookbook/ex089_vibration.dart';
import 'package:fluttercookbook/ex090_webview_in_app.dart';
import 'package:fluttercookbook/ex091_ex_three_js.dart';
import 'package:fluttercookbook/ex4view.dart';
import 'package:fluttercookbook/extest3.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lifecycle/lifecycle.dart';
// import 'package:logger/logger.dart';
///这两个包只能开一个，因为riverpod包中包含provider.
import 'package:provider/provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ex001_ColumnRow.dart';
import 'ex002_ListView.dart';
import 'ex003_ImageWidget.dart';
import 'ex008_Text.dart';
import 'ex012_ConstrainedBox.dart';
import 'ex045_BleDemo/src/ble/ble_device_connector.dart';
import 'ex045_BleDemo/src/ble/ble_device_interactor.dart';
import 'ex045_BleDemo/src/ble/ble_logger.dart';
import 'ex045_BleDemo/src/ble/ble_scanner.dart';
import 'ex045_BleDemo/src/ble/ble_status_monitor.dart';
import 'ex073_CusMutexWidget.dart';

void main() async{
  // runApp(const FlutterCookbookApp());
  ///共享数据是自定义的viewModel
  ///在整个应用的顶层设置Notifier,
  ///在整个应用的任何位置都可以使用viewModel中共享的数据
  ///多个ChangeNotifierProvider
  ///这个值是测试时使用的数值，用来测试provider.value()
  String shData = 'data of main';


  ///给ex045_BleDemo目录下的程序使用，主要用来管理共享数据
  late final FlutterReactiveBle _ble;
  late final BleLogger _bleLogger;
  late final BleScanner _scanner;
  late final BleStatusMonitor _monitor;
  late final BleDeviceConnector _connector;
  late final BleDeviceInteractor _serviceDiscoverer;

    // TODO: implement initState
  ///这行代码在模块的main文件中无法使用，但是在这个项目的main文件中可以使用，
  ///不在这里使用它反而会报错,使用后会重新安装程序，相当了卸载程序后再次安装
  WidgetsFlutterBinding.ensureInitialized();

  ///给ex045_BleDemo目录下的程序使用，主要用来管理共享数据
  _ble = FlutterReactiveBle();
    _bleLogger = BleLogger(ble: _ble);
    _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
    _monitor = BleStatusMonitor(_ble);
    _connector = BleDeviceConnector(
      ble: _ble,
      logMessage: _bleLogger.addToLog,
    );
    _serviceDiscoverer = BleDeviceInteractor(
      bleDiscoverServices: _ble.discoverServices,
      readCharacteristic: _ble.readCharacteristic,
      writeWithResponse: _ble.writeCharacteristicWithResponse,
      writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
      subscribeToCharacteristic: _ble.subscribeToCharacteristic,
      logMessage: _bleLogger.addToLog,
    );

  TestConsumer testConsumer = TestConsumer();

  ///让状态栏和程序的appBar融为一体构成沉浸式效果,android有效果，需要IOS是否有效果:IOS自动把app和系统融入为一体，不需要这样设置
  ///SystemChrome这个类及其方法只能在main方法中运行，其它地方无法使用
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    ///这两个属性可以控制状态栏为透明色,它可以和appBar的颜色一致,主要是去掉了阴影效果
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    ///修改状态栏中文字的颜色为黑色，没有效果
    // statusBarIconBrightness: Brightness.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  await GetStorage.init("db");
  ///全局禁止页面自动适用屏幕,打开注释掉的代码就可以
  /*
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MainApp()));
   */

  ///
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  ///下面是使用Provider当作状态管理的代码，注释掉后示例中与Provider关联的代码可以通过编译，但是有运行时错误
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider( create:(context) => ViewModel(), child: const FlutterCookbookApp(),),
  //       ChangeNotifierProvider( create:(context) => DeviceViewModel(), child: const FlutterCookbookApp(),),
  //       ///在078文件中LiveData中使用它
  //       ChangeNotifierProvider( create:(context) => LiveDataViewModel(), child: const FlutterCookbookApp(),),
  //       ///测试共享时使用的数据
  //       Provider.value(value: shData),
  //       ///测试类中共享数据
  //       Provider.value(value: testConsumer),
  //       ///使用StreamProvider共享stream中的数据,在ex050文件中通过consumer获取数据
  //       StreamProvider(create:(_) => Stream.periodic(const Duration(seconds: 2),(event)=>(event+1)).take(5),
  //           initialData: 9),
  //
  //       ///给ex045_BleDemo目录下的程序使用，主要用来管理共享数据
  //       Provider.value(value: _scanner),
  //       Provider.value(value: _monitor),
  //       Provider.value(value: _connector),
  //       Provider.value(value: _serviceDiscoverer),
  //       // Provider(create: (_) => _serviceDiscoverer,),
  //       Provider.value(value: _bleLogger),
  //       ///这个state本质上是一个stream，用来监听扫描到的设备列表，在BleScanner中的startScan
  //       ///方法中会通过该stream的controller向stream中添加设备
  //       StreamProvider<BleScannerState?>(
  //         create: (_) => _scanner.state,
  //         initialData: const BleScannerState(
  //           discoveredDevices: [],
  //           scanIsInProgress: false,
  //         ),
  //       ),
  //       StreamProvider<BleStatus?>(
  //         create: (_) => _monitor.state,
  //         initialData: BleStatus.unknown,
  //       ),
  //       StreamProvider<ConnectionStateUpdate>(
  //         create: (_) => _connector.state,
  //         initialData: const ConnectionStateUpdate(
  //           deviceId: 'Unknown device',
  //           connectionState: DeviceConnectionState.disconnected,
  //           failure: null,
  //         ),
  //       ),
  //     ],
  //     child:const FlutterCookbookApp(),),
  // );

  ///下面是使用riverpod当作状态管理的代码，注释掉后示例中与Provider关联的代码可以通过编译，但是有运行时错误
  runApp(
    const ProviderScope(
      child: FlutterCookbookApp(),
    ) ,
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
      ///locale属性可以手动指定当前app使用的语言和地区，如果不指定，默认为跟随系统语言
      ///在wechatAssetPicker中需要依据context中的语言来显示语言
      // locale: Locale('zh','CN'),
      // locale: const Locale('es'),
      localizationsDelegates: const [
        ///添加自己定义的多语言文字
        AppLocalizations.delegate,
        ///添加这三个delegate后界面上的文字就会自动适配手机当前的语言
        ///这三个库包含系统自带组件中使用的文字，比如日期组件中的年月日
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      //添加多国语言和语言对应的地区，IOS的版本在info.plist中添加
      supportedLocales: const [
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
        ),
        ///程序的亮度,相当于切换成dark主题
        // brightness: Brightness.dark,///默认值是light
        //打开Material3后会影响主题颜色和风格，最明显的就是按钮变成了椭圆形状
        useMaterial3: true,

        //在这里修改没有效果,不会影响bottomNavigationBar的颜色，原因？
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.green,
          selectedItemColor: Colors.white,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ///注释掉程序中的splashScreen
      // home: ExSplashScreen(),

      //这种方式的路由可以启动，但是有报错，与setState有关。
      routes: <String,WidgetBuilder>{
        "MyHomePage":(BuildContext context) => const MyHomePage(title: "My Home Page"),
        'SecondRouter':(BuildContext context) => const SecondRouter(data: 'data from home'),
        "080Page" : (BuildContext context) => const ExKeyboardPage(),
        "081Page" : (BuildContext context) => const ExFilePicker(),
        "010Page" : (BuildContext context) => const ExBottomNavigation(),
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
                  child: const SecondRouter(data: "animation",),);
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
          return const SecondRouter(data: 'data from home');
        });
      },
      ///用来监听Lifecycle中的事件
      navigatorObservers: [
        defaultLifecycleObserver,
      ],
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
///WidgetsBindingObserver只有放到MaterialApp的子组件下可以监听到消息，放在其它widget中无法监听到消息
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  ///引入ble共享数据后这个logger重名，因为它也使用了logger这个包，这里先不使用
  // Logger logger = Logger(
  //   printer: PrettyPrinter(
  //       methodCount: 0,
  //       printEmojis: false,
  //       printTime: true,
  //   ),
  // );

  ///注意：需要在initState中注册监听器并且在disPose中销毁监听器
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint(" app state: $state");
    super.didChangeAppLifecycleState(state);
  }


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
      ///反向显示列表内容，不然每次都要滑动很多列表才能使用新列表,不过反向显示后不在最后一个位置上
      ///可以通过controller控制滚动位置，不过位置=单行高度*行数
      // reverse: true,
      controller: ScrollController(initialScrollOffset: 80*70,keepScrollOffset: true),
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
          paramRatingedWidget:const Icon(FontAwesomeIcons.thumbsUp) ,paramUnRatingedWidget:const Icon(FontAwesomeIcons.thumbsUp),)),
        listItem("037", "CustomRatingBar - Face ", context, CustomRatingBar(rating: 7.0,countOfStar: 5,
          paramRatingedWidget:const Icon(FontAwesomeIcons.faceSmile) ,paramUnRatingedWidget:const Icon(FontAwesomeIcons.faceSmile),)),
        listItem("039", "SharedPreferences", context, const ExSharedPreferences()),
        listItem("040", "FileStored", context, const ExFileStored()),
        listItem("041", "SharedData/StateManaged", context, const EXSharedData()),
        listItem("042", "Animation ", context, const ExAnimation()),
        listItem("043", "Screen Size Auto fit", context, const ExScreenSize()),
        listItem("044", "ScrollView and Dynamic List", context, const ExDynamicList()),
        listItem("045", "BLE with ble_plus", context, const ExBleWithBluePlus()),
        listItem("045", "BLE with reactive_ble", context, const ExBleWithReactiveBlue()),
        listItem("045", "BLE DemoTIApp", context, const MyApp()),
        listItem("045", "FlutterBlueApp ", context, const FlutterBlueApp()),
        listItem("045", "FlutterReactiveBlueApp ", context, const ExReactiveBleDemo()),
        listItem("045", "BLE with TTC", context, const ExBleWithTTC()),
        listItem("046", "ExpandList, Flexible", context, const ExExpandList()),
        listItem("047", "All kinds of list", context, const ExAllKindsOfList()),
        listItem("048", "ModalBarrier", context, const ExModalBarrier()),
        listItem("049", "MethodChannel", context, const ExChannel()),
        listItem("050", "StreamProvider", context, const ExStreamProvider()),
        listItem("051", "CustomerAsyncWidget", context, const ExCustomerAsyncWidget()),
        listItem("052", "WillPopScopeWidget", context, const ExWillPopScope()),
        listItem("053", "WebViewWidget", context, const ExWebView()),
        listItem("054", "Badge or RedPoint", context, const ExRedPoint()),
        listItem("055", "App Introduce", context, const ExAppIntroduce()),
        listItem("056", "Page with image background", context, const ExPageWithBg()),
        listItem("057", "GestureGame", context, const ExGestureGame()),
        listItem("058", "Custom Rocker", context, const ExRocker()),
        listItem("059", "SlidingUpPanel", context, const ExSlidingUpPanel()),
        listItem("060", "SlidingMenu", context, const ExSlidingAnyDirection()),
        listItem("061", "GeoLocator", context, const ExGeoLocator()),
        listItem("062", "All kinds of Sliver", context, const ExSlivers()),
        listItem("063", "Weather App", context, const ExWeatherApp()),
        listItem("064", "KindsOfPicker", context, const ExAllPickers()),
        listItem("065", "Background Image", context, const ExBackgroundImage()),
        listItem("066", "NavigationBar ", context, const ExNavigationBar()),
        listItem("067", "SearchBar", context, const ExSearchBar()),
        listItem("068", "SegmentedButton", context, const ExSegmentedButton()),
        listItem("069", "GradientColor", context, const ExGradientColor()),
        listItem("070", "SlideSwitcher", context, const ExSliderSwitcher()),
        listItem("071", "SlideImage", context, const ExSlideImage()),
        listItem("072", "SlideNumber", context, const ExSlideNumber()),
        listItem("073", "CusMutexWidget", context, const ExMutexWidget()),
        listItem("074", "DropdownMenu", context, const ExDropDownMenu()),
        listItem("075", "CusTimePicker", context, const ExCusTimePicker()),
        listItem("076", "ScrollView", context, const ExScrollView()),
        listItem("077", "DeviceInfo", context, const ExDeviceInfo()),
        listItem("078", "LiveData", context, const ExCircleAvatar()),
        listItem("079", "Get", context, const ExGetPkg()),
        listItem("079", "GetMaterialApp", context, const ExGetMaterialApp()),
        listItem("080", "Keyboard", context, const ExKeyboardPage()),
        listItem("081", "FileAndImagePicker", context, const ExFilePicker()),
        listItem("081", "VideoAndImagePicker", context, const ExImageVideoPicker()),
        listItem("082", "VideoAndImagePicker", context, const ExMediaPickerLikeWechat()),
        listItem("083", "Page LifeCycle", context, const ExPageLifeCycle()),
        listItem("084", "Bubble Window", context, const ExBubleWidow()),
        listItem("085", "OnboardingOverly", context, const ExOnboardingOverlay()),
        listItem("086", "ScaffoldOverly", context, const ExScaffoldOverlay()),
        listItem("086", "FlutterOverly", context, const ExOverlayEntry()),
        listItem("087", "Html Widget", context, const ExHtmlView()),
        listItem("088", "Riverpod", context, const ExRiverPod()),
        listItem("089", "Vibration", context, const ExVibrate()),
        listItem("090", "WebViewInApp", context, const ExWebViewInApp()),
        listItem("091", "3D View", context, const ExTestThree()),
        listItem("092", "ThreeJs View", context, const ExThreeJsPage()),
        listItem("093", "Image View", context, const Ex4View()),
        // listItem("089", "Html Widget", context, const ExNavigation()),
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
    WidgetsBinding.instance.addObserver(this);

    ///添加延时，用来延长splash的显示时间
    Future.delayed(const Duration(seconds: 2),);
    ///在主程序页面中移除splash,这个插件没有产生实际效果，splash还是默认的laucher
    FlutterNativeSplash.remove();

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
    WidgetsBinding.instance.removeObserver(this);
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
