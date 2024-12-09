import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Ex094Notification extends StatefulWidget {
  const Ex094Notification({super.key});

  @override
  State<Ex094Notification> createState() => _Ex094NotificationState();
}

class _Ex094NotificationState extends State<Ex094Notification> {
  @override
  void initState() {
    // TODO: implement initState
    AwesomeNotifications().setListeners(
      ///这种写法也可以，感觉不够简洁
      /*
        onActionReceivedMethod: (ReceivedAction receivedAction) {
          return NotificationController.onActionReceivedMethod(receivedAction);
        },
       */
      ///第一个参数是必须的，剩下的三个参数是可选的
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  ///获取应用发送通知的权限
  void requestPermissionOfNotification(BuildContext context) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
      if(!isAllowed) {
        debugPrint("Notification permission is not allowed");
        if(mounted) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Dialog of Notification"),
                  content: const Text(
                      "Do you allow the permission of notification ?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        debugPrint("Yes selected");
                        AwesomeNotifications()
                            .requestPermissionToSendNotifications();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () {
                        debugPrint("No selected");
                        Navigator.of(context).pop();
                      },
                      child: const Text("No"),
                    ),
                  ],
                );
             }); //builder
       }
      } else {
        debugPrint("Notification permission is allowed");
      }
    });
  }

  void showNotification() {
    //创建通知前需要判断是否有通知权限，如果没有权限就创建通知会有异常：
    // me.carda.awesome_notifications.core.exceptions.AwesomeNotificationsException: Notifications are disabled
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          ///这个key需要和main方法中注册的key相同，不然会提示找不到key
          channelKey: "key4channel",
          actionType: ActionType.Default,
          // actionType: ActionType.KeepOnTop,
          title: "Notification Title",
          body: "this is the body of notification",
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 90,
            child:Text("data"),
          ),

          Positioned(
            top: 120,
            child:ElevatedButton(
              onPressed: () {
                requestPermissionOfNotification(context);
              },
              child: const Text("request notification permission"),
            ),
          ),

          Positioned(
            top: 240,
            child:ElevatedButton(
              onPressed: () {
                showNotification();
              },
              child: const Text("show notification"),
            ),
          ),
        ],
      ),
    );
  }
}

///这个类自定义的，用来响应各种通知事件
class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    debugPrint("onNotificationCreatedMethod");
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    debugPrint("onNotificationDisplayedMethod");
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint("onDismissActionReceivedMethod");
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint("onActionReceivedMethod");
  }
}
