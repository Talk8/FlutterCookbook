import 'package:flutter/material.dart';

class ExDataTable extends StatefulWidget {
  const ExDataTable({Key? key}) : super(key: key);

  @override
  State<ExDataTable> createState() => _ExDataTableState();
}

class _ExDataTableState extends State<ExDataTable> {
  int _sortIndex = 0;
  bool _isSortAscending = true;

  List<Student> dataList = [
    Student(name: "Jame", age: 6.toString(), classLevel: "class 1",),
    Student(name: "Tony", age: 7.toString(), classLevel: "class 2",),
    Student(name: "Andy", age: 8.toString(), classLevel: "class 3",),
    Student(name: "Rose", age: 6.toString(), classLevel: "class 1",),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example of DataTable'),
      ),
      //在ListView中使用数据表格
      body:ListView(
        children:[
       DataTable(
         //按照索引值对应的列来排序，index表示列的索引，从0开始
         //该属性赋值后会在列名右侧显示一个箭头图标
         sortColumnIndex: _sortIndex,
         //true表示升序排列，false表示降序排列
         sortAscending: _isSortAscending,
         //全选操作时回调此方法，会对所有行进行统一的选择或者未选择
         onSelectAll: (value) {
          print("selectAll = $value");

          setState(() {
            for(Student item in dataList) {
              item.isSelected = value!;
            }
          });
        },
        //每列的宽度,默认值是56
        columnSpacing: 64,
        //表格标题，就是每一列的Title
        columns:[
          //第一列启用排序功能
          DataColumn( label: Text("Name"),
            //点击排序图标时调用
            //在该方法中实现排序功能，一方面是动态调整排序方式，另外一方面是实现核心排序功能
            onSort: (int index,bool ascend){
            setState(() {
              _sortIndex = index;
              //可以动态调整排序的方式（升序还是降序）
              _isSortAscending = ascend;

              //实现真正的排序功能，这里使用了list的sort方法,排序思路：如果当前列没有按照
              //指定的顺序排列，那么交换一下两个参数的位置，然后使用字符串的排序方法对这两个
              //参数进行比较，并且返回比较后的结果，实际项目中可以使用自定义排序的算法替换
              //字符串的排序方法:compareTo
              dataList.sort((v1,v2){
                var temp;
                if(!_isSortAscending) {
                  temp = v1;
                  v1 = v2;
                  v2 = temp;
                }
                return v1.name.compareTo(v2.name);
              });
            });
            },),
          DataColumn( label: Text("Age"),),
          DataColumn( label: Text("Class"),
            onSort: (index,ascend){
            //这里的排序方法只调整了排序的方式，没有实现核心排序功能
            setState(() {
              _sortIndex = index;
              //可以动态调整排序的方式
              _isSortAscending = ascend;
            });
            },
           ),
        ],
         /* 可以一行一行的进行赋值，也可以使用List自动赋值
        rows: [
          //第一行数据
          DataRow(cells: [
            DataCell(Text("Jam")),
            DataCell(Text("3")),
            DataCell(Text("Sleep")),
          ],),
          //第二行数据
          DataRow(cells: [
            DataCell(Text("Jam")),
            DataCell(Text("3")),
            DataCell(Text("Sleep")),
          ],),
          //第三行数据
          DataRow(cells: [
            DataCell(Text("Jam")),
            DataCell(Text("3")),
            DataCell(Text("Sleep")),
          ],),
        ],
           */
         //把List转换成DataRow类型的数组,主要是用了map方法
         rows: dataList.map((e) => DataRow(
           selected: e.isSelected,
           // selected: e.isSelected,
           //该属性赋值后会在第一列左侧显示一个方框（复选框),点击复选框时回调该方法
           onSelectChanged: (value){
             //如果当前行没有被选择，就将其修改为选择，因为点击时才回调此方法
             if(e.isSelected != value) {
               setState(() {
                 e.isSelected = value!;
               });
             }
           },
           // onSelectChanged: ,
           cells: [
           DataCell(Text(e.name)),
           DataCell(Text(e.age)),
           DataCell(Text(e.classLevel)),
         ],
         ),).toList(),
      ),
        ],
      ),
    );
  }
}

class Student {
  final String name;
  final String age;
  final String classLevel;
  bool isSelected;

  //使用IDE自动生成的类构造方法，带有语法糖，因为其中包含了赋值操作
  // Student(this.name, this.age, this.classLevel);
  //手写的带有命名参数的构造方法，不过必须添加required关键字，不然会报错
  //注意： 这两种构造就去只能二选一，没有同时定义，因为他们的功能相同
 Student({
   required this.name,
   required this.age,
   required this.classLevel,
   this.isSelected = false,
 });

}