import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

///与191，192的内容相匹配
class ExCusTimePicker extends StatefulWidget {
  const ExCusTimePicker({super.key});

  @override
  State<ExCusTimePicker> createState() => _ExCusTimePickerState();
}

class _ExCusTimePickerState extends State<ExCusTimePicker> {
  ///这是初始化值，如果用户不选择就用此值l
  int hour = 8;
  int minute = 30;
  String selectedTime = "8:30";
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of CusTimePicker"),
      ),
      body:Listener(
        onPointerDown: (event) {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context){

                return Container(
                  width: screenWidth,
                  height: screenHeight*2/3,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(30),right: Radius.circular(30),),
                  ),
                  ///弹出容器整体用stack布局，主要是有一个窗口用来显示被选择的数字，注意它的位置通过positioned控制
                  ///窗口在最低层，中间是数字选择功能，最上层是一个按钮，点击时修改数字，同时关闭容器
                  child:Stack(
                    children: [
                      ///深色方框用来显示当前被选择的数字
                      Positioned(
                        ///这个值是listHeight的值除2后再做一些偏移
                        top: (screenHeight*2/3 - 128)/2 -26,
                        // top: 300,
                        ///这个16是左右的边距
                        left: 16,
                        width: screenWidth-16*2,
                        height: 56,
                        child:Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[500],
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      ///数字选择：使用两个滑轮实现
                      Positioned(
                        top: 0,
                        ///这个值是屏幕宽度减去两个listWidth和sizeBox的宽度再除2
                        left: (screenWidth-80*2-32)/2,
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: WheelChooser(
                                listWidth: 80,
                                listHeight: screenHeight*2/3 - 128,
                                itemSize: 56,
                                startPosition: hour,
                                selectTextStyle: const TextStyle(color: Colors.white),
                                unSelectTextStyle: const TextStyle(color: Colors.black),
                                onValueChanged: (value){
                                  hour = value;
                                },
                                datas: List<int>.generate(24, (index) => index),
                              ),
                            ),
                            const SizedBox(width: 32,
                              child: Text(" : ",style: TextStyle(fontSize: 24,color: Colors.white),),
                            ),
                            WheelChooser(
                              listWidth: 80,
                              listHeight: screenHeight*2/3 - 128,
                              itemSize: 56,
                              startPosition: minute,
                              selectTextStyle: const TextStyle(color: Colors.white),
                              unSelectTextStyle: const TextStyle(color: Colors.black),
                              onValueChanged: (value){minute = value;},
                              datas: List<int>.generate(60, (index) => index),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left:0,
                        bottom: 32,
                        width:screenWidth,
                        child: Center(
                          ///点击按钮时修改显示时间同时关闭窗口
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[500],foregroundColor: Colors.white,
                              ///需要指定按钮的最小值，不然界面大小不协调
                              minimumSize: const Size(176, 56),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedTime = "${hour.toString()}:${minute.toString()}";
                              });

                              Navigator.of(context).pop();
                            },
                            child: const Text("Done"),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        ///显示时间的组件分三行内容
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            alignment: Alignment.center,
            width: screenWidth - 16*2,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.blue[500],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0,top: 8,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("SelectedTime: ",style: TextStyle(color: Colors.white),),
                  const SizedBox(height: 16,),
                  Text(selectedTime,style: const TextStyle(fontSize: 24,color: Colors.white),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
