import 'dart:collection';

import 'package:flutter/material.dart';
///包中的内容在可空检查上有错误，需要修改包中的文件才可以，我将包中5个文件中的内容复制到这里来使用
///因此不再使用包中的内容。
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
      body: const SizedBox(
        width: 200,
        height: 200,
        ///使用自定义的组件,通过绘制实现
          child: RockerCus(),
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
class RockerCus extends StatefulWidget {
  const RockerCus({super.key});

  @override
  State<RockerCus> createState() => _RockerCusState();
}

class _RockerCusState extends State<RockerCus> {
  final Offset _center = const Offset(200,200);
  Offset _dragPos = const  Offset(0,0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        painter: RockerPainter(_center,_dragPos),
        // size: Size.infinite,
        size:const Size(300,300),
      ),
    );
    // return CustomPaint(
    //   painter: RockerPainter(_center,_dragPos),
    //   size: Size(300,300),
    // );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    debugPrint('offset: ${details.delta.toString()}');
    setState(() {
      _dragPos = Offset(_dragPos.dx + details.delta.dx, _dragPos.dy + details.delta.dy);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _dragPos = _center;
    });
  }
}

class RockerPainter extends CustomPainter{
  final Offset _subCenter;
  final Offset _subDragPos;

  RockerPainter(this._subCenter,this._subDragPos);

  @override
  void paint(Canvas canvas,Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    // Path path = Path()
    //   ..moveTo(_subCenter.dx, _subCenter.dy)
    //   ..quadraticBezierTo(_subDragPos.dx, _subDragPos.dy,
    //     _subCenter.dx + 50 *(1-_subDragPos.dx/size.width),
    //     _subCenter.dy +50*(1- _subDragPos.dy/size.height),)
    //   ..quadraticBezierTo(_subCenter.dx - 50 *(1- _subDragPos.dx/size.width),
    //       _subCenter.dy - 50 *(1 - _subDragPos.dy/size.height),
    //       _subCenter.dx,_subCenter.dy)
    //   ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
///--------------------- customer paint rocker end -------------------------
