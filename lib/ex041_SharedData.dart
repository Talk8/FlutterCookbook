import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EXSharedData extends StatefulWidget {
  const EXSharedData({Key? key}) : super(key: key);

  @override
  State<EXSharedData> createState() => _EXSharedDataState();
}

class _EXSharedDataState extends State<EXSharedData> {
  String _tempData = "default value";
  String _allShatedData = 'no value';
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
            child: Consumer<ViewModel>(
              builder: (context,viewModel,child){
                return ElevatedButton(
                    onPressed:() {viewModel.setData = "change data";
                      print('change value button clicked');},
                    child: const Text('change data by Consumer'));
              },
            ),
          ),
        ],
      ),
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
      builder: (context,data,child){
        print('builder of Consumer of Widget B running');
        if(child != null){
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
    return Text("Widget A data:${Provider.of<ViewModel>(context,listen: true)._data}");
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