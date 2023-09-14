
///与143的内容相匹配
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class ExAppIntroduce extends StatefulWidget {
  const ExAppIntroduce({super.key});

  @override
  State<ExAppIntroduce> createState() => _ExAppIntroduceState();
}

class _ExAppIntroduceState extends State<ExAppIntroduce> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      ///控制是否动滚动，和滚动时间，默认不滚动,滚动时间单位是毫秒
      infiniteAutoScroll: true,
      autoScrollDuration: 2000,

      ///控制底部显示的TextButton,back和skip默认在左下角，不能同时显示。
      ///next和done在右下角，开始显示next,滚动到最后一页时显示done.
      ///控制按钮中文字的风格和按钮的行为
      showBackButton: false,
      back: const Text('back'),
      showBottomPart: true,
      showDoneButton: true,
      doneStyle: TextButton.styleFrom(backgroundColor: Colors.orange,foregroundColor: Colors.white),
      done:const Text('done'),
      onDone: (){},
      showNextButton: true,
      next: const Text('next'),
      nextStyle: TextButton.styleFrom(backgroundColor: Colors.orange,foregroundColor: Colors.white),
      showSkipButton: true,
      skip: const Text('skip'),
      skipStyle: TextButton.styleFrom(backgroundColor: Colors.orange,foregroundColor: Colors.white),

      ///控制底部指示点的颜色，大小，形状,间隔,注意间隔默认为6，不能太大，否则有错误
      ///默认大小设置成了正方形：Size.square(9),因此换成正方形后圆角不明显
      dotsDecorator:const DotsDecorator(
        // size: Size.square(10),
        // size: const Size(16, 8),
        spacing: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.black45,
        activeColor: Colors.purpleAccent,
        ///未选中是圆形，选中是矩形,大小和形状必须一起调，不然效果不明显，因为默认是正方形
        activeSize: Size(16, 8),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left:Radius.circular(15) ,right: Radius.circular(12)),),
      ),

      ///用来存放显示的页面
      pages: [
        PageViewModel(
          title: 'title of intro page',
          body: 'body of intro page',
          ///图片外层需要嵌套一层位置类容器
          image: const Center(
            ///控制图片的大小和填充
            child:Image(image: AssetImage("images/ex.png"),height: 500,fit: BoxFit.cover,),
          ),
          decoration: const PageDecoration(
            ///可以让image全屏显示，默认情况下image,title,body按照flex值1：1：1均匀分布
            ///调整flex值可以控制body和title的位置
            fullScreen: true,
            titleTextStyle: TextStyle(color: Colors.deepPurpleAccent,),
            bodyAlignment: Alignment.bottomLeft,
            bodyFlex: 1,
            imageFlex: 5,
            ///image以外区域的颜色
            pageColor: Colors.blue,
          )
        ),
        PageViewModel(
          title: 'title of intro page',
          body: 'body of intro page',
          image: const Center(
            child: Icon(Icons.ac_unit),
          ),
        ),
        PageViewModel(
          title: 'title of intro page',
          body: 'body of intro page',
          image: const Center(
            child: Icon(Icons.pages),
          ),
        ),
      ],
    );
  }
}
