import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/pages/SettingsPage.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedElevatedButton.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedText.dart';

import '../ReportInfectionPage.dart';
import '../ScanMeetingQRPage.dart';


class UserHomePage extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    var size = MediaQuery.of(context).size;
    var user = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(),
      body: Column(
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
              SizedBox()]
      ),
          ),
      );
  }
}

