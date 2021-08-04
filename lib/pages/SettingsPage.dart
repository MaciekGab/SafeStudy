import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/services/AuthService.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';

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
                    Text(userData.firstName + ' ' + userData.lastName + ' ' + userData.email),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<AuthService>().singOut();
                          // starsza na pewno działąca wersja
                          // auth.signOut();
                        },
                        child: Text('SignOut'))
                  ]))));

    }
    else
      return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
