import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedElevatedButton.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedText.dart';

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
    final size = MediaQuery.of(context).size;
    if(meetingData!=null) {
      DateTime date = meetingData.date.toDate();
      DateFormat dateOfMeeting = DateFormat('dd.MM.yyyy HH:mm');
      String formattedDateOfMeeting = dateOfMeeting.format(date);
      return SafeArea(
        child: Scaffold(
          appBar: GradientAppBar(
            title: Text('Meeting Summary'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedText(text: 'Details', roundedSide: 'left', width: 0.6*size.width, height: 0.1*size.height,alignment: Alignment.centerRight),
                RoundedText(text: 'Title: ${meetingData.title}', roundedSide: 'right', width: 0.8*size.width, height: 0.1*size.height,alignment: Alignment.centerLeft),
                RoundedText(text: 'Teacher: ${meetingData.teacherName}', roundedSide: 'right', width: 0.8*size.width, height: 0.1*size.height,alignment: Alignment.centerLeft),
                RoundedText(text: 'Date: $formattedDateOfMeeting', roundedSide: 'right', width: 0.8*size.width, height: 0.1*size.height,alignment: Alignment.centerLeft),
                RoundedElevatedButton(child: Text(' Join Meeting'), onPressed: () async {
                  await joinMeetingAction(meetingData, userData, context);
                }, alignment: Alignment.centerRight, smallButton: true, icon: Icons.check),
              ],
            ),
          ),
        ),
      );
    }
    else
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Future<void> joinMeetingAction(MeetingDataModel meetingData, UserDataModel userData, BuildContext context) async {

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Couldn't join. Meeting may have ended"),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () { },
        ),
      ));
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
