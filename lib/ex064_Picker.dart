
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

///与164，165的内容相对应
class ExAllPickers extends StatefulWidget {
  const ExAllPickers({super.key});

  @override
  State<ExAllPickers> createState() => _ExAllPickersState();
}

class _ExAllPickersState extends State<ExAllPickers> {
  int _selectedValue = 0;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Charts'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///这个日期不好用，指定日期了也不行
          // SizedBox(
          //   height: 300,
          //   child: YearPicker(
          //     firstDate:DateTime(2021,01,01) ,
          //     lastDate: DateTime(2025,01,01),
          //     selectedDate:DateTime.now(),
          //     onChanged: (value){},
          //   ),
          // ),
          ///IOS的日期不好用，指定日期了也不行
          // Container(
          //   color: Colors.yellow,
          //   width: 400,
          //   height: 200,
          //   child: CupertinoDatePicker(
          //     minimumYear: 2023,
          //     maximumYear: 2030,
          //     onDateTimeChanged: (DateTime value) {  },
          //   ),
          // ),
          ///打开注释后可以直接使用
          /*
          Container(
            alignment: Alignment.center,
            width: 120,
            height: 240,
            child: CupertinoPicker(
              ///设置整个Picker的颜色
              backgroundColor: Colors.purpleAccent,
              ///默认是一个圆环的效果，这个是圆环的倾斜角度
              offAxisFraction: 0.2,
              ///选择窗口的高度，最好children中组件的高度相同
              itemExtent: 48,
              ///选择某个内容时回调此方法
              onSelectedItemChanged: (int value) {
                debugPrint('item $value is selected');
              },
              ///放大选择项
              useMagnifier: true,
              magnification: 1.3,

              ///最好设置为true,不然会发生选项重叠的现象
              looping: true,
              children: [
                ...List.generate(5, (index) => SizedBox(width:60,height:48,child: Text('item ${index+1}')),),
              ],
            ),
          ),
           */

          ///打开注释后可以直接使用
          /*
          Container(
            color: Colors.blueGrey,
            ///容器的宽度最好是itemWidth*itemCount,不然选择框无法与选择数字对齐
            width: 300,
            ///容器的高度最好是itemHeight*itemCount,不然选择框无法与选择数字对齐
            height: 180,
            child: NumberPicker(
              ///这个是当前选择的值
              value: _selectedValue,
              itemCount: 3,
              itemHeight: 60,
              decoration: BoxDecoration(
                border:Border.all(color: Colors.redAccent,width: 3,),
                borderRadius: BorderRadius.circular(15),
              ),
              ///设置picker方向
              axis: Axis.vertical,
              ///是否启用振动，默认不启用
              // haptics: true,
              ///会把所有范围内的数字都修改成a
              // textMapper: (string){return 'a';},

              ///循环显示
              infiniteLoop: true,
              ///设置值的范围
              maxValue: 9,
              minValue: 0,
              step: 1,
              ///不修改数值的话，选择内容不在选择框架内
              onChanged: (value){
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
          ),
           */

          ///WheelChooser基本用法，使用构造方法
          Container(
            color: Colors.lightGreen,
            width: 200,
            height: 100,
            child: WheelChooser(
              ///控制滑动方向
              horizontal: true,
              ///这个值不知道用来做什么
              // perspective: 0.003,
              ///使用装饰可以在选择的内容上方和下方显示一条横线
              selectTextStyle:TextStyle(
                ///单独使用和复合使用装饰
                // decoration: TextDecoration.overline,
                decoration: TextDecoration.combine([TextDecoration.underline,TextDecoration.overline]),
              ) ,
              ///是否循环显示
              isInfinite: true,
              onValueChanged: (s) => debugPrint('$s selected'),
              datas: const [1,2,3],
            ),
          ),
          ///使用工厂方法，可以创建任意的选择器
          SizedBox(
            height: 150,
            ///可以添加任意的组件，这里添加的是icon
            child: WheelChooser.custom(
              onValueChanged: (value) {},
              isInfinite: true,
              children: const [
                Icon(Icons.looks_3,size: 36,),
                Icon(Icons.looks_two,size: 36,),
                Icon(Icons.looks_one,size: 36,),
              ]),
          ),
          ///使用两种工厂方法实现数字选择器
          SizedBox(
            ///通过控制容器的大小，可以控制显示被选择内容的范围
            height: 100,
            child: WheelChooser.integer(
              ///显示内容的大小，默认48
              itemSize: 50,
              horizontal: true,
              isInfinite: true,
              onValueChanged: (value) => debugPrint('$value'),
              maxValue: 3,
              minValue: 0,
            ),
          ),
          SizedBox(
            height: 100,
            child: WheelChooser.number(
              isInfinite: true,
              onValueChanged: (value) => debugPrint('$value'),
              maxValue: 3,
              minValue: 0,
            ),
          ),
          ///可以选择任意对象当作被选择对象，因为value是泛型
          SizedBox(
            height: 200,
            child: WheelChooser.choices(
             isInfinite: true,
              onChoiceChanged: (value) {},
              choices:[
                WheelChoice(value: 1, title: 'one'),
                WheelChoice(value: 2, title: 'tow'),
                WheelChoice(value: 3, title: 'three'),
              ]
            ),
          ),
        ],
      ),
    );
  }
}
