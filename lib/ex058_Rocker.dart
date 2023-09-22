import 'dart:collection';

import 'package:flutter/material.dart';
///包中的内容在可空检查上有错误，需要修改包中的文件才可以，我将包中5个文件中的内容复制到这里来使用
///因此不再使用包中的内容。本章回中包含三个摇杆：JoystickView这个是包中的摇杆，只能在固定条件下使用
/// RockerWidget是我准备参考包中的写的，但是无法获取计算坐标，因此放弃。
/// CustomRocker是结合自定义组件的内容实现的，这个可以正常使用。
///与150和151的内容相匹配
// import 'package:control_pad_plus/control_pad_plus.dart';

import 'dart:math' as _math;


class ExRocker extends StatefulWidget {
  const ExRocker({super.key});

  @override
  State<ExRocker> createState() => _ExRockerState();
}

class _ExRockerState extends State<ExRocker> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Rocker'),
        backgroundColor: Colors.purpleAccent,
      ),
      ///在组件外加了一个容器，用来限制手势事件的范围,加或者不加都可以，因为CustomRocker自带限制边框
      ///如果想加容器，长度和宽度最好相同，而且容器大小不能小于CustomRocker自带的边框大小。否则无法显示组件
      body: const SizedBox(
        // width: 400,
        // height: 400,
        ///使用自定义的组件,通过绘制实现
          child: CustomRocker(radius: 100,ratio: 0.5,padding: 8,),
        ///使用自定义的组件,通过组合组件实现
        // child: RockerWidget(outerSize: 200,innerSize: 100,),
        ///使用三方包中的组件
        //   child: JoystickView(
        //     size: 300,
        //     backgroundColor: Colors.green,
        //     innerCircleColor: Colors.purple,
        //   ),
      ),
    );
  }
}

///--------------------- joyStick package start -------------------------
///下面的文件和代码来自control_pad_plus这个三方包，由于有空指针问题，不能使用，包中的文件不多，我将其复制到这里修改后使用
///修改的地方都使用： talk8 change标志，原来的代码注释掉，这样方便以后查看
///这个包的圆形的是通过Container实现的，它使用装饰器修改了形状，同时添加了边框和阴影，因此外观效果不错。
///用来显示方向的坐标是icon,还可以是文字，我没有使用文字。
///这个包的缺点是尺寸和大小都固定了，无法计算到中间小圆的圆心坐标，只能使用固定大小画出来，
///代码中计算坐标的算法实在是看不明白，而且这个算法也和圆形大家绑定了，换个大小后就出错。
///这个包可以借鉴的地方有：画圆形，画方向，计算角度和弧度的方法，使用stack叠加组件的思路。
///file:gestures.dart
/// Supported gestures for pad buttons.
enum Gestures {
  tapDown,
  tapUp,
  tapCancel,
  tap,
  longPress,
  longPressStart,
  longPressUp,
}
///file: pad_button_item.dart
// import 'package:flutter/material.dart';
// import 'gestures.dart';

/// Model of one pad button
class PadButtonItem {
  /// [index] required parameter, the key to recognize button instance
  /// must be declared with null-aware operator (?)
  final int? index;

  /// [buttonText] is optional; the text to be displayed inside the
  /// button. Omitted if [buttonImage] is set. Default vlaue is an empty
  /// string.
  final String? buttonText;

  /// [buttonImage] is optional; image displayed inside button
  /// optional => needs null-aware operator
  final Image? buttonImage;

  /// [buttonIcon] is optional; an icon displayed inside the button
  /// optional parameter => needs null-aware operator
  final Icon? buttonIcon;

  /// [backgroundColor]: color of button in default state
  final Color? backgroundColor;

  /// [pressedColor]: color of button when pressed
  final Color? pressedColor;

  /// [supportedGestures]: optional; list of gestures for button
  /// will call the callback [PadButtonsView.padButtonPressedCallback].
  ///
  /// Default value is [Gestures.TAP].
  final List<Gestures> supportedGestures;

  const PadButtonItem({
    @required this.index,
    this.buttonText,
    this.buttonImage,
    this.buttonIcon,
    this.backgroundColor = Colors.white54,
    this.pressedColor = Colors.lightBlueAccent,
    this.supportedGestures = const [Gestures.tap],
  }) : assert(index != null);
}


///file： circle_view.dart
class CircleView extends StatelessWidget {
  final double? size;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final double? opacity;
  final Image? buttonImage;
  final Icon? buttonIcon;
  final String? buttonText;

