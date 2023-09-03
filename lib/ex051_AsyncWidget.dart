import 'package:flutter/material.dart';

///与134，135章回的内容相匹配
class ExCustomerAsyncWidget extends StatefulWidget {
  const ExCustomerAsyncWidget({Key? key}) : super(key: key);

  @override
  State<ExCustomerAsyncWidget> createState() => _ExCustomerAsyncWidgetState();
}

class _ExCustomerAsyncWidgetState extends State<ExCustomerAsyncWidget> {
  ///创建一个Future:3s后返回一个数据,通过自定义的异步组件监听它，效果：3s内显示进度，完成后显示数据
  Future tempFuture = Future.delayed(const Duration(seconds: 3),() => 'finished');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of CustomerAsyncWidget'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
          child: CustomerAsyncWidget(tempFuture),
        ///下拉刷新组件，类似自定义缓冲组件，在列表中下拉内容时显示刷新图标
        //   child: RefreshIndicator(
        //     ///刷新的功能在这里实现
        //     onRefresh: () => tempFuture,
        //     child: ListView(
        //       children: [
        //         ...List.generate(15, (index) => ListTile(
        //           leading:TextButton.icon(
        //             onPressed: (){},
        //             icon: const Icon(Icons.numbers),
        //             label: Text('${index+1}'),),
        //           title: Text('This is ${index+1} item'),
        //         ),
        //         ),
        //       ],
        //     ),
        //   ),
      ),
    );
  }
}


///通过FutureBuilder组件来来监听Future的状态。Future完成则显示其中的数据 ，否则显示圆形进度条
///使用这种思路来自定义异步操作的组件，效果比较好，对于Steam也可以做类似的定制操作。
class CustomerAsyncWidget extends StatelessWidget {
  final Future _future;

  const CustomerAsyncWidget(this._future, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: _future,
        builder: (context, data) {
          if (data.connectionState == ConnectionState.done) {
            return Text('data is : ${data.data}');
          } else {
            ///判断返回结果是否有错误
            if(data.hasError) {
              return const Icon(Icons.error);
            }else {
              ///backgroundColor是不有完成进度的颜色，color是完成的进度颜色
              return const CircularProgressIndicator(color: Colors.green,backgroundColor: Colors.yellow);
            }
          }
        },);
  }
}
