import 'package:flutter/material.dart';

///和23,24回中的内容相匹配
class ExPointerEvent extends StatefulWidget {
  const ExPointerEvent({Key? key}) : super(key: key);

  @override
  State<ExPointerEvent> createState() => _ExPointerEventState();
}

class _ExPointerEventState extends State<ExPointerEvent> {
  ///event中的position是事件的全局坐标，相对于屏幕整个屏幕，localPosition是局部事件，相对于事件所在的容器
  void _eventCancle(PointerCancelEvent event) => print("Event cancel");
  void _eventDown(PointerDownEvent event) => print("Event Down: position:${event.position},location:${event.localPosition}");
  void _eventUp(PointerEvent event) => print("Event Up: position:${event.position},location:${event.localPosition}");
  void _eventMove(PointerEvent event) => print(
      "Event Move: position:${event.position},location:${event.localPosition} \n transform: ${event.transform},delta: ${event.delta}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of PointerEvent"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.blue,
            alignment: Alignment.center,
            width: 200,
            height: 200,
            child: Listener(
                onPointerDown: _eventDown,
                onPointerMove: _eventMove,
                onPointerUp: _eventUp,
                child: const Text(
                  "Event Listener inside",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    backgroundColor: Colors.white,
                  ),
                )),
          ),
          Listener(
            //Listener可以当作容器Widget包含其它Widget使用，也可以当作独立widget使用
            onPointerCancel: _eventCancle,
            onPointerDown: _eventDown,
            onPointerUp: _eventUp,
            onPointerMove: _eventMove,
            child: Container(
              color: Colors.orange,
              alignment: Alignment.center,
              constraints: const BoxConstraints(
                minWidth: 200,
                minHeight: 100,
              ),
              child: const Text(
                "Event Listener Outside",
                style: TextStyle(
                  color: Colors.black87,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Container(
              color: Colors.lime,
              alignment: Alignment.center,
              width: 300,
              height: 100,
              child: Listener(
                onPointerDown: _eventDown,
                child: const Text(
                  "Ignore Event Listener",
                  style: TextStyle(
                    color: Colors.black87,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