  const CircleView({
    super.key,
    this.size,
    this.color = Colors.transparent,
    this.boxShadow,
    this.border,
    this.opacity,
    this.buttonImage,
    this.buttonIcon,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: border,
        boxShadow: boxShadow,
      ),
      child: Center(
        // ignore: prefer_if_null_operators
        child: buttonIcon != null
            ? buttonIcon
            : (buttonImage != null)
            ? buttonImage
            : (buttonText != null)
            ? Text(buttonText!)
            : null,
      ),
    );
  }

  factory CircleView.joystickCircle(double size, Color color) => CircleView(
    size: size,
    color: color,
    border: Border.all(
      color: Colors.black45,
      width: 4.0,
      style: BorderStyle.solid,
    ),
    boxShadow: const <BoxShadow>[
      BoxShadow(
        color: Colors.black12,
        spreadRadius: 8.0,
        blurRadius: 8.0,
      )
    ],
  );

  factory CircleView.joystickInnerCircle(double size, Color color) =>
      CircleView(
        size: size,
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 2.0,
          style: BorderStyle.solid,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
      );

  factory CircleView.padBackgroundCircle(
      double? size, Color? backgroundColor, borderColor, Color? shadowColor,
      {double? opacity}) =>
      CircleView(
        size: size,
        color: backgroundColor,
        opacity: opacity,
        border: Border.all(
          color: borderColor,
          width: 4.0,
          style: BorderStyle.solid,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: shadowColor!,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
      );

  factory CircleView.padButtonCircle(
      double size,
      Color? color,
      Image? image,
      Icon? icon,
      String? text,
      ) =>
      CircleView(
        size: size,
        color: color,
        buttonImage: image,
        buttonIcon: icon,
        buttonText: text,
        border: Border.all(
          color: Colors.black26,
          width: 2.0,
          style: BorderStyle.solid,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 8.0,
            blurRadius: 8.0,
          )
        ],
      );
}

///file:joystick_view.dar
// import 'dart:math' as _math;

// import 'package:flutter/material.dart';

// import 'circle_view.dart';

typedef JoystickDirectionCallback = void Function(
    double degrees, double distance);

class JoystickView extends StatelessWidget {
  /// The size of the joystick.
  ///
  /// Defaults to half of the width in portrait mode
  /// or half of the height in landscape mode
  final double? size;

  /// Color of the icons
  ///
  /// Defaults to [Colors.white54]
  final Color? iconsColor;

  /// Color of the joystick background
  ///
  /// Defaults to [Colors.blueGrey]
  final Color? backgroundColor;

  /// Color of the inner (smaller) circle background
  ///
  /// Defaults to [Colors.blueGrey]
  final Color? innerCircleColor;

  /// Opacity of the joystick
  ///
  /// The opacity applies to the whole joystick including icons
  ///
  /// Defaults to [null] which means no [Opacity] widget is used
  final double? opacity; // MUST be nullable (dart sdk: 2.12 and later)

  /// Callback to be called when user pans the joystick
  ///
  /// Defaults to [null]
  /// MUST be add conditional check (null-safety)
  final JoystickDirectionCallback? onDirectionChanged;

  /// Indicated how often the [onDirectionChanged] should be called.
  ///
  /// Defaults to [null]; no lower limit (null check)
  /// Setting it to ie. 1 second will cause the callback to not be called more oftern
  /// than once per second.
  ///
  /// Exception is the [onDirectionChanged] callback being called
  /// on the [onPanStart] and [onPanEnd] callbacks. It will be called immediately.
  final Duration? interval;

  /// Shows top/right/bottom/left arrows on top of Joystick
  ///
  /// Defaults to [true]
  final bool showArrows;
// ignore: prefer_const_constructors_in_immutables
  JoystickView(
      {super.key,
        this.size,
        this.iconsColor = Colors.white54,
        this.backgroundColor = Colors.blueGrey,
        this.innerCircleColor = Colors.blueGrey,
        this.opacity,
        this.onDirectionChanged,
        this.interval,
        this.showArrows = true});

  @override
  Widget build(BuildContext context) {
    /// instead of the ?: comparison to check and set the value of [actualSize]
    /// the ?? null checking method is used to follow dart conventions when dealing
    /// with nullable types.
    ///
    /// if [size] is not null, asign it to [actualSize] otherwise assign the minimum size
    /// (width or height, using the [MediaQuery] class) to [actualSize] of the Joystick widget.
    double? actualSize = size ??
        _math.min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) *
            0.5;

    double? innerCircleSize = actualSize / 2;
    Offset? lastPosition = Offset(innerCircleSize, innerCircleSize);
    Offset? joystickInnerPosition = _calculatePositionOfInnerCircle(
        lastPosition, innerCircleSize, actualSize, Offset(0, 0));

    // DateTime? _callbackTimestamp;
    ///talk8 change
    DateTime _callbackTimestamp = DateTime.now();

