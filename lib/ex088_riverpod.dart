import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
///part这语法是什么意思？
part 'ex088_riverpod.g.dart';

class ExRiverPod extends ConsumerWidget {
  const ExRiverPod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///1. 这个用法是riverPod的基本用法
    final String strValue = ref.watch(helloRiverpodProvider);

    ///2. 这个用法是Provider代码迁移到riverPod的用法
    final DataViewModel dataViewModel = ref.watch(dataVMRiverPodProvider);

    final String strOfDVM = ref.watch(pjtDataVMProvider).name;

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
          // Text(strRiver),
          ///点击按钮后会更新上面Text组件中的数据
          ElevatedButton(
            onPressed: (){

              ///这个写法虽然能修改数据，但是不推荐这么做,推荐下面的写法。
              // dataViewModel.setIntValue(6);
              // dataViewModel.setBoolValue(false);
              // dataViewModel.setStringValue("new data");
              ref.read(dataVMRiverPodProvider).setIntValue(9);
              ref.read(dataVMRiverPodProvider).setBoolValue(false);
              ref.read(dataVMRiverPodProvider).setStringValue("str data");
            },
            child: const Text("change data"),
          ),

          ///在AlertDial的column中直接显示checkBox也是有外边距，与dialog无关
          ElevatedButton(onPressed: () {
            showDialog(context: context, builder:
            (context){
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(value: true, onChanged: (checkValue){
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            color: Colors.lightBlue,
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.sizeOf(context).width/2,
                            child: Transform.translate(
                              offset: const Offset(-16,0),
                              child: Checkbox(
                                  value: false,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  splashRadius: 0,
                                  shape: RoundedRectangleBorder(side:const BorderSide(width: 8,color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(16),),
                                  onChanged: (checkValue){ }),
                            ),
                        ),
                        const Text("dataaa"),
                      ],
                    ),
                    const Text("dataaa dd"),
                  ],
                ),
              );
            });
          }, child: const Text("Show dialog"),),

          ///在column中直接显示checkBox也是有外边距，与dialog无关，解决方法是使用偏移组件，手动移动组件位置
          Row(
            children: [
              Container(
                color: Colors.lightBlue,
                alignment: Alignment.topRight,
                child: Transform.translate(
                  ///向左移动16dp是合理的数据
                  offset: const Offset(0,0),
                  child: Checkbox(
                      value: false,
                      ///这两个属性可以去掉一部分边距
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // materialTapTargetSize: MaterialTapTargetSize.padded,
                      onChanged: (checkValue){ }),
                ),
                // child: CupertinoCheckbox(value: false, onChanged: (va){}),
              ),
              const Text("dataaa"),
            ],
          ),
          ///这个组件的checkBox在最右侧
          CheckboxListTile(value: false, onChanged: (bool? value) {  },
            title: const Text("hello"),
          ),
          ///IOS风格的checkBox也有间隔
          CupertinoCheckbox(value: false, onChanged: (va){}),

          Text("ProjectDataViewModel: $strOfDVM"),
          Text("ProjectDataViewModel: ${ref.watch(pjtDataVMProvider).name}"),
          ElevatedButton(
              onPressed: () {
                // ref.read(pjtDataVMProvider).name = "name is changed";
                ref.read(pjtDataVMProvider).changeName("change ");
          },
              child: Text("Change the data"),
          ),
        ],
      ),

    );
  }
}

///1. 创建时使用了Flutter Riverpod Snippets插件，输入provider就会自动生成代码版本，类似stf生成代码版本一样
///这种Provider只能监听数据 ，不能修改数据
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

///这个是snip自动生成的代码，但是有编译错误,需要执行命令来手动生成代码，借助了flutter_gern
// @riverpod
// class RiverPodDataViewModel extends _$RiverPodDataViewModel {
//   @override
//   FutureOr<RiverPodData> build() async {
//     return RiverPodData();
//   }
// }

///我在上面的三种用法都是从Provider角度迁移的用法


class ImageResposity {
  int getImageCount() {
    return 3;
  }
}

@riverpod
ImageResposity imageRespty(ImageResptyRef ref) {
  return ImageResposity();
}

@riverpod
class Example extends _$Example {
  @override
  String build() {
    return "example";
  }
}

///无法修改数据
class ProjectDataViewMode {
  int size = 0;
  String name = "Default";

  void changeName(String v) {
    name = v;
  }
}

@riverpod
ProjectDataViewMode pjtDataVM(PjtDataVMRef ref) {
  return ProjectDataViewMode();
}

///每次都运行命令，flutter pub run build_runner watch -d
///否则不会自动生成代码

@riverpod
class TDataVM extends _$TDataVM {
  @override
  TDataVM build() {
    return TDataVM();
  }
}