import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
              ///这个写法虽然能修改数据，但是不推荐这么做,推荐下面的写法。
              // dataViewModel.setIntValue(6);
              // dataViewModel.setBoolValue(false);
              // dataViewModel.setStringValue("new data");
              ref.read(dataVMRiverPodProvider).setIntValue(8);
              ref.read(dataVMRiverPodProvider).setBoolValue(false);
              ref.read(dataVMRiverPodProvider).setStringValue("read data");
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


///3. 完全使用riverpod实现Provider中的功能,代码还有错误
class RiverPodData{
  ///这个数据可以理解为状态
  late int intData;
  late String strData;
  late bool boolData;
  late List<String> strListData;

  ///初始化方法
  RiverPodDataViewModel() {
    _init();
  }

  Future<void> _init()  async {
    intData = 1;
    strData = "Default string";
    boolData = true;
    strListData = ["a","b","c","d","e","f"];
  }

  ///修改数据的方法，相当于修改状态
  Future<void> setIntValue(int v) async {
    intData = v;
  }

  Future<void> setStringValue(String v) async {
    strData = v;
  }

  Future<void> setBoolValue(bool v) async {
    boolData = v;
  }

  Future<void> setListValue(List<String> list) async {
    strListData = list;
  }
}

///这个是snip自动生成的代码，但是有编译错误
@riverpod
class RiverpodDataProvider extends _$RiverpodDataProvider {
  @override
  RiverPodData build() {
    return RiverPodData() ;
  }

}
///这个是为了解决编译错误定义的类
class _$RiverpodDataProvider {
}

// @riverpod
// class RiverPodDataViewModel extends _$RiverPodDataViewModel {
//   @override
//   FutureOr<RiverPodData> build() async {
//     return RiverPodData();
//   }
// }
