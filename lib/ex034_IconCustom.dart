import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExIconCustom extends StatefulWidget {
  const ExIconCustom({Key? key}) : super(key: key);

  @override
  State<ExIconCustom> createState() => _ExIconCustomState();
}

class _ExIconCustomState extends State<ExIconCustom> {
  Future<void> _launchUrl()async {
    var url = 'https://pub.dev';
      if(!await launchUrl(Uri.parse(url))) {
      throw Exception('could not launch url');
    }

      //通过scheme指定
    /*
    Uri uri = Uri(scheme: 'https',
        path: 'www.baidu.com');
    if(!await launchUrl(uri)) {
      throw Exception('could not launch url');
    }
     */
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Example of Custom Icon'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.add),
          IconButton(
              onPressed: _launchUrl,
              icon:Icon(Icons.web_rounded),
          ),

        ],
      ),
    );
  }
}

class CustomIcon {
  static const IconData book = const IconData(
    0x0001,
    fontFamily: 'IconMoon',
    matchTextDirection: true,
  );
}
