import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';
import '../Utils.dart';
import '../services/NotificationService.dart';

class ReportInfectionPage extends StatefulWidget {
  const ReportInfectionPage({Key key}) : super(key: key);

  @override
  State<ReportInfectionPage> createState() => _ReportInfectionPageState();
}

class _ReportInfectionPageState extends State<ReportInfectionPage> {
  var db = FirebaseFirestore.instance;
  DateTime dateOfInfection = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Set<String> dataSet = {};
  List<String> usersToNotify;
  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    return SafeArea(
        child: Scaffold(
          appBar: GradientAppBar(
            title: Text('Report Infection'),
          ),
          body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async{
                    await pickDate(context, dateOfInfection).then((value) {setState(() {dateOfInfection = value;});});
                  }, child: Text(DateFormat('dd-MM-yyyy').format(dateOfInfection))),
              ElevatedButton(child: Text('Report'),
                onPressed: () async{
                Timestamp dateToCompare = Timestamp.fromDate(dateOfInfection);
                var result = await db.collection('meetings').where('participantsId',arrayContains: userData.uid).where('date', isGreaterThanOrEqualTo: dateToCompare).get();
                if(result.size != 0) {
                  int counter = 0;
                  print(result.docs[0]['date']);
                  print(dateToCompare);
                  result.docs.forEach((element) {
                    print("title = ${element['title']}");
                    List<ParticipantsDataModel> names = List<
                        ParticipantsDataModel>.from(element['participants']
                        .map((item) {
                      return new ParticipantsDataModel(
                          fcmToken: item['fcmToken'],
                          userName: item['UserName']);
                    }));
                    names.forEach((element) {
                      dataSet.add(element.fcmToken);
                    });
                    counter++;
                  });
                  String fcmUserToken = await FirebaseMessaging.instance
                      .getToken();
                  dataSet.remove(fcmUserToken);
                  usersToNotify = dataSet.toList();
                  print('data set is: $dataSet');
                  print('data set as list is: $usersToNotify');
                  int value = usersToNotify.length;
                  print('Length of list to send notification: $value');
                  print('Docs returned: $counter');
                }
                return showDialog<String>(
                    barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('This message will be send to ${dataSet.length} users'),
                    content: Text('Are you sure to send it?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'NO'),
                        child: Text('NO'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance.collection('reports').add(
                              {
                                'reporterName': userData.firstName + ' ' + userData.lastName,
                                'dateOfInfection': dateToCompare,
                                'reportDate': DateTime.now(),
                                'isNotificationSent': true,
                                'peopleToNotify': dataSet.toList(),
                                'reporterId': userData.uid,
                              }
                          );
                          final response = await NotificationService.sendTo(title: titleOfWaring, body: bodyOfWaring, fcmTokens: usersToNotify);
                          print('Notification response code is: ${response.statusCode}');
                          print('Notification response code is: ${response.body}');
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: Text('YES'),
                      ),
                    ],
                  ));
                  }
              ),
              SizedBox(height: 20,),
              // Text('QR value: '+ _qrCodeData)
            ],
          ),
        ),

        )
    );
  }
}

