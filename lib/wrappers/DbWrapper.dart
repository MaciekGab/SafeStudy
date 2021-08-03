import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/pages/HomePage.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/wrappers/AuthWrapper.dart';


class DbWrapper extends StatelessWidget {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    if (user != null) {
      return
        StreamProvider<UserDataModel>.value(
            value: db.streamUserData(user.uid),
            child: HomePage());
    }
    else
      return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}