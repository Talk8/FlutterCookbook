import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///自定义评分条，可以定义评分条中图标的形状(icon类型），数量，大小，颜色
///默认为5个灰色的star，评分后灰色变成黄色，评分值是必选参数
///整个自定义widget的难点在于部分评分条的计算与显示，使用了clippr剪裁组件
///目前不有添加事件，评分值通过参数传递，后结再添加事件处理
class CustomRatingBar extends StatefulWidget {
  // const CustomRatingBar({Key? key}) : super(key: key);

  ///当前评分值与最大评分值
  final double rating;
  final double maxRating;
  ///评分中所有star的数量,
  final int countOfStar;
  ///star的尺寸
  final double sizeOfStar;
  ///已评分的图片和颜色，以及没有评分的图片和颜色
  final Color ratingedColor;
  final Icon ratingedWidget;
  final Color unRatingedColor;
  final Icon unRtingedWidget;

  CustomRatingBar ({
    Key? key,
    required this.rating,
    this.maxRating = 10,
    this.countOfStar = 5,
    this.sizeOfStar = 40,
    this.ratingedColor = Colors.yellow,
    this.unRatingedColor = Colors.grey,
    ///评分的图标默认为star，可以通过参数传入
    Icon? paramRatingedWidget,
    Icon? paramUnRatingedWidget
  }):unRtingedWidget = paramUnRatingedWidget ?? Icon(Icons.star_border, color:unRatingedColor, size: sizeOfStar,),
     ratingedWidget = paramRatingedWidget ?? Icon(Icons.star_outlined,color:ratingedColor,size: sizeOfStar,),
     super(key: key);

  @override
  State<CustomRatingBar> createState() => _CustomRatingBarState();
}

class _CustomRatingBarState extends State<CustomRatingBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///在实际使用中可以把app去掉，这样就能直接用于其它widget中
      appBar: AppBar(
        title: Text('Example of CustomRatingBar'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: unRatingStar(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: ratingStar(),
        )
      ]),
    );
  }

  List<Widget> ratingStar() {
    ///用来存放已经评分的star，不过需要计算
    List<Widget> allStars = [];
    ///使用参数中传入的图标，如果没有传入使用默认的star图标
    var star = Icon(widget.ratingedWidget.icon,
        color: widget.ratingedColor,
        size: widget.sizeOfStar,
    );

    /*
    ///创建单个star
    var star = Icon(
      Icons.star_outlined,
      color: widget.ratingedColor,
      size: widget.sizeOfStar,
    );
     */

    ///计算单个star占用的分数
    double ratingPerStar = widget.maxRating / widget.countOfStar;
    ///计算star的数量，分整个star和部分star,整个star的数量=当前评分/单个star的分数，向下取整
    int fullStarCount = (widget.rating/ratingPerStar).floor();
    ///如果整个star的数量超过评分条中图标的最大数量，那么将它设置为最大值
    if(fullStarCount > widget.countOfStar) {
      fullStarCount = widget.countOfStar;
    }

    double percentStarCount = (widget.rating/ratingPerStar)-fullStarCount;
    // print("per: $ratingPerStar, full: $fullStarCount , part: $percentStarCount");

    ///把整数个star放入数组
    for(var i =0; i <fullStarCount;i++) {
      allStars.add(star);
    }

    var percentStar = ClipRect(
      clipper: DIYCliper(percent: percentStarCount),
      child: star,
    );
    allStars.add(percentStar);

    return allStars;
  }

  List<Widget> unRatingStar() {
    return List.generate(widget.countOfStar, (index) {

      ///使用参数中传入的图标，如果没有传入使用默认的star图标
      return Icon(
        widget.unRtingedWidget.icon,
        color: widget.unRatingedColor,
        size: widget.sizeOfStar,
      );

      /*
      return Icon(
        Icons.star_border,
        color: widget.unRatingedColor,
        size: widget.sizeOfStar,
      );
       */
    });
  }
}

class DIYCliper extends CustomClipper<Rect>{
  double percent;

  DIYCliper({required this.percent});

  @override
  Rect getClip(Size size) {
    // TODO: implement getClip
    ///剪裁的宽度等于参数传递来的百分比值与原来宽度相乘,高度不剪裁
    return Rect.fromLTWH(0, 0, percent*size.width, size.height);
  }

  ///是否需要剪裁
  @override
  bool shouldReclip(DIYCliper oldClipper) {
    // TODO: implement shouldReclip
    ///percent值在0-1之间，如果不等于0说明有部分star需要剪裁，否则不需要剪裁
    if(oldClipper.percent != 0) {
      return true;
    } else {
      return false;
    }
  }
}

