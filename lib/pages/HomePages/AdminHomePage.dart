import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/pages/ChangeUserRolePage.dart';
import 'package:test_auth_with_rolebased_ui/pages/CheckMeetingsPage.dart';
import 'package:test_auth_with_rolebased_ui/pages/ReportInfectionPage.dart';
import 'package:test_auth_with_rolebased_ui/pages/SettingsPage.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedText.dart';

import '../../SizeConfig.dart';
import '../CreateMeetingPage.dart';
import '../ScanMeetingQRPage.dart';

class AdminHomePage extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var userData = Provider.of<UserDataModel>(context);
    var user = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(),
        body: Center(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundedText(screenPercentageWidth: 65, screenPercentageHeight: 10, roundedSide: 'left', text: 'Welcome ${userData.firstName}',),
                    ],
                  ),
              SizedBox(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CheckMeetingsPage(role: userData.role,uid: userData.uid,)));
                  },
                  child: Text('Show meetings')),
            ])
        )
      ),
    );
  }
}