    /// 整体布局使用stack：大圆嵌套小圆，大小通过size属性指定，默认屏幕宽度的一半
    /// 圆形的颜色通过color属性指定,不过圆形的边框，阴影需要在CircleView工厂方法中设定
    /// 小圆的大小圆上箭头的位置通positioned指定
    /// 触摸事件通过GestureDetector实现，stack外层加了一层GestureDetector，用来计算小圆的位置
    /// 小圆的位置由top和left属性对应值指定，该值是动态的，因此可以移动小圆
    return Center(
      child: StatefulBuilder(
        builder: (context, setState) {
          Widget joystick = Stack(
            children: <Widget>[
              CircleView.joystickCircle(
                actualSize,
                backgroundColor!,
              ),
              Positioned(
                top: joystickInnerPosition!.dy,
                left: joystickInnerPosition!.dx,
                child: CircleView.joystickInnerCircle(
                  actualSize / 2,
                  innerCircleColor!,
                ),
              ),
              if (showArrows) ...createArrows(),
            ],
          );

          return GestureDetector(
            onPanStart: (details) {
              _callbackTimestamp = _processGesture(actualSize, actualSize / 2,
                  details.localPosition, _callbackTimestamp); ///talk8 change
              setState(() => lastPosition = details.localPosition);
            },
            onPanEnd: (details) {
              // _callbackTimestamp = null;
              _callbackTimestamp = DateTime.now(); ///talk8 change
              if (onDirectionChanged != null) {
                onDirectionChanged!(0, 0);
              }
              joystickInnerPosition = _calculatePositionOfInnerCircle(
                  Offset(innerCircleSize, innerCircleSize),
                  innerCircleSize,
                  actualSize,
                  Offset(0, 0));
              setState(() =>
              lastPosition = Offset(innerCircleSize, innerCircleSize));
            },
            onPanUpdate: (details) {
              _callbackTimestamp = _processGesture(actualSize, actualSize / 2,
                  // details.localPosition, _callbackTimestamp!);
              details.localPosition, _callbackTimestamp);  //talk8 change
              joystickInnerPosition = _calculatePositionOfInnerCircle(
                  lastPosition!,
                  innerCircleSize,
                  actualSize,
                  details.localPosition);

              setState(() => lastPosition = details.localPosition);
            },
            child: (opacity != null)
                ? Opacity(opacity: opacity!, child: joystick)
                : joystick,
          );
        },
      ),
    );
  }

  List<Widget> createArrows() {
    return [
      Positioned(
        top: 16.0,
        left: 0.0,
        right: 0.0,
        child: Icon(
          Icons.arrow_upward,
          color: iconsColor,
        ),
      ),
      Positioned(
        top: 0.0,
        bottom: 0.0,
        left: 16.0,
        child: Icon(
          Icons.arrow_back,
          color: iconsColor,
        ),
      ),
      Positioned(
        top: 0.0,
        bottom: 0.0,
        right: 16.0,
        child: Icon(
          Icons.arrow_forward,
          color: iconsColor,
        ),
      ),
      Positioned(
        bottom: 16.0,
        left: 0.0,
        right: 0.0,
        child: Icon(
          Icons.arrow_downward,
          color: iconsColor,
        ),
      )
    ];
  }

  DateTime _processGesture(double size, double ignoreSize, Offset offset,
      DateTime callbackTimestamp) {
    double? middle = size / 2.0;

    double? angle = _math.atan2(offset.dy - middle, offset.dx - middle);
    double? degrees = angle * 180 / _math.pi + 90;
    if (offset.dx < middle && offset.dy < middle) {
      degrees = 360 + degrees;
    }

    double? dx = _math.max(0, _math.min(offset.dx, size));
    double? dy = _math.max(0, _math.min(offset.dy, size));

    double? distance =
    _math.sqrt(_math.pow(middle - dx, 2) + _math.pow(middle - dy, 2));

    double? normalizedDistance = _math.min(distance / (size / 2), 1.0);

    DateTime? _callbackTimestamp = callbackTimestamp;

    if (onDirectionChanged != null &&
        _canCallOnDirectionChanged(callbackTimestamp)) {
      _callbackTimestamp = DateTime.now();
      onDirectionChanged!(degrees, normalizedDistance);
    }

    return _callbackTimestamp;
  }

  /// Checks if the [onDirectionChanged] can be called.
  ///
  /// Returns true if enough time has passed since last time it was called
  /// or when there is no [interval] set.
  bool _canCallOnDirectionChanged(DateTime callbackTimestamp) {
    if (interval != null) {
      int? intervalMilliseconds = interval!.inMilliseconds;
      int? timestampMilliseconds = callbackTimestamp.millisecondsSinceEpoch;
      int? currentTimeMilliseconds = DateTime.now().millisecondsSinceEpoch;

      if (currentTimeMilliseconds - timestampMilliseconds <=
          intervalMilliseconds) {
        return false;
      }
    }

    return true;
  }

  /// Calculates the position of the inner circle when it is moved by gestures.
  ///
  /// Returns a 2D floating point offset of xPosition and yPosition based off the
  /// [lastPosition] of the inner circle.
  Offset _calculatePositionOfInnerCircle(
      Offset lastPosition, double innerCircleSize, double size, Offset offset) {
    double? middle = size / 2.0;

    double? angle = _math.atan2(offset.dy - middle, offset.dx - middle);
    double? degrees = angle * 180 / _math.pi;
    if (offset.dx < middle && offset.dy < middle) {
      degrees = 360 + degrees;
    }
    bool? isStartPosition = lastPosition.dx == innerCircleSize &&
        lastPosition.dy == innerCircleSize;
    double? lastAngleRadians =
    (isStartPosition) ? 0 : (degrees) * (_math.pi / 180.0);

    var rBig = size / 2;
    var rSmall = innerCircleSize / 2;

    var x = (lastAngleRadians == -1)
        ? rBig - rSmall
        : (rBig - rSmall) + (rBig - rSmall) * _math.cos(lastAngleRadians);
    var y = (lastAngleRadians == -1)
        ? rBig - rSmall
        : (rBig - rSmall) + (rBig - rSmall) * _math.sin(lastAngleRadians);

    var xPosition = lastPosition.dx - rSmall;
    var yPosition = lastPosition.dy - rSmall;

    var angleRadianPlus = lastAngleRadians + _math.pi / 2;
    if (angleRadianPlus < _math.pi / 2) {
      if (xPosition > x) {
        xPosition = x;
      }
      if (yPosition < y) {
        yPosition = y;
      }
    } else if (angleRadianPlus < _math.pi) {
      if (xPosition > x) {
        xPosition = x;
      }
      if (yPosition > y) {
        yPosition = y;
      }
    } else if (angleRadianPlus < 3 * _math.pi / 2) {
      if (xPosition < x) {
        xPosition = x;
      }
      if (yPosition > y) {
        yPosition = y;
      }
    } else {
      if (xPosition < x) {
        xPosition = x;
      }
      if (yPosition < y) {
        yPosition = y;
      }
    }
    return Offset(xPosition, yPosition);
  }
}

