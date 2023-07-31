import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExSharedPreferences extends StatefulWidget {
  const ExSharedPreferences({Key? key}) : super(key: key);

  @override
  State<ExSharedPreferences> createState() => _ExSharedPreferencesState();
}

class _ExSharedPreferencesState extends State<ExSharedPreferences> {
  StorageCache storageCache = StorageCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of SharedPreference Package'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OutlinedButton(
            child: Text("Write Data"),
            onPressed: () {
              print("button clicked");
              storageCache.sharedPrefWriteData();
            },
          ),
          OutlinedButton(
            child: Text("Read Data"),
            onPressed: () {
              print("button clicked");
              storageCache.sharedPrefReadData();
            },
          ),
          OutlinedButton(
            child: Text("Remove data "),
            onPressed: () {
              print("button clicked");
              storageCache.sharedPrefRemoveKey();
            },
          ),
        ],
      ),
    );
  }
}

///把sharedPreference封装成一个类，相关操作封装成方法
class StorageCache {
  final String key_age = 'age';
  final String key_name = 'name';
  SharedPreferences? sharedPreferences;

  ///获取SharedPreferences实例需要使用异步操作
  void init() async {
    sharedPreferences = await SharedPreferences.getInstance().whenComplete(() => print('get sharedPreference success') );
  }

  StorageCache() {
    init();
  }

  ///写数据操作需要封装成异步方法
  void sharedPrefWriteData () async{
    int age = 3;
    String name = "Talk8";
    await sharedPreferences?.setInt(key_age, age).whenComplete(() => print('write success'));
    await sharedPreferences?.setString(key_name, name).whenComplete(() => print('write success'));
  }

  void sharedPrefReadData() {
    int? age = sharedPreferences?.getInt(key_age);
    String? name = sharedPreferences?.getString(key_name);
    debugPrint("age: $age, name: $name");
  }

  ///删除数据操作需要封装成异步方法
  void sharedPrefRemoveKey() async {
    await sharedPreferences?.remove(key_age).whenComplete(() => print('remove success'));
    await sharedPreferences?.remove(key_name).whenComplete(() => print('remove success'));
  }
}
