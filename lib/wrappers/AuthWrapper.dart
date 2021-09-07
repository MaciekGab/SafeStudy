import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/pages/SignInPage.dart';
import 'DbWrapper.dart';

class AuthWrapper extends StatefulWidget {
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final auth = FirebaseAuth.instance;
  FirebaseMessaging firebaseMessaging;
  String notificationText;

  @override
  void initState() {
    super.initState();
    firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.subscribeToTopic("messaging");
    firebaseMessaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(value.notification.title),
                content: Text(value.notification.body),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      if (event != null) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(event.notification.title),
                content: Text(event.notification.body),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      if(event != null) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(event.notification.title),
                content: Text(event.notification.body),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    bool loggedIn = user != null;

    if (loggedIn) {
      return DbWrapper();
    } else {
      return SignInPage();
    }
  }
}
