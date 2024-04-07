import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExGetMaterialApp extends StatelessWidget {
  const ExGetMaterialApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: GetHomePage(),
    );
  }

}


class GetHomePage extends StatelessWidget {
  const GetHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of GetMaterialApp"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("this is body"),
          ElevatedButton(
            onPressed: () {
              Get.snackbar("title", "Message");
            },
            child: const Text("show SnackBar"),
          ),
          Overlay(
            initialEntries: [
              OverlayEntry(builder: (context) {
                return Container(
                  color: Colors.lightGreen,
                  width: 200,
                  height: 300,
                );
              },
                opaque: false,
                maintainState: true,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Get.showOverlay(asyncFunction: () {
                debugPrint("overly running");
                return Future.value("str");
              },
                opacity: 1,
                opacityColor: Colors.redAccent,
                loadingWidget: Text("data is loading"),
              );
            },
            child: const Text("show overly"),
          ),
        ],
      ),
    );
  }
}


