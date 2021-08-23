import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/models/PastMeetingDataModel.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/services/AuthService.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';
import 'package:test_auth_with_rolebased_ui/widgets/ListContainer.dart';
import 'package:test_auth_with_rolebased_ui/widgets/MeetingTile.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedElevatedButton.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedText.dart';

class SettingsPage extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    var size = MediaQuery.of(context).size;
    var isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    if(userData!=null){
      return SafeArea(
          child: Scaffold(
            appBar: GradientAppBar(
              title: Text('Profile')
            ),
              body: Column(
                  children: [
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 0.01*size.height,),
                    RoundedText(text: '${userData.firstName} ${userData.lastName}', roundedSide: 'left',width: 0.8*size.width, height: 0.1*size.height,alignment: Alignment.centerRight,),
                    RoundedElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<AuthService>().singOut();
                            },
                            alignment: Alignment.centerRight,
                            icon: Icons.logout,
                            smallButton: true,
                            child: Text(' Sign Out ')
                    ),
                    Container(
                      padding: EdgeInsets.only(left:20.0),
                      alignment: Alignment.centerLeft,
                      child: Text('Your meetings history:'),
                    )
                  ],
              )),
                    Expanded(
                      flex: isPortrait ? 3 : 1,
                      child: ListContainer(
                          child: FutureBuilder(
                            future: getPastMeetings(context),
                            builder: (_, snapshot) {
                              if(snapshot.hasData){
                                if(snapshot.data.length == 0)
                                  return Container(width: size.width,child: Center(child: Text('No meeting history!')));
                                return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_,index) {
                                      return BuildMeetingTile(meeting: snapshot.data[index]);
                                    });
                              }
                              else if (snapshot.hasError) {
                                return Text("Couldn't load data: ${snapshot.error}");
                              }
                              else{
                                return Center(child: CircularProgressIndicator());
                              }
                            },),
                        ),
                      ),
                  ]))
      );
    }
    else
      return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Future<List<PastMeetingDataModel>> getPastMeetings(BuildContext context) async {
    List<PastMeetingDataModel> test = [];
    QuerySnapshot testing;
    await FirebaseFirestore.instance.collection('profiles')
        .doc(Provider.of<UserDataModel>(context).uid)
        .collection('pastMeetings')
        .get()
        .then((value) => testing = value);
    testing.docs.forEach((element) {
      test.add(PastMeetingDataModel.fromFirestore(element));
    });
    return test;
  }
}
