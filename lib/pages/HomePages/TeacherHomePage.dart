import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/pages/CreateMeetingPage.dart';
import 'package:test_auth_with_rolebased_ui/pages/ScanMeetingQRPage.dart';
import 'package:test_auth_with_rolebased_ui/pages/SettingsPage.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';

import '../CheckMeetingsPage.dart';
import '../ReportInfectionPage.dart';


class TeacherHomePage extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    var user = Provider.of<User>(context);
    return Scaffold(body: SafeArea(
      child: Center(child: Column(
        children: [
          Text('Teacher'),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                    value: db.streamUserData(user.uid),
                    child: SettingsPage())));
              },
              child: Text('Profile')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                    value: db.streamUserData(user.uid),
                    child: ReportInfectionPage())));
              },
              child: Text('Report infection')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                    value: db.streamUserData(user.uid),
                    child: CreateMeetingPage())));
              },
              child: Text('Create meeting')),
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
                    MaterialPageRoute(builder: (context) => CheckMeetingsPage(role: userData.role,uid: userData.uid,)));
              },
              child: Text('Show meetings')),
          ElevatedButton(
              onPressed: () {
                auth.signOut();
              },
              child: Text('Emergency'))
        ],
      )),
    ));
  }
}

