import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';

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
      DateTime date = meetingData.date.toDate();
      DateFormat dateOfMeeting = DateFormat('EEEE, MMMM d, yyyy HH:mm');
      String formattedDateOfMeeting = dateOfMeeting.format(date);
      return SafeArea(
        child: Scaffold(
          appBar: GradientAppBar(
            title: Text('Meeting Summary'),
          ),
          body: Center(
            child: Column(
              children: [
                Text(meetingData.teacherName),
                SizedBox(height: 10,),
                Text(meetingData.title),
                SizedBox(height: 10,),
                Text(meetingData.classroom),
                SizedBox(height: 10,),
                Text(formattedDateOfMeeting),
                SizedBox(height: 10,),
                Text(meetingData.isActive.toString()),
                SizedBox(height: 10,),
                Text(meetingData.teacherID),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async {
                    if (meetingData.isActive) {
                      String messageToken =  await FirebaseMessaging.instance.getToken();
                      await FirebaseFirestore.instance.collection('meetings').doc(
                          meetingID).update(meetingData.participantsList(
                          messageToken,
                          userData.firstName + ' ' + userData.lastName,
                      ));
                      await FirebaseFirestore.instance.collection('meetings').doc(
                          meetingID).update(meetingData.participantsIdList(
                        userData.uid,
                      ));
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
        ),
      );
    }
    else
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
