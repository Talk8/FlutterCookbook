import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExLocalization extends StatefulWidget {
  const ExLocalization({Key? key}) : super(key: key);

  @override
  State<ExLocalization> createState() => _ExLocalizationState();
}

class _ExLocalizationState extends State<ExLocalization> {
  @override
  Widget build(BuildContext context) {
    Locale _locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Example of Localization'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //这两个文本显示的内容会随着手机语言的设置改变而改变
          Text("language code: ${_locale.languageCode}"),
          Text("country code: ${_locale.countryCode}"),
          Text("local all: ${_locale.toString()}"),
          //测试多语言设置是否生效，可以在MaterialApp中通过local属性手动切换语言
          Text("test localization: ${AppLocalizations.of(context)!.helloWorld}"),
        ],
      ),
    );
  }
}
