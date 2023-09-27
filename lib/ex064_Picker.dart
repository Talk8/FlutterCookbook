
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:numberpicker/numberpicker.dart';

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
          Text('data'),
          Text('data'),
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
        ],
      ),
    );
  }

}
