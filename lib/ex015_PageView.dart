import 'package:flutter/material.dart';

//和25回中的内容相匹配
class ExPageView extends StatefulWidget {
  const ExPageView({Key? key}) : super(key: key);

  @override
  State<ExPageView> createState() => _ExPageViewState();
}

class _ExPageViewState extends State<ExPageView> {
  //用来获取当前被选中Page的索引值,可以设置默认初始页，不过不能和指示器联动
  PageController mPageController = PageController(initialPage: 1);
  //用来存放当前被选中page的索引值
  var pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of PaveView"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: double.infinity,
            height: 500,
            child: PageView(
              controller: mPageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (value) {
                print("onPage Changed: ${value}");
                setState(() {
                  pageIndex = value;
                });
              },
              children: [
                Container(
                  alignment: Alignment.center,
                  //长度和调试没有效果，会填充满整个屏幕
                  width: 100,
                  height: 300,
                  color: Colors.lightBlue,
                  child: const Text("Page 1"),
                ),
                Container(
                  alignment: Alignment.center,
                  color: Colors.greenAccent,
                  child: const Text("Page 2"),
                ),
                Container(
                  alignment: Alignment.center,
                  color: Colors.brown,
                  child: const Text("Page 3"),
                ),
              ],
            ),
          ),
          Indicator(
            pageController: mPageController,
            count: 3,
            currentIndex: pageIndex,
          )
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  Indicator({
    Key? key,
    required this.pageController,
    required this.count,
    this.currentIndex = 0,
    this.radius = 30,
    this.space = 18,
  }) : super(key: key);

  PageController pageController;
  //被选中page的索引值
  int currentIndex;
  //指示器形状为小圆点，这是它的数量
  int count;
  //小圆点的半径
  double radius = 1;
  //小圆点之间的距离
  double space = 1;

  Widget _Indicator(int index, int pageCount, double r, double s) {
    //通过pageController中的索引值来判断当前页面是否被选中
    bool isIndexPageSelected = (index ==
        (pageController.page != null ? pageController.page?.round() : 0));

    //通过参数传递的索引值来判断当前页面是否被选中
    // bool isIndexPageSelected = (index == currentIndex) ? true : false;
    //打印索引值，调试使用
    // print("page count ${pageController.page?.round()}");
    // print("current : ${currentIndex}");

    return Container(
      //宽度是圆的半径，宽度是半径+左右两边的间隔(space)
      height: r,
      width: r + 2 * s,
      child: Material(
        color: isIndexPageSelected ? Colors.greenAccent : Colors.grey,
        type: MaterialType.circle,
        child: Container(
          width: r,
          height: r,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // children: [
      //   _Indicator(0, 3, 20, 18),
      //   _Indicator(1, 3, 20, 18),
      //   _Indicator(2, 3, 20, 18),
      // ],
      //使用List来代替上面的代码
      children: List<Widget>.generate(count, (index) {
        return _Indicator(index, count, radius, space);
      }),
    );
  }
}