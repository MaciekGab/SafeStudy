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
import '../utils/Utils.dart';
import '../services/NotificationService.dart';

class ReportInfectionPage extends StatefulWidget {
  const ReportInfectionPage({Key key}) : super(key: key);

  @override
  State<ReportInfectionPage> createState() => _ReportInfectionPageState();
}

class _ReportInfectionPageState extends State<ReportInfectionPage> {
  // var _db = FirebaseFirestore.instance;
  var _db = DatabaseService();
  DateTime dateOfInfection = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Set<String> dataSet = {};
  List<MeetingDataModel> listOfMeetings = [];
  List<String> usersToNotify;
  Timestamp dateToCompare;
  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          appBar: GradientAppBar(
            title: Text('Report Infection'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedText(text: 'Choose date of infection', roundedSide: 'right', width: 0.8*size.width, height: 0.1*size.height, alignment: Alignment.centerLeft),
                SizedBox(height: 20,),
                RoundedElevatedButton(child: Text('When:  ${DateFormat('dd-MM-yyyy').format(dateOfInfection)}',), onPressed: () async{
                  await pickDate(context, dateOfInfection).then((value) {setState(() {dateOfInfection = value;});});
                }, alignment: Alignment.center, smallButton: false, icon: Icons.calendar_today_rounded, width: 0.7*size.width, height: 0.11*size.height,),
                RoundedElevatedButton(child: Text(' Report ',), onPressed: () async{
                  return await reportAction(userData, context);
                }, alignment: Alignment.centerRight, smallButton: true, icon: Icons.check),
                SizedBox(height: 20,),
                // Text('QR value: '+ _qrCodeData)
              ],
            ),
          ),

        )
    );
  }

  Future<void> reportAction(UserDataModel userData, BuildContext context) async {
    dataSet = {};
    listOfMeetings = [];
    dateToCompare = Timestamp.fromDate(dateOfInfection);
    await _db.getMeetingsWithInfectedPerson(userData.uid, dateToCompare).then((value) => listOfMeetings = value);
    if(listOfMeetings.length > 0) {
      listOfMeetings.forEach((element) {element.participants.forEach((value) { dataSet.add(value.fcmToken);});});
      String fcmUserToken = await FirebaseMessaging.instance.getToken();
      dataSet.remove(fcmUserToken);
      usersToNotify = dataSet.toList();
    }
    return await confirmationDialog(context, userData);
  }

  Future<void> confirmationDialog(BuildContext context, UserDataModel userData) async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dataSet.length > 0 ? AlertDialog(
          title: Text('This message will be send to ${dataSet.length} users'),
          content: Text('Are you sure to send it?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'NO'),
              child: Text('NO'),
            ),
            TextButton(
              onPressed: () async {
                await sendNotificationAction(userData, context);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('YES'),
            ),
          ]
        ) : AlertDialog(
          title: Text('No one will receive message'),
          actions: [ TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),child: Text('OK'),),
          ],
        ));
  }

  Future<void> sendNotificationAction(UserDataModel userData, BuildContext context) async {
    await _db.reportInfection(userData.firstName + ' ' + userData.lastName,
        dateToCompare, true, dataSet.toList(), userData.uid);
    final response = await NotificationService.sendTo(
        title: titleOfWaring, body: bodyOfWaring, fcmTokens: usersToNotify);
    _showSnackBar(response.statusCode);
  }

  void _showSnackBar(int code){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: code == 200 ? Text(unsuccessfulSent) : Text(successfulSent),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () { },
      ),
    ));
  }
}

