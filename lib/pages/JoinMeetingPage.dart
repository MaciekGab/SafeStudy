import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';

class JoinMeetingPage extends StatelessWidget {
  final String meetingID;
  JoinMeetingPage({Key key, @required this.meetingID}) : super(key: key);
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
      return StreamProvider<MeetingDataModel>.value(
            value: db.streamMeetingData(meetingID),
            child: MeetingSummary(meetingID: meetingID));
    }
  }
  // {
  //   var userData = Provider.of<UserDataModel>(context);
  //   return  Provider(
  //     child: Scaffold(
  //         body: SafeArea(child:
  //         Center(
  //           child: Column(
  //             children: [
  //             ],
  //           ),
  //         ),
  //
  //         )
  //     ),
  //   );
  // }


class MeetingSummary extends StatelessWidget {
  final String meetingID;
  const MeetingSummary({
    Key key,
    @required this.meetingID
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    var meetingData = Provider.of<MeetingDataModel>(context);
    if(meetingData!=null) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(meetingData.teacherName),
              SizedBox(height: 10,),
              Text(meetingData.title),
              SizedBox(height: 10,),
              Text(meetingData.classroom),
              SizedBox(height: 10,),
              Text(meetingData.date),
              SizedBox(height: 10,),
              Text(meetingData.isActive.toString()),
              SizedBox(height: 10,),
              Text(meetingData.teacherID),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  if (meetingData.isActive) {
                    await FirebaseFirestore.instance.collection('meetings').doc(
                        meetingID).update(meetingData.participantsList(
                        userData.uid,
                        userData.firstName + ' ' + userData.lastName));
                    await FirebaseFirestore.instance.collection('profiles').doc(userData.uid).collection('pastMeetings').doc(meetingID).set({'title': meetingData.title, 'date': meetingData.date, 'classroom': meetingData.classroom, 'teacherName': meetingData.teacherName});
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                  else {
                    print('Meeting is closed!');
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                child: Text('Join!'),
              )
            ],
          ),
        ),
      );
    }
    else
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
