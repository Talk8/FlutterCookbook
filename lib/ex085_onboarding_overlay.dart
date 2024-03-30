import 'package:flutter/material.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

class ExOnboardingOverlay extends StatefulWidget {
  const ExOnboardingOverlay({super.key});

  @override
  State<ExOnboardingOverlay> createState() => _ExOnboardingOverlayState();
}

class _ExOnboardingOverlayState extends State<ExOnboardingOverlay> {
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var focusNodeList = List<FocusNode>.generate(5,
          (index) => FocusNode(debugLabel: "FocusNode $index",),
      growable: false,
    );

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3,),() {
        // onboardingKey.currentState?.show();
      ///stepIndexes should contain initialIndex
        onboardingKey.currentState?.showWithSteps(0, [0,1,2]);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Onboarding(
      key: onboardingKey,
      autoSizeTexts: true,
      debugBoundaries: true,
      onChanged: (index) {
        if(index == 2) {
          onboardingKey.currentState?.hide();
        }
      },
      steps: [
        OnboardingStep(focusNode: focusNodeList[0],
          titleText: "FocusNode 1 title",
          bodyText: "FocusNode 1 body",
          hasArrow: true,
          hasLabelBox: true,
          arrowPosition: ArrowPosition.autoVertical,
          fullscreen: true,
        ),
        OnboardingStep(focusNode: focusNodeList[1],
          titleText: "FocusNode 2 title",
          titleTextColor: Colors.blue,
          bodyText: "FocusNode 2 body",
          bodyTextColor: Colors.yellow,
          hasArrow: false,
          hasLabelBox: false,
          arrowPosition: ArrowPosition.autoVertical,
          fullscreen: true,
        ),
        OnboardingStep(focusNode: focusNodeList[2],
          titleText: "FocusNode 3 title",
          bodyText: "FocusNode 3 body",
          hasArrow: true,
          hasLabelBox: true,
          arrowPosition: ArrowPosition.autoVertical,
          fullscreen: true,
        ),

      ],
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Example of onboardingOverlay"),
          actions: [
            Focus(
              focusNode: focusNodeList[0],
                child: Text("show focus"),
            ),
          ],
        ),
        body: Column(
          children: [
            Text("body of scaffold "),
            IconButton(onPressed: (){
              onboardingKey.currentState?.show();
            }, icon: Icon(Icons.delete),focusNode: focusNodeList[1],),
            Focus(
              focusNode: focusNodeList[2],
              child: Text("show focus"),
            ),
          ],
        ),
      ),
    );
  }
}
