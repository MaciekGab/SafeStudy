import 'package:cloud_firestore/cloud_firestore.dart';
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
                  child: Column(children: [
                    Text(userData.firstName + ' ' + userData.lastName + ' ' + userData.email),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<AuthService>().singOut();
                        },
                        child: Text('SignOut')),
                    Text('Your meetings history:'),
                    FutureBuilder(
                      future: getMeetings(context),
                      builder: (_, snapshot) {
                        if(snapshot.hasData){
                          return ListView.builder(
                            shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (_,index) {
                                return ListTile(
                                  title: Text(snapshot.data[index]['title']),
                                );
                              });
                        }
                        else if (snapshot.hasError) {
                          return Text("Couldn't load data: ${snapshot.error}");
                        }
                        else{
                          return Center(child: CircularProgressIndicator());
                        }
                      },),
                  ]))));

    }
    else
      return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getMeetings(BuildContext context) async{
    var querySnapshot =  await FirebaseFirestore.instance.collection('profiles').doc(Provider.of<UserDataModel>(context).uid).collection('pastMeetings').get();
    return querySnapshot.docs;
  }
}