///file: pad_button_view.dart
// ignore_for_file: no_leading_underscores_for_library_prefixes

// import 'package:control_pad_plus/models/gestures.dart';
// import 'package:control_pad_plus/models/pad_button_item.dart';
// import 'package:flutter/material.dart';

// import 'circle_view.dart';

typedef PadButtonPressedCallback = void Function(
    int buttonIndex, Gestures gesture);

class PadbuttonsView extends StatelessWidget {
  /// [size]: optional; space for background circle of all pad buttons.
  /// Will be recalculated for pad button sizes.
  ///
  /// Default value calculated according to screen size.
  final double? size;

  /// List of pad buttons, default contains 4
  final List<PadButtonItem>? buttons;

  /// [padButtonPressedCallback]: contains information which button (index)
  /// was used by user
  final PadButtonPressedCallback? padButtonPressedCallback;

  /// [buttonsStateMap] contains current colors of each button.
  final Map<int, Color>? buttonsStateMap = HashMap<int, Color>();

  /// [buttonsPadding]: optional; adds paddings to buttons
  final double? buttonsPadding;

  /// [backgroundPadButtonsColor]: optional; shows circle when set
  final Color? backgroundPadButtonsColor;

  PadbuttonsView({
    super.key,
    this.size,
    this.buttons = const [
      PadButtonItem(index: 0, buttonText: 'A'),
      PadButtonItem(index: 1, buttonText: 'B', pressedColor: Colors.red),
      PadButtonItem(index: 2, buttonText: 'C', pressedColor: Colors.green),
      PadButtonItem(index: 3, buttonText: 'D', pressedColor: Colors.yellow),
    ],
    this.padButtonPressedCallback,
    this.buttonsPadding = 0,
    this.backgroundPadButtonsColor = Colors.transparent,
  }) : assert(buttons != null && buttons.isNotEmpty) {
    // ignore: avoid_function_literals_in_foreach_calls
    buttons!.forEach(
            (button) => buttonsStateMap![button.index!] = button.backgroundColor!);
  }

  @override
  Widget build(BuildContext context) {
    double? actualSize = size ??
        _math.min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) *
            0.5;
    double? innerCircleSize = actualSize / 3;

