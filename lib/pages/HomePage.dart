import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/pages/HomePages/TeacherHomePage.dart';
import 'package:test_auth_with_rolebased_ui/pages/SettingsPage.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';

import 'HomePages/AdminHomePage.dart';
import 'HomePages/UserHomePage.dart';

class HomePage extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    var user = Provider.of<User>(context);

    if(userData != null){
      if (userData.role == 'admin')
        return AdminHomePage();
      else if (userData.role == 'user')
        return UserHomePage();
      else
        return TeacherHomePage();
    }
    else
      return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
