import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/pages/ChangeUserRolePage.dart';
import 'package:test_auth_with_rolebased_ui/pages/SettingsPage.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';

import '../CreateMeetingPage.dart';
import '../ScanMeetingQRPage.dart';

class AdminHomePage extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Scaffold(
      body:  SafeArea(
          child: Center(
              child: Column(children: [
                SizedBox(
                  child: Icon(Icons.accessible_forward_rounded),
                  width: 150,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                          value: db.streamUserData(user.uid),
                          child: SettingsPage())));
                    },
                    child: Text('SignOut')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                          value: db.streamUserData(user.uid),
                          child: ScanMeetingQRPage())));
                    },
                    child: Text('Join meeting')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChangeUserRolePage()));
                    },
                    child: Text('Edit user')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                          value: db.streamUserData(user.uid),
                          child: CreateMeetingPage())));
                    },
                    child: Text('Create meeting')),
                ElevatedButton(
                    onPressed: () {
                      auth.signOut();
                    },
                    child: Text('Emergency')),
              ]))),
    );
  }
}