    return Center(
        child: Stack(children: createButtons(innerCircleSize, actualSize)));
  }

  List<Widget> createButtons(double innerCircleSize, double actualSize) {
    /// [list] uses the literal instead of constructor due to null-safety
    List<Widget>? list = [];
    list.add(CircleView.padBackgroundCircle(
        actualSize,
        backgroundPadButtonsColor,
        backgroundPadButtonsColor != Colors.transparent
            ? Colors.black45
            : Colors.transparent,
        backgroundPadButtonsColor != Colors.transparent
            ? Colors.black12
            : Colors.transparent));

    for (var i = 0; i < buttons!.length; i++) {
      var padButton = buttons![i];
      list.add(createPositionedButtons(
        padButton,
        actualSize,
        i,
        innerCircleSize,
      ));
    }
    return list;
  }

  Positioned createPositionedButtons(PadButtonItem padButton, double actualSize,
      int index, double innerCircleSize) {
    return Positioned(
      top: _calculatePositionYOfButton(index, innerCircleSize, actualSize),
      left: _calculatePositionXOfButton(index, innerCircleSize, actualSize),
      child: StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            _processGesture(padButton, Gestures.tap);
          },
          onTapUp: (details) {
            _processGesture(padButton, Gestures.tapUp);
            Future.delayed(const Duration(milliseconds: 50), () {
              setState(() => buttonsStateMap![padButton.index!] =
              padButton.backgroundColor!);
            });
          },
          onTapDown: (details) {
            _processGesture(padButton, Gestures.tapDown);

            setState(() =>
            buttonsStateMap![padButton.index!] = padButton.pressedColor!);
          },
          onTapCancel: () {
            _processGesture(padButton, Gestures.tapCancel);

            setState(() => buttonsStateMap![padButton.index!] =
            padButton.backgroundColor!);
          },
          onLongPress: () {
            _processGesture(padButton, Gestures.longPress);
          },
          onLongPressStart: (details) {
            _processGesture(padButton, Gestures.longPressStart);

            setState(() =>
            buttonsStateMap![padButton.index!] = padButton.pressedColor!);
          },
          onLongPressUp: () {
            _processGesture(padButton, Gestures.longPressUp);

            setState(() => buttonsStateMap![padButton.index!] =
            padButton.backgroundColor!);
          },
          child: Padding(
            padding: EdgeInsets.all(buttonsPadding!),
            child: CircleView.padButtonCircle(
                innerCircleSize,
                buttonsStateMap![padButton.index]!,
                padButton.buttonImage!,
                padButton.buttonIcon!,
                padButton.buttonText!),
          ),
        );
      }),
    );
  }

  void _processGesture(PadButtonItem button, Gestures gesture) {
    if (padButtonPressedCallback != null &&
        button.supportedGestures.contains(gesture)) {
      padButtonPressedCallback!(button.index!, gesture);
      debugPrint('$gesture padbutton id = ${[button.index]}');
    }
  }

  double _calculatePositionXOfButton(
      int index, double innerCircleSize, double actualSize) {
    double? degrees = 360 / buttons!.length * index;
    double? lastAngleRadians = (degrees) * (_math.pi / 180.0);

    var rBig = actualSize / 2;
    var rSmall = (innerCircleSize + 2 * buttonsPadding!) / 2;

    return (rBig - rSmall) + (rBig - rSmall) * _math.cos(lastAngleRadians);
  }

  double _calculatePositionYOfButton(
      int index, double innerCircleSize, double actualSize) {
    double? degrees = 360 / buttons!.length * index;
    double? lastAngleRadians = (degrees) * (_math.pi / 180.0);
    var rBig = actualSize / 2;
    var rSmall = (innerCircleSize + 2 * buttonsPadding!) / 2;

    return (rBig - rSmall) + (rBig - rSmall) * _math.sin(lastAngleRadians);
  }
}

///--------------------- joyStick package end -------------------------


///--------------------- customer rocker start -------------------------
///基类用来生成摇杆外圆形和内圆，可以是纯色，或者背景图，表示方向的地方可以是文字，icon,图片
///size是必选属性，其它属性是可以选属性
///注意：背景图使用了pub.dev的图标，如果该网站图标有变化会获取不到图片
///这个组件没有全部完成，因为无法计算到中间小圆的圆心坐标，只能使用固定大小画出来，只给它添加了
///事件响应处理，没有计算各个事件的坐标值
class BaseCircle extends StatelessWidget {
  const BaseCircle({super.key,
    required this.size,
    this.color,
    this.boxShadow,
    this.border,
    this.opacity,
    this.bgImage,
    this.buttonImage,
    this.buttonIcon,
    this.buttonText});

  final double size;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final double? opacity;
  final ImageProvider<Object>? bgImage;
  final Image? buttonImage;
  final Icon? buttonIcon;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        image: bgImage == null ? null : const DecorationImage(
          image: NetworkImage('https://pub.dev/static/hash-v7cgjij4/img/pub-dev-logo.svg'),
          // image: AssetImage('images/ex.png'),
          opacity: 1.0,
          fit: BoxFit.fill,),
        shape: BoxShape.circle,
        border: border,
        boxShadow: boxShadow,
      ),
      child: const Center(
        child: SizedBox.shrink(),
      ),
    );
  }


  ///快速创建外层圆形的工厂方法,只需要颜色和大小，边框和阴影使用默认设定值
  factory BaseCircle.outerCircle({required double size, required Color color}) => BaseCircle(
    size: size,
    color: color,
    border: Border.all(
      color: Colors.black45,
      width: 4.0,
      style: BorderStyle.solid,
    ),
    boxShadow: const <BoxShadow>[
      BoxShadow(
        color: Colors.black12,
        spreadRadius: 8.0,
        blurRadius: 8.0,
      )
    ],
  );

  ///快速创建内层圆形的工厂方法,边框和阴影使用默认设定值
  factory BaseCircle.innerCircle({required double size, required Color color}) => BaseCircle(
    size: size,
    color: color,
    border: Border.all(
      color: Colors.black26,
      width: 2.0,
      style: BorderStyle.solid,
      ),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 8.0,
          blurRadius: 8.0,
        )
      ],
  );
}

///Rocker的实现类，使用Stack实现，移动通过GestureDetector实现。
class RockerWidget extends StatefulWidget {
  const RockerWidget(
      {super.key,
        required this.outerSize,
        required this.innerSize,
        this.outerBgColor,
        this.innerBgColor,
        this.showArrowsIcon = true});

