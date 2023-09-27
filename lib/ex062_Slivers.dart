import 'package:flutter/material.dart';

class ExSlivers extends StatefulWidget {
  const ExSlivers({super.key});

  @override
  State<ExSlivers> createState() => _ExSliversState();
}

class _ExSliversState extends State<ExSlivers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///sliverAppBar是AppBar的扩展，可以进行伸缩显示,使用sliverAppBar后就不需要使用appBar了
      // appBar: AppBar(
      //   title: const Text('Example of all kinds of slivers'),
      //   backgroundColor: Colors.blue,
      // ) ,
      ///Sliver需要和CustomScrollView配合使用
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Title of SliverAppBar'),
            backgroundColor: Colors.purpleAccent,
            ///关闭和展开时的高度
            collapsedHeight: 60,
            expandedHeight: 300,
            ///下滑屏幕时先显示appBar下面的内容，后显示appBar中的内容，默认值为false表示此情况
            ///设置为true时,下滑屏幕时先显示appBar中的内容，后显示appBar下面的内容;
            floating: true,
            ///向上拖动屏幕，下面的内容向上滚动，appBar逐渐缩小，最后是否显示appBar,默认是56高度的appBar
            ///默认值为false,表示不显示
            pinned: true,

            ///appBar空间扩展后显示的内容
            flexibleSpace: FlexibleSpaceBar(
              ///这个title在appBar的最下方,可以不设定，缩小后它会和SliverAppBar的title重合
              title: const Text('title of FlexibleSpaceBar'),
              background: Container(
                decoration: const BoxDecoration(
                  image:DecorationImage(
                    opacity: 0.8,
                    // colorFilter: ColorFilter.mode(Color.fromARGB(100, 200, 20,30),BlendMode.difference),
                    image: AssetImage("images/ex.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                ///扩展空间中主要显示的内容
                child: const Center(child: Text('child of container')),
              ),
              centerTitle: true,
              ///拉伸和折叠时的样式，效果不是很明显
              collapseMode: CollapseMode.pin,
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
            ),
          ),
          ///SliverAppBar下方显示的内容，这个需要和SliverAppBar一起添加，否则不会出现滑动效果
          ///这个只是一个简单的SliverList,用来配合SliverAppBar使用，真正的介绍在下面的程序中
          SliverList(
            delegate: SliverChildListDelegate(
            // List.generate(40, (index) => Icon(Icons.recommend),),
            List.generate(5, (index) => Text('Item ${index+1}'),),
            ),
          ),
          ///SliverGrid和工厂方法
          SliverGrid.count(
            ///交叉轴显示内容的数量，这里相当于3列
            crossAxisCount: 3,
            ///主轴上显示内容的空间设置,相当于行距
            mainAxisSpacing: 10,
            ///交叉轴上显示内容的空间设置,相当于列距
            crossAxisSpacing: 10,
            childAspectRatio: 1.2,
            ///Grid中显示的内容，一共9个自动换行，分3行显示
            children:List.generate(9, (index) {
              return Container(
                alignment: Alignment.center,
                ///使用固定颜色和随机颜色
                // color: Colors.redAccent,
                // color:Colors.primaries[index%5],
                ///修改为圆角，颜色移动到圆角中
                decoration: BoxDecoration(
                  color: Colors.primaries[index%5],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('item: $index'),
              );
            }).toList(),
          ),
          ///不使用工厂方法，直接使用SliverGrid的构造方法
          SliverGrid(
            ///Grid中显示的内容,可以使用BuilderDelete直接创建显示内容，或者使用已经有的list
            delegate: SliverChildBuilderDelegate((context,index){
              return const Icon(Icons.face_3_outlined); },
            childCount: 20,
            ),
            ///配置Grid的相关属性，
            gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
              ///主轴上显示内容的空间设置,相当于行距
              mainAxisExtent: 20,///这个值不能小于显示内容，否则最后一行的内容会被遮挡
              mainAxisSpacing: 20,
              ///交叉轴显示内容的数量，这里相当于4列
              crossAxisCount: 4,
              ///交叉轴上显示内容的空间设置
              crossAxisSpacing: 20,
              ///显示内容的宽高比
              childAspectRatio: 1.2,
            ),
          ),
          ///不使用工厂方法，直接使用SliverGrid的构造方法,和上一个类似，只是创建显示内容的方法不同
          SliverGrid(
            ///Grid中显示的内容,可以使用BuilderDelete直接创建显示内容，或者使用已经有的list
            delegate: SliverChildListDelegate(
              List.generate(20,
                    (index) => const Icon(Icons.camera,color: Colors.blue,),),
            ),
            ///使用下面的方法也可以
            // SliverChildBuilderDelegate((context,index){
            // return const Icon(Icons.golf_course);
            // },
            //   childCount: 20,),
            ///配置Grid的相关属性，同上。不同之处在于交叉轴显示内容的数量不固定，而是与空间有关
            gridDelegate:const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 40,
              mainAxisExtent: 40,
              mainAxisSpacing: 20,
              crossAxisSpacing: 5,
              childAspectRatio: 1.6,
            ),
          ),
          ///SliverList,类似ListView,可以理解为对ListView的封装，以便用于Sliver中
          ///创建delegate对象，使用builder方法。
          SliverList(
            delegate: SliverChildBuilderDelegate((context,index){
              return Container(
                height: 60,
                alignment: Alignment.center,
                child: Text('This is ${index+1} item'),
              );
            },
              ///list的数量
              childCount:5,
            ),
          ),
          ///与上面的SliverList类似，只是不有创建delegate对象，而是直接使用现成的list对象
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(5, (index) => const Icon(Icons.add),),
            ) ,
          ),
          ///调整显示内容的边距，在上下左右四个方向添加，SliverList，SliverList效果不明显
          ///SliverGrid可以设置内部但是不能设置外部
          // SliverPadding(padding: padding),
          SliverPadding(
           ///在上下左右四个方向上添加边距
           // padding: EdgeInsets.only(left: 10,right: 10),
           padding: const EdgeInsets.all(10),
           sliver:SliverList(
             delegate:SliverChildListDelegate(
               List.generate(5,
                     (index) => Container(
                       color: Colors.grey,
                       child: Text('Item ${index+1}'),
                     ),
               ),
             ) ,
           ) ,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid.count(
              mainAxisSpacing: 10,
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              children: List.generate(9, (index) => Container(
                alignment: Alignment.center,
                color: Colors.primaries[index%5],
                child: Text('Item ${index+1}'),
              ),) ,
            ),
          ),
        ],
      ),
      ///Sliver不能赋值给Column,否则会报以下错误，想使用column就用SliverChildBuilderDelegate封装
      ///A RenderFlex expected a child of type RenderBox but received a child of type RenderSliverList.
      // Column(
      //   children: [
      //     SliverList.list(
      //     children: List.generate(10, (index) => Icon(Icons.add)),),
      //   ],
      // ),
    );
  }
}
