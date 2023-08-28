import 'package:flutter/material.dart';

class ExModalBarrier extends StatefulWidget {
  const ExModalBarrier({Key? key}) : super(key: key);

  @override
  State<ExModalBarrier> createState() => _ExModalBarrierState();
}

class _ExModalBarrierState extends State<ExModalBarrier> {
  final List<String> _list = List.generate(5, (index) => "This is item: ${index + 1}");
  var _showModal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of ModalBarrier'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Stack(alignment: Alignment.center, children: [
        ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return SizedBox(height: 60, child: Text(_list[index]));
            }),
        SizedBox(
          width: 400,
          height: 300,
          child: ModalBarrier(
            ///参数onDismiss源代码写的关闭modal窗口
            // onDismiss: () => Navigator.maybePop(context),

            ///自己写的关闭modal窗口,这两种关闭窗口的方法都会退出当前页面
            onDismiss: () => Navigator.of(context).pop(),
            color: Colors.blue,
          ),
        ),
        ///通过变量控制Modal窗口的显示与隐藏，这样只会关闭Modal窗口，而不会退出当前页面
        _showModal
            ? SizedBox(
                width: 300,
                height: 400,
                child: ModalBarrier(
                  ///点击窗口外的区域无反应，点击窗口内的区域只关闭当前窗口
                  onDismiss: () {
                    setState(() {
                      _showModal = !_showModal;
                    });
                  },
                  color: Colors.green,
                ),
              )
            : const SizedBox.shrink(),
        ///通过组件控制Modal窗口的显示与隐藏，这样只会关闭Modal窗口，而不会退出当前页面
        Visibility(
          visible: _showModal,
          child: SizedBox(
            height: 200,
            width: 300,
            child: ModalBarrier(
              color: Colors.yellow,
              onDismiss: () {
                setState(() {
                  _showModal = !_showModal;
                });
              },
            ),
          ),
        ),
      ]),
    );
  }
}