  final double outerSize;
  final double innerSize;

  final Color? outerBgColor;
  final Color? innerBgColor;
  final bool showArrowsIcon;


  @override
  State<RockerWidget> createState() => _RockerWidgetState();
}

class _RockerWidgetState extends State<RockerWidget> {
  ///多种初始化方法
  Offset center = const Offset(0, 0);
  Offset current = const Offset(50,50);


  @override
  Widget build(BuildContext context) {
    ///这个计算方法不准确，它的是值是(50,50),只有外圆是200,内圆是100时才会产生中间效果
    center = Offset(widget.outerSize/4, widget.outerSize/4);


    return GestureDetector(
      child: SizedBox(
        width: widget.outerSize,
        height: widget.outerSize,

        child: Stack(
          // alignment: Alignment.center,
          children: [
            BaseCircle.outerCircle(size: widget.outerSize,color: Colors.blue,),
            Positioned(
              top: current.dy,
              left: current.dx,
              child:BaseCircle.innerCircle(size:widget.innerSize, color: Colors.redAccent,),
            ),
          ],
        ),
      ),
      ///添加点击，滑动，弹出事件的处理，思路参考GestureGame中的代码
      onTapDown: (TapDownDetails details) {
        setState(() {
          current = details.localPosition;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          current = center;
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          current = details.localPosition;
        });
      },
      onPanEnd: (DragEndDetails details) {
        setState(() {
          current = center;
        });
      },
    );
  }
}

///--------------------- customer rocker end   -------------------------



///--------------------- customer paint rocker start -------------------------
/// 使用绘制的方式绘制rocker
///rocker的半径由构造方法传递而来，rocker的为大小为2*(radius+radius*ratio+padding)的正方形
///rocker中大圆的半径为radius,小圆的半径为radius*ratio
class CustomRocker extends StatefulWidget {
  const CustomRocker({super.key, required this.radius, required this.ratio, required this.padding});

  ///外层大圆的半径
  final double radius;
  ///外层小圆的半径*ratio = 内层圆的半径
  final double ratio;
  ///内边距
  final double padding;

  @override
  State<CustomRocker> createState() => _CustomRockerState();
}

class _CustomRockerState extends State<CustomRocker> {
  ///控制小圆偏移位置的坐标
  Offset dragOffset = Offset.zero;
  ///数学坐标,这个值为正数，需要按照数学中的坐标系自行添加负号
  Offset realOffset = Offset.zero;
  ///拖动中才修改小圆的坐标，否则不修改
  late bool isDrag = false;

