import 'package:flutter/material.dart';
import 'package:fluttercookbook/ex029_DataTable.dart';

//对应PaginatedDataTable相关的内容，缺点是无法修改页脚索引的显示风格
class ExPaginatedDataTable extends StatefulWidget {
  const ExPaginatedDataTable({Key? key}) : super(key: key);

  @override
  State<ExPaginatedDataTable> createState() => _ExPaginatedDataTableState();
}

class _ExPaginatedDataTableState extends State<ExPaginatedDataTable> {
  int _sortIndex = 2;
  bool _isSortAscending = true;

  CustomDataSource customDataSource = CustomDataSource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example of PaginatedDataTable'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: ListView(
        children: [
          PaginatedDataTable(
            //表格标题，在最上方显示
            header: Text("PaginatedDataTable"),
            sortColumnIndex: _sortIndex,
            sortAscending: _isSortAscending,
            //修改分页时上下页切换的按钮颜色，不过无法修改按钮的形状，默认是左右方向的箭头
            arrowHeadColor: Colors.purpleAccent,
            //每页显示的数据行数,默认值为10
            rowsPerPage: 2,
            //换页时回调此方法,参数为页的索引值，从0开始
            onPageChanged: (value) {
              debugPrint('page: $value');
            },
            //表格的列名
            columns: [
              DataColumn(
                label: Text("Name"),
              ), //点击排序图标时调用
              // 在该方法中实现排序功能，一方面是动态调整排序方式，另外一方面是实现核心排序功能
              DataColumn(
                label: Text("Age"),
              ),
              //第三列启用排序功能
              DataColumn(
                label: Text("Class"),
                onSort: (index, ascend) {
                  //这里的排序方法只调整了排序的方式，没有实现核心排序功能
                  setState(() {
                    _sortIndex = index;
                    //可以动态调整排序的方式,不过没有实现排序功能
                    _isSortAscending = ascend;
                  });
                },
              ),
            ],
            //存放表格中的数据
            source: customDataSource,
          ),
        ],
      ),
    );
  }
}

//自定义的数据类型，需要继承抽象类，并且实现其中的方法
class CustomDataSource extends DataTableSource {
  int _selectedRowCount = 1;
  List<Student> dataList = [
    Student(
      name: "Jame",
      age: 6.toString(),
      classLevel: "class 1",
    ),
    Student(
      name: "Tony",
      age: 7.toString(),
      classLevel: "class 2",
    ),
    Student(
      name: "Andy",
      age: 8.toString(),
      classLevel: "class 3",
    ),
    Student(
      name: "Rose",
      age: 6.toString(),
      classLevel: "class 1",
    ),
  ];

  //返回每一行中的数据
  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(dataList[index].name)),
      DataCell(Text(dataList[index].age)),
      DataCell(Text(dataList[index].classLevel)),
    ]);
  }

  //选中的行数
  @override
  int get selectedRowCount {
    return _selectedRowCount;
  }

  //通常返回false，如果返回true，rowCount返回值无效，
  @override
  bool get isRowCountApproximate {
    return false;
  }

  //返回行的数量
  @override
  int get rowCount {
    return dataList.length;
  }
}
