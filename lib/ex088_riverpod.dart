import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExRiverPod extends ConsumerWidget {
  const ExRiverPod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///1. 这个用法是riverPod的基本用法
    final String strValue = ref.watch(helloRiverpodProvider);

    ///2. 这个用法是Provider代码迁移到riverPod的用法
    final DataViewModel dataViewModel = ref.watch(dataVMRiverPodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of Riverpod"),
        backgroundColor: Colors.purpleAccent,
      ),
      ///这里显示的值是helloRiverpodProvider中返回的字符串，即 "HelloRiverpod"
      body: Column(
        children: [
          ///1. 这个用法是riverPod的基本用法
          Text(strValue),
          /// 2.这个用法是Provider代码迁移到riverPod的用法
          Text("Default data<${dataViewModel.intData},${dataViewModel.strData},"
              "${dataViewModel.boolData},${dataViewModel.strListData.toString()}>"),
          ///点击按钮后会更新上面Text组件中的数据
          ElevatedButton(
            onPressed: (){
              dataViewModel.setIntValue(6);
              dataViewModel.setBoolValue(false);
              dataViewModel.setStringValue("new data");
            },
            child: const Text("change data"),
          ),
        ],
      ),

    );
  }
}

///1. 创建时使用了Flutter Riverpod Snippets插件，输入provider就会自动生成代码版本，类型stf生成代码版本一样
final helloRiverpodProvider = Provider<String>((ref) {
  return "HelloRiverPod";
});

///2. 把代码从Provider迁移到 riverPod，下面是Provider中的数据模型(ViewMode)
class DataViewModel extends ChangeNotifier{
  ///这个数据可以理解为状态
  late int intData;
  late String strData;
  late bool boolData;
  late List<String> strListData;

  ///初始化方法
  DataViewModel() {
    _init();
  }

  Future<void> _init()  async {
    intData = 1;
    strData = "Default string";
    boolData = true;
    strListData = ["a","b","c","d","e","f"];
    notifyListeners();
  }

  ///修改数据的方法，相当于修改状态
  Future<void> setIntValue(int v) async {
    intData = v;
    notifyListeners();
  }

  Future<void> setStringValue(String v) async {
    strData = v;
    notifyListeners();
  }

  Future<void> setBoolValue(bool v) async {
    boolData = v;
    notifyListeners();
  }

  Future<void> setListValue(List<String> list) async {
    strListData = list;
    notifyListeners();
  }
}

///2. 使用ChangeNotifierProvider监听数据（或者叫状态变化）
final dataVMRiverPodProvider = ChangeNotifierProvider((ref) {
  return DataViewModel();
});

