import 'dart:math' as math;
import 'package:flutter/material.dart';

class ExGradientColor extends StatefulWidget {
  const ExGradientColor({super.key});

  @override
  State<ExGradientColor> createState() => _ExGradientColorState();
}

class _ExGradientColorState extends State<ExGradientColor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of GradientColor"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0,right: 16.0),
        child: Column(
          children: [
            const Spacer(),
            ///线性渐变
            Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.greenAccent,Colors.redAccent,Colors.amberAccent]
                )
              ),
              child:const SizedBox.shrink(),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  ///调整开始和结的位置
                  begin: Alignment.topLeft,
                  end: Alignment.center,
                  tileMode: TileMode.repeated,
                  colors: [Colors.greenAccent,Colors.redAccent,Colors.amberAccent]
                )
              ),
              child:const SizedBox.shrink(),
            ),
            const Spacer(),

            ///扇形渐变
            Container(
              width: double.infinity,
              height: 100,
              decoration:const BoxDecoration(
                  gradient: SweepGradient(
                    colors: [Colors.greenAccent,Colors.redAccent,Colors.amberAccent]
                  )
              ),
              child: const SizedBox.shrink(),
            ),

            const Spacer(),
            Container(
              width: double.infinity,
              height: 100,
              decoration:const BoxDecoration(
                  gradient: SweepGradient(
                    center: Alignment.center,
                    ///设置开始和结的角度
                    startAngle: math.pi/2,
                    endAngle: math.pi ,
                    tileMode: TileMode.repeated,
                    colors: [Colors.greenAccent,Colors.redAccent,Colors.amberAccent]
                  )
              ),
              child: const SizedBox.shrink(),
            ),

            const Spacer(),
            ///放射形渐变
            Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.greenAccent,Colors.redAccent,Colors.amberAccent]
                  )
              ),
              child: const SizedBox.shrink(),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                  gradient:RadialGradient(
                    ///渐变半径：
                    radius: 0.3,
                    //渐变位置，主要是中心位置
                    center: Alignment.center,
                    tileMode: TileMode.repeated,
                    colors: [Colors.greenAccent,Colors.redAccent,Colors.amberAccent]
                    // colors: [Colors.blue.shade100,Colors.blue.shade200,Colors.white,Colors.white,Colors.white],
                  )
              ),
              child: const SizedBox.shrink(),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
