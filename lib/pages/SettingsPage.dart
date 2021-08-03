import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/wrappers/AuthWrapper.dart';

class SettingsPage extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    if(userData!=null){
      return Scaffold(
          body: SafeArea(
              child: Center(
                  child: Row(children: [
                    Text(userData.firstName + ' ' + userData.lastName),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          auth.signOut();
                        },
                        child: Text('SignOut'))
                  ]))));

    }
    else
      return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
