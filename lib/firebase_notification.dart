import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessage {
  void firebaseOnMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        final title = message.notification!.title;
        final body = message.notification!.body;
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              contentPadding: EdgeInsets.all(18),
              children: [
                Text('Title: $title'),
                Text('Body: $body'),
              ],
            );
          },
        );
      }
    });
  }
}
