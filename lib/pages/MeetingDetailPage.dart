import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';

class MeetingDetailPage extends StatelessWidget {
  final DocumentSnapshot meeting;
  const MeetingDetailPage({Key key, @required this.meeting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ParticipantsDataModel> names = List<ParticipantsDataModel>.from(meeting['participants'].map((item) {
      return new ParticipantsDataModel(
          fcmToken: item['fcmToken'],
          userName: item['UserName']); }));
    names.removeAt(0);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text(meeting['title']),
              SizedBox(height: 10,),
              Text(meeting['teacherName']),
              SizedBox(height: 10,),
              Text(meeting['classroom']),
              SizedBox(height: 10,),
              Text(meeting['date']),
              SizedBox(height: 10,),
              Text('Attendance list'),
            ListView.builder(
              // scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: names.length,
                itemBuilder: (_,index) {
                  return Center(child: Text(names[index].userName));
                  // return ListTile(
                  //   title: Text(names[index].userName)
                  // );
                }),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
