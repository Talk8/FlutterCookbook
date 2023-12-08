import 'package:flutter/material.dart';

class ExScrollView extends StatefulWidget {
  const ExScrollView({super.key});

  @override
  State<ExScrollView> createState() => _ExScrollViewState();
}

class _ExScrollViewState extends State<ExScrollView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double padding = 16;
    ///按照比例控制组件在垂直方向上的位置
    double row1Height = screenHeight/8;
    double row2Height = screenHeight*2/8;
    ///按照固定尺寸控制组件在垂直方向上的位置
    ///这里的96可以自定义，80是statusBar和appBap的高度，是个经验值，可以准确获取
    double row3Height = screenHeight-96-80;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of  ScrollView"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Stack(
          children: [
            ///第一行内容
            Positioned(
              top: row1Height,
              width: screenWidth - padding*2,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text("row 1",style: TextStyle(color: Colors.white,),
                  ),
                ),
              ),
            ),

            ///第二行内容： 这是一个滚动组件，滚动的区域通过Positioned指定
            Positioned(
              top: row2Height,
              width: screenWidth - padding*2,
              height: row3Height - row2Height,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child:ListView(
                    ///最好去掉List中的间距，不无法滚动到滚动区域的边缘
                    padding: EdgeInsets.zero,
                    itemExtent:32,
                    children: List.generate(18, (index) {
                      ///列表中的内容是一个文本和分隔线
                      return Column(
                        children: [
                          Container(
                            color: Colors.yellow,
                            child: Text("item: $index"),
                          ),
                          const Divider(height: 2,color: Colors.white,),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),

            ///第三行内容
            Positioned(
              top: row3Height+32,
              width: screenWidth-padding*2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text("row 3",style: TextStyle(color: Colors.white,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
