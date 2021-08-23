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
import 'package:test_auth_with_rolebased_ui/widgets/RoundedElevatedButton.dart';
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
    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(),
        body: OrientationBuilder(
          builder: (context,orientation) =>
          orientation == Orientation.portrait
              ? PortraitView()
              : LandscapeView()
        )
      ),
    );
  }
}

class PortraitView extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var size = MediaQuery.of(context).size;
    var userData = Provider.of<UserDataModel>(context);
    var user = Provider.of<User>(context);
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundedText(text: 'Welcome ${userData.firstName}', roundedSide: 'left',width: 0.8*size.width,alignment: Alignment.centerRight,),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                      value: db.streamUserData(user.uid),
                      child: SettingsPage())));
                },
                alignment: Alignment.center,
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.person, color: Colors.transparent),
                    Text(' Profile '),
                    Icon(Icons.person),
                  ],
                ),
                width: 0.8 * size.width,
              ),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                      value: db.streamUserData(user.uid),
                      child: ReportInfectionPage())));
                },
                alignment: Alignment.center,
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.local_hospital_rounded, color: Colors.transparent),
                    Text(' Report infection '),
                    Icon(Icons.local_hospital_rounded),
                  ],
                ),
                width: 0.8 * size.width,
              ),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                      value: db.streamUserData(user.uid),
                      child: ScanMeetingQRPage())));
                },
                alignment: Alignment.center,
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.qr_code_scanner_rounded, color: Colors.transparent),
                    Text(' Join meeting '),
                    Icon(Icons.qr_code_scanner_rounded),
                  ],
                ),
                width: 0.8 * size.width,
              ),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChangeUserRolePage()));
                },
                alignment: Alignment.center,
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.edit, color: Colors.transparent),
                    Text(' Edit user '),
                    Icon(Icons.edit),
                  ],
                ),
                width: 0.8 * size.width,
              ),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                      value: db.streamUserData(user.uid),
                      child: CreateMeetingPage())));
                },
                alignment: Alignment.center,
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.group_add_rounded, color: Colors.transparent),
                    Text(' Create meeting '),
                    Icon(Icons.group_add_rounded),
                  ],
                ),
                width: 0.8 * size.width,
              ),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CheckMeetingsPage(role: userData.role,uid: userData.uid,)));
                },
                alignment: Alignment.center,
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.calendar_today_rounded, color: Colors.transparent),
                    Text(' Show meetings '),
                    Icon(Icons.calendar_today_rounded),
                  ],
                ),
                width: 0.8 * size.width,
              ),
            ])
    );
  }
}

class LandscapeView extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var size = MediaQuery.of(context).size;
    var userData = Provider.of<UserDataModel>(context);
    var user = Provider.of<User>(context);
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundedText(text: 'Welcome ${userData.firstName}', roundedSide: 'left',width: 0.8*size.width,alignment: Alignment.centerRight,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                          value: db.streamUserData(user.uid),
                          child: SettingsPage())));
                    },
                    alignment: Alignment.center,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.person, color: Colors.transparent),
                        Text(' Profile '),
                        Icon(Icons.person),
                      ],
                    ),
                    width: 0.4 * size.width,
                  ),
                  RoundedElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                          value: db.streamUserData(user.uid),
                          child: ReportInfectionPage())));
                    },
                    alignment: Alignment.center,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.local_hospital_rounded, color: Colors.transparent),
                        Text(' Report infection '),
                        Icon(Icons.local_hospital_rounded),
                      ],
                    ),
                    width: 0.4 * size.width,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                          value: db.streamUserData(user.uid),
                          child: ScanMeetingQRPage())));
                    },
                    alignment: Alignment.center,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.qr_code_scanner_rounded, color: Colors.transparent),
                        Text(' Join meeting '),
                        Icon(Icons.qr_code_scanner_rounded),
                      ],
                    ),
                    width: 0.4 * size.width,
                  ),
                  RoundedElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChangeUserRolePage()));
                    },
                    alignment: Alignment.center,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.edit, color: Colors.transparent),
                        Text(' Edit user '),
                        Icon(Icons.edit),
                      ],
                    ),
                    width: 0.4 * size.width,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                          value: db.streamUserData(user.uid),
                          child: CreateMeetingPage())));
                    },
                    alignment: Alignment.center,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.group_add_rounded, color: Colors.transparent),
                        Text(' Create meeting '),
                        Icon(Icons.group_add_rounded),
                      ],
                    ),
                    width: 0.4 * size.width,
                  ),
                  RoundedElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CheckMeetingsPage(role: userData.role,uid: userData.uid,)));
                    },
                    alignment: Alignment.center,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.calendar_today_rounded, color: Colors.transparent),
                        Text(' Show meetings '),
                        Icon(Icons.calendar_today_rounded),
                      ],
                    ),
                    width: 0.4 * size.width,
                  ),
                ],
              ),

            ])
    );
  }
}
