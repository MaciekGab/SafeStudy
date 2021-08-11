import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_auth_with_rolebased_ui/pages/MeetingDetailPage.dart';

class CheckMeetingsPage extends StatefulWidget {
  const CheckMeetingsPage({Key key}) : super(key: key);

  @override
  _CheckMeetingsPageState createState() => _CheckMeetingsPageState();
}

class _CheckMeetingsPageState extends State<CheckMeetingsPage> {
  Future _data;
  @override
  void initState() {
    super.initState();
    _data = getMeetings();
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
}
