import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttercookbook/ex063_weather_app/app_routes.dart';
import 'package:fluttercookbook/ex063_weather_app/app_theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ExWeatherApp extends StatefulWidget {
  const ExWeatherApp({super.key});

  @override
  State<ExWeatherApp> createState() => _ExWeatherAppState();
}

class _ExWeatherAppState extends State<ExWeatherApp> {
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  );
  @override
  Widget build(BuildContext context) {
    ///使用provider进行状态管理
    return MultiProvider(
      providers:[
        StreamProvider<ServiceStatus>(
          create: (_) => Geolocator.getServiceStatusStream(),
          initialData: ServiceStatus.disabled),
      ],
      ///使用ScreenUtil三方包进行屏幕适配
      child: ScreenUtilInit(
        designSize: const Size(375.0,667.0),
        builder: (context,child){
          return const MainApp();
        },
        child: const MainApp(),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: AppThemes.appDarkTheme,
      theme: AppThemes.appNormalTheme,
      routes: AppRoutes.routes,
      // home: const AppHome(),
      ///关闭页面上显示的debug标签
      debugShowCheckedModeBanner: false,
    );
  }
}



