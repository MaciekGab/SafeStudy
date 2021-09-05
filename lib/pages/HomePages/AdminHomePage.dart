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

import '../../utils/SizeConfig.dart';
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
              RoundedText(text: 'Welcome ${userData.firstName}', roundedSide: 'left',width: 0.8*size.width, height: 0.1*size.height,alignment: Alignment.centerRight,),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                      value: db.streamUserData(user.uid),
                      child: SettingsPage())));
                },
                alignment: Alignment.center,
                child: Text(' Profile '),
                icon:Icons.person,
                width: 0.8 * size.width, smallButton: false,
              ),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                      value: db.streamUserData(user.uid),
                      child: ReportInfectionPage())));
                },
                alignment: Alignment.center,
                child: Text(' Report infection '),
                  icon:Icons.local_hospital_rounded,
                width: 0.8 * size.width, smallButton: false,
              ),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                      value: db.streamUserData(user.uid),
                      child: ScanMeetingQRPage())));
                },
                alignment: Alignment.center,
                child:
                    Text(' Join meeting '),
                width: 0.8 * size.width, icon: Icons.qr_code_scanner_rounded, smallButton: false,
              ),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChangeUserRolePage()));
                },
                alignment: Alignment.center,
                child: Text(' Edit user '),
                width: 0.8 * size.width, icon: Icons.edit, smallButton: false,
              ),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                      value: db.streamUserData(user.uid),
                      child: CreateMeetingPage())));
                },
                alignment: Alignment.center,
                child: Text(' Create meeting '),
                width: 0.8 * size.width, smallButton: false, icon: Icons.group_add_rounded,
              ),
              RoundedElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CheckMeetingsPage(role: userData.role,uid: userData.uid,)));
                },
                alignment: Alignment.center,
                child: Text(' Show meetings '),
                width: 0.8 * size.width, icon: Icons.calendar_today_rounded, smallButton: false,
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
                    child: Text(' Profile '),
                    icon: Icons.person,
                    width: 0.4 * size.width, smallButton: false,
                  ),
                  RoundedElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                          value: db.streamUserData(user.uid),
                          child: ReportInfectionPage())));
                    },
                    alignment: Alignment.center,
                    icon: Icons.local_hospital_rounded,
                    child: Text(' Report infection '),
                    width: 0.4 * size.width, smallButton: false,
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
                    child: Text(' Join meeting '),
                    width: 0.4 * size.width, smallButton: false, icon: Icons.qr_code_scanner_rounded,
                  ),
                  RoundedElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChangeUserRolePage()));
                    },
                    alignment: Alignment.center,
                    child: Text(' Edit user '),
                    width: 0.4 * size.width, smallButton: false, icon: Icons.edit,
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
                    child: Text(' Create meeting '),
                    width: 0.4 * size.width, icon: Icons.group_add_rounded, smallButton: false,
                  ),
                  RoundedElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CheckMeetingsPage(role: userData.role,uid: userData.uid,)));
                    },
                    alignment: Alignment.center,
                    child: Text(' Show meetings '),
                    width: 0.4 * size.width, icon: Icons.calendar_today_rounded, smallButton: false,
                  ),
                ],
              ),

            ])
    );
  }
}
