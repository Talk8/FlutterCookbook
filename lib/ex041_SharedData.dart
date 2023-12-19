import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///与101-105章回的内容匹配，主要介绍如何在组件之间共享数据，或者叫状态管理
///点击修改共享数据的button,监听共享数据的组件会收到数据变化的通知，然后更新组件中的数据
class EXSharedData extends StatefulWidget {
  const EXSharedData({Key? key}) : super(key: key);

  @override
  State<EXSharedData> createState() => _EXSharedDataState();
}

class _EXSharedDataState extends State<EXSharedData> {
  String _tempData = "default value";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of shared data of widget'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 100,
            alignment: Alignment.center,
            color: Colors.blue,
            child: FatherWidget(
              ///父组件和子组件形成组件树,不过在main中使用Provider后这种共享机制就失效了
              ///如果想看，需要在main中去掉provider,以及同列中的其它widget
              data: _tempData,
              child: const SonWidget(),
            ),
          ),

          ///使用Provider获取共享数据，并且更新组件
          Container(
            width: 300,
            height: 100,
            alignment: Alignment.center,
            color: Colors.green,
            child: WidgetA(),
          ),

          ///使用Consumer获取共享数据,并且更新组件
          Container(
            width: 300,
            height: 100,
            alignment: Alignment.center,
            color: Colors.green,
            child: WidgetB(),
          ),

          ///使用Selector获取共享数据,是否更新组件可以通过shouldRebuild属性进行配置
          ///Selector还有数据转换功能
          Container(
            width: 300,
            height: 100,
            alignment: Alignment.center,
            color: Colors.green,
            child: WidgetC(),
          ),
          SizedBox(
            width: 200,
            height: 100,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  ///更新父组件中的数据，子组件中数据会自动更新
                  _tempData = "new data";
                });
              },
              child: const Text('Change data by InheritedWidget'),
            ),
          ),
          SizedBox(
            width: 200,
            height: 100,
            child: ElevatedButton(
              onPressed: () {
                // ViewModel()._data = 'notifier new data';
                Provider.of<ViewModel>(context,listen: false).setData = 'another value';
              },
              child: const Text('Change data by Provider'),
            ),
          ),
          SizedBox(
            width: 200,
            height: 100,
            ///注意：修改viewModel中的数据和获取viewModel中的数据时使用相同的viewModel.
            ///consumer可以保证这一点，也可以把viewModel定义成单例对象
            child: Consumer<ViewModel>(
              builder: (context, viewModel, child) {
                return ElevatedButton(
                    onPressed: () {
                      viewModel.setData = "change data";
                      print('change value button clicked');
                    },
                    child: const Text('change data by Consumer'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetC extends StatelessWidget {
  const WidgetC({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Selector<ViewModel, ViewModelAfterTranslate>(
      ///把新类型中数据通过child显示出来
      builder: (context, viewModelAnother,child) {
        print('builder of Selector of Widget C running');
        return Text('Widget C data: ${viewModelAnother.getIntData}');
      },
      ///在selector中进行数据类型转换，通过参数传入原类型，在方法中转换后返回新类型
      selector: (context, viewModel) {
        ViewModelAfterTranslate obj = ViewModelAfterTranslate();
        ///依据共享数据的值来转换数据,转换后的数据通过builder属性显示出来
        /// 字符串是通过button修改产生的，这里写成固定的值，实际项目中不能这样写
        if(viewModel.getData == 'change data') {
          obj.setIntData = 1;
        }else if(viewModel.getData == 'another value'){
          obj.setIntData = 2;
        }else {
          obj.setIntData = 0;
        }
        return obj;
      },
      ///可以配置是否需要更新数据，默认值为false,它是可选属性
      ///注意方法中的参数类型是新数据类型，也就是转换后的数据类型
      // shouldRebuild:(previous,next) => true,
      shouldRebuild:(previous,next) {
        print(' prev: ${previous.getIntData}, next: ${next.getIntData}');
        if (previous.getIntData == next.getIntData) {
          return false;
        } else {
          return true;
        }
      },
      ///没有使用该属性
      child: Text('child'),
    );
  }
}

class WidgetB extends StatelessWidget {
  const WidgetB({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ///使用consumer共享数据时consumer外层的build不调用，只调用consumer中builder属性对应的方法
    print('builder of Widget B running');
    return Consumer<ViewModel>(
      builder: (context, data, child) {
        print('builder of Consumer of Widget B running');
        if (child != null) {
          ///在这里添加需要更新的widget
          print(' child is not null');
        }
        print('data is: ${data.getData}');
        return Text("Widget B data: ${data._data}");
      },

      ///在这里添加不需要更新的widget，这个child和builder方法中的child一样
      child: Text('childe of consumer'),
    );
  }
}

class WidgetA extends StatelessWidget {
  const WidgetA({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print('builder of Widget A running');
    ///监听器设置为false时不会更新共享数据，更不会更新整个组件，当前build方法不会被回调
    return Text("Widget A data:${Provider.of<ViewModel>(context, listen: true)._data}");
    // return Text("Widget A data:${Provider.of<ViewModel>(context,listen: false)._data}");
  }
}

///定义父组件，父组件包含一个共享数据data
class FatherWidget extends InheritedWidget {
  String data;

  FatherWidget(
      {Key? key, this.data = "default data of Father", required Widget child})
      : super(key: key, child: child);

  ///定义获取父组件的方法，方便子组件获取父组件中的数据
  static FatherWidget? of(BuildContext context) {
    ///下面的方式可以通知子组件更新
    // return context.dependOnInheritedWidgetOfExactType<FatherWidget>();
    ///下面的方式无法通知子组件更新
    return context
        .getElementForInheritedWidgetOfExactType<FatherWidget>()
        ?.widget as FatherWidget;
  }

  ///返回true时通知更新子组件中的data，也就是调用子组件的didChangeDependencies()方法
  @override
  bool updateShouldNotify(FatherWidget oldWidget) {
    return oldWidget.data != data;
  }
}

///在子组件中使用父组件中的共享数据
class SonWidget extends StatefulWidget {
  const SonWidget({Key? key}) : super(key: key);

  @override
  State<SonWidget> createState() => _SonWidgetState();
}

class _SonWidgetState extends State<SonWidget> {
  @override
  Widget build(BuildContext context) {
    String? data = FatherWidget.of(context)?.data;
    return Text(
      "son data: $data",
      style: const TextStyle(color: Colors.white, fontSize: 24),
    );
  }

  @override
  void initState() {
    super.initState();
    debugPrint("SonWidget: initState");
  }

  ///父组件中的数据更新时会回调此方法
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("SonWidget: didChangeDependencies");
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("SonWidget: dispose");
  }

  @override
  void activate() {
    super.activate();
    debugPrint("SonWidget: activate");
  }

  @override
  Future<void> deactivate() async {
    super.deactivate();
    debugPrint("SonWidget: deactivate");
  }

  @override
  void didUpdateWidget(SonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("SonWidget: didUpdateWidget");
  }
}

///创建数据共享类,需要继承ChangeNotifier类，使用类中的notifyListeners()方法通知：数据有更新
class ViewModel extends ChangeNotifier {
  late int _intData;
  late String _data;

  ViewModel() {
    _intData = 0;
    _data = 'init data';
  }

  int get intData => _intData;

  set intData(int value) {
    _intData = value;
  }

  ///使用IDE自动生成的getter和setter方法是同名的，这样居然没有编译错误
  // String get data => _data;
  String get getData {
    print('data is gotten at getter');
    return _data;
  }

  set setData(String value) {
    print('data is changed to \'$value\'at setter');
    _data = value;
    ///当数据更新时通知更新UI
    notifyListeners();
  }
}

///创建数据类型转换类,它表示转换后的类型，它的类型是任意的，不需要继承ChangeNotifier类
///示例中通过不同的数值把string类型的数据转换成了int类型的数据
class ViewModelAfterTranslate {
  late int _intData;

  ViewModel() {
    _intData = 0;
  }

  int get getIntData => _intData;

  set setIntData(int value) {
    _intData = value;
  }
}