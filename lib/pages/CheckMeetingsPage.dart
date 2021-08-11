import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_auth_with_rolebased_ui/pages/MeetingDetailPage.dart';

class CheckMeetingsPage extends StatefulWidget {
  final String role;
  final String uid;
  const CheckMeetingsPage({Key key, @required this.role, @required this.uid}) : super(key: key);

  @override
  _CheckMeetingsPageState createState() => _CheckMeetingsPageState(role: role,uid: uid);
}

class _CheckMeetingsPageState extends State<CheckMeetingsPage> {
  Future _data;
  final String role;
  final String uid;

  _CheckMeetingsPageState({ @required this.role, @required this.uid});
  // String get role => this.role;
  // String get uid => this.uid;
  @override
  void initState() {
    super.initState();
    if(role=='admin')
      _data = getMeetings();
    else
      _data = getMeetingsForTeacher(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _data,
        builder: (_, snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data.length,
              itemBuilder: (_,index) {
              return ListTile(
                title: Text(snapshot.data[index]['title']),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MeetingDetailPage(meeting: snapshot.data[index])));
                },
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
    );
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getMeetings() async{
   var querySnapshot =  await FirebaseFirestore.instance.collection('meetings').get();
   return querySnapshot.docs;
  }
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getMeetingsForTeacher(String uid) async{
    var querySnapshot =  await FirebaseFirestore.instance.collection('meetings').where('teacherID', isEqualTo: uid).get();
    return querySnapshot.docs;
  }
}