  @override
  Widget build(BuildContext context) {
    ///外圆和内圆的半径
    final double outerRadius = widget.radius;
    final double innerRadius = widget.ratio>=1? widget.radius * 0.5 : widget.radius * widget.ratio;

    ///外圆和内圆的大小等于2*半径
    final Size outerSize = Size(outerRadius*2, outerRadius*2);
    final Size innerSize = Size(innerRadius*2,innerRadius*2);

    ///这是小圆的滑动区域半径，默认是大圆半径+小圆半径,需要调整滑动区域时修改0的值就可以
    ///也就是说小圆最远可能滑动到areaRadius区域
    final double areaRadius = outerRadius + innerRadius - 0;

    ///外圆外层嵌套一个正方形，用来控制Router的大小,正方形是小圆滑动区域的直径，加两个8表示两边各有8dp的内边距
    final double width = (areaRadius + widget.padding) * 2;

    ///圆心位置
    ///注意数学上的中心点不符合stack的对齐要求，因为是stack以小圆左上角坐标进行对齐，所以减去它的半径
    final Offset center = Offset(width/2-innerRadius,width/2-innerRadius);

    ///注意这里计算偏移是Position组件的偏移,以小圆左上角的坐标进行偏移，所在需要减去小圆的半径，
    if(!isDrag) {
      dragOffset = Offset(center.dx, center.dy);
    }

    ///8是真正的边距，其它计算的结果是一个相对值，它可以确保arrow位于外层大圆边上
    double arrowPadding = width/2 - outerRadius + 8;

    ///这里列出了两套箭头，一个是Android风格，一个是ISO风格
    List<Widget> showArrows(double padding,Color color) {
      return [
        Positioned(
          top: 0.0,
          bottom: 0.0,
          left: padding,
          child: Icon(
            // Icons.arrow_back,
            Icons.keyboard_arrow_left,
            color: color,
          ),
        ),
        Positioned(
          top: padding,
          left: 0.0,
          right: 0.0,
          child: Icon(
            // Icons.arrow_upward,
            Icons.keyboard_arrow_up,
            color: color,
          ),
        ),
        Positioned(
          top: 0.0,
          bottom: 0.0,
          right: padding,
          child: Icon(
            // Icons.arrow_forward,
            Icons.keyboard_arrow_right,
            color: color,
          ),
        ),
        Positioned(
          bottom: padding,
          left: 0.0,
          right: 0.0,
          child: Icon(
            // Icons.arrow_downward,
            Icons.keyboard_arrow_down,
            color: color,
          ),
        )
      ];
    }

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      ///手势事件限制在这个容器内，他的大小与大圆形的半径和比率有关，也可以直接使用固定值指定
      child: Container(
        ///这个颜色是组件的背景，可以修改,调试时添加背景有助于调试
        color: Colors.grey,
        width: width,
        height: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ///画外层大圆
            CustomPaint(
              painter: RockerPainter(outerRadius,Colors.blue),
              // size: Size.infinite,
              size: outerSize,
            ),
            ///显示四个方向箭头,放在这里时在小圆移动过程中会被遮挡
            ...showArrows(arrowPadding, Colors.white),
            ///画内层小圆,这里的偏移与画圆时的偏移不同，它是表示圆形左上角与(0,0)的偏移
            Positioned(
              top: dragOffset.dy,
              left: dragOffset.dx,
              child: CustomPaint(
                painter: RockerPainter(innerRadius,Colors.deepOrangeAccent),
                size: innerSize,
              ),
            ),
            ///显示四个方向箭头,放在这里时在小圆移动过程中不会被遮挡
            // ...showArrows(arrowPadding, Colors.white),
          ],
        ),
      ),
    );
  }

  ///考虑使用streamBuilder,这样只使用画小圆形，现在是大小圆形一起画
  void _onPanUpdate(DragUpdateDetails details) {
    debugPrint('offset: ${details.delta.toString()}');
    debugPrint('drag location: ${details.localPosition.toString()}');
    double currentX,currentY,diameter,radius;
    ///触摸点的坐标
    currentX = details.localPosition.dx;
    currentY = details.localPosition.dy;
    ///这是小圆的半径
    radius = widget.ratio>=1? widget.radius * 0.5 : widget.radius * widget.ratio;
    ///这是大圆的直径
    diameter = widget.radius* 2;

    ///这是小圆的滑动区域半径，默认是大圆半径+小圆半径,需要调整滑动区域时修改0的值就可以
    ///也就是说小圆最远可能滑动到areaRadius区域
    final double areaRadius = widget.radius + radius - 0;
    ///外圆外层嵌套一个正方形，用来控制Router的大小,正方形是小圆滑动区域的直径，加两个padding表示两边各有一个内边距
    final double width = (areaRadius + widget.padding) * 2 ;
    ///圆心位置,需要考虑外边的正方形,它包含了小圆的滑动区域
    ///这个是数学上的中心点，注意：它与stack的对齐要求不一样
    final Offset center = Offset(width/2,width/2);

    ///弧度值，主要用来判断触摸点是否跑出圈外:斜边值大于外圆的半径
    ///计算方法：触摸点坐标与圆形坐标的差值，然后求反正切值，注意计算差值时分象限进行计算
    double radians = 0;
    ///三角形的三个连长，带area是小圆形滑动区域的边长，不带的是实际触摸点的边长
    double a,b,c,areaA,areaB,areaC;


    ///计算小圆偏移位置，同时把屏幕上的坐标转换为数学坐标
    ///第一象限
    if(currentX > center.dx && currentY <= center.dy) {
      dragOffset = Offset(currentX - radius, currentY - radius);
      realOffset = Offset(currentX - center.dx,center.dy - currentY);

      ///处理超出大圆范围外的触摸点，将其限定在小圆滑动区域内
      radians = _math.atan((center.dy - currentY)/(currentX - center.dx));
      ///弧度转换成角度
      // debugPrint('angel = ${radians*180/_math.pi} ');

      a = realOffset.dx;
      b = realOffset.dy; ///这个变量没有实际的作用
      c =  a / _math.cos(radians);
      debugPrint("a = $a, b = $b, c= $c, arR = $areaRadius");
      if(c > areaRadius) {
        ///注意：不是乘以滑动区域的半径，而是乘以大圆的半径
        // areaC = c - areaRadius;
        areaC = c - diameter/2;
        areaA = areaC * _math.cos(radians);
        areaB = areaC * _math.sin(radians);

        dragOffset = Offset(currentX-areaA-radius,currentY+areaB-radius);
        ///这个值最好再除一个固定值，这样便于计算比例
        realOffset = Offset(diameter/2* _math.cos(radians), diameter/2* _math.sin(radians));
        // debugPrint("drag: ${dragOffset.toString()}");
        // debugPrint("real: ${realOffset.toString()}");
      }
    }
    ///第二象限
    if(currentX <= center.dx && currentY <= center.dy) {
      dragOffset = Offset(currentX - radius, currentY - radius);
      realOffset = Offset(center.dx - currentX,center.dy - currentY);

      ///处理超出大圆范围外的触摸点，将其限定在小圆滑动区域内
      radians = _math.atan((center.dy - currentY)/(center.dx - currentX));

      a = realOffset.dx;
      b = realOffset.dy;
      c =  a / _math.cos(radians);
      // debugPrint("c= $c, arR = $areaRadius");
      if(c > areaRadius) {
        ///注意：不是减去滑动区域的半径，而是减去大圆的半径
        areaC = c - diameter/2;
        areaA = areaC * _math.cos(radians);
        areaB = areaC * _math.sin(radians);

        dragOffset = Offset(currentX+areaA-radius,currentY+areaB-radius);
        ///这个值最好再除一个固定值，这样便于计算比例
        realOffset = Offset(diameter/2* _math.cos(radians), diameter/2* _math.sin(radians));
        debugPrint("drag: ${dragOffset.toString()}");
        debugPrint("real: ${realOffset.toString()}");
      }
    }

    ///第三象限
    if(currentX <= center.dx && currentY > center.dy) {
      dragOffset = Offset(currentX - radius, currentY - radius);
      realOffset = Offset(center.dx - currentX,currentY - center.dy);

      ///处理超出大圆范围外的触摸点，将其限定在小圆滑动区域内
      radians = _math.atan((currentY - center.dy)/(center.dx - currentX));

      a = realOffset.dx;
      b = realOffset.dy;
      c =  a / _math.cos(radians);
      // debugPrint("c= $c, arR = $areaRadius");
      if(c > areaRadius) {
        ///注意：不是减去滑动区域的半径，而是减去大圆的半径
        areaC = c - diameter/2;
        areaA = areaC * _math.cos(radians);
        areaB = areaC * _math.sin(radians);

        dragOffset = Offset(currentX+areaA-radius,currentY-areaB-radius);
        ///这个值最好再除一个固定值，这样便于计算比例
        realOffset = Offset(diameter/2* _math.cos(radians), diameter/2* _math.sin(radians));
        debugPrint("drag: ${dragOffset.toString()}");
        debugPrint("real: ${realOffset.toString()}");
      }
    }
    ///第四象限
    if(currentX > center.dx && currentY > center.dy) {
      dragOffset = Offset(currentX - radius, currentY - radius);
      realOffset = Offset(currentX - center.dx,currentY - center.dy);

      ///处理超出大圆范围外的触摸点，将其限定在小圆滑动区域内
      radians = _math.atan((currentY - center.dy)/(currentX - center.dx));

      a = realOffset.dx;
      b = realOffset.dy;
      c =  a / _math.cos(radians);
      if(c > areaRadius) {
        ///注意：不是减去滑动区域的半径，而是减去大圆的半径
        // areaC = c - areaRadius;
        areaC = c - diameter/2;
        areaA = areaC * _math.cos(radians);
        areaB = areaC * _math.sin(radians);

        dragOffset = Offset(currentX-areaA-radius,currentY-areaB-radius);
        ///这个值最好再除一个固定值，这样便于计算比例
        realOffset = Offset(diameter/2* _math.cos(radians), diameter/2* _math.sin(radians));
        debugPrint("drag: ${dragOffset.toString()}");
        debugPrint("real: ${realOffset.toString()}");
      }
    }


    setState(() {
      isDrag = true;
      dragOffset = dragOffset;

      ///下面的代码可以让小圆正常滑动，但是没有使用活动区域进行限制
      // if(currentX > diameter && currentY > diameter) {
      //   debugPrint('step1 ');
      //   dragOffset = Offset(diameter-radius, diameter-radius);
      // }
      //
      // if(currentX > diameter && currentY <= diameter) {
      //   debugPrint('step2 ');
      //   dragOffset = Offset(diameter-radius, currentY-radius);
      // }
      //
      // if(currentX <= diameter && currentY > diameter) {
      //   debugPrint('step3 ');
      //   dragOffset = Offset(currentX-radius, diameter-radius);
      // }
      //
      // if(currentX <= diameter && currentY <= diameter) {
      //   debugPrint('step4 ');
      //   dragOffset = Offset(currentX-radius, currentY-radius);
      // }
      // debugPrint('step0 ');
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isDrag = false;
    });
  }
}

///画Rocker中使用的圆
class RockerPainter extends CustomPainter{
  ///offset表示圆的圆心与(0,0)的偏移距离,其值等于半径
  final Color _color;
  final double radius;
  Offset _offset = Offset.zero;
  late Rect mRect;

  RockerPainter( this.radius,this._color);

  ///参数中的size就是包含类的CustomPaint中指定的size,这里没有使用它
  @override
  void paint(Canvas canvas,Size size) {
    Paint paint = Paint()
      ..color = _color
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 2.0;

    ///圆的半径由参数指定
    _offset = Offset(radius, radius);

    canvas.save();
    mRect = Rect.fromLTWH(0, 0, size.width,size.height);
    ///画圆：以矩形为基准画一个内切圆，这是另外一种画圆的方法
    // canvas.drawOval(mRect, paint);
    // canvas.drawRect(mRect, paint);

    ///画圆：第一个参数指定Offset,表示圆的左上角为基准进行偏移而不是以圆心为基准
    canvas.drawCircle(_offset,radius,paint);
    canvas.restore();

    ///调试中用log
    // debugPrint('param: (${_offset.dx},${_offset.dy})');
    // debugPrint('size:  (${size.width},${size.height})');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
///--------------------- customer paint rocker end -------------------------
