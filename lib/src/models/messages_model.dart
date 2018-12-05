import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kijiweni_flutter/src/utils/consts.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class MessagesModel extends Model {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void firebaseCloudMessagingListeners() {
    // if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      // print(token);
    });

    _firebaseMessaging.subscribeToTopic(SUBSCRIPTION_UPDATES);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  

  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true)
  //   );
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings)
  //   {
  //     print("Settings registered: $settings");
  //   });
  // }

}
