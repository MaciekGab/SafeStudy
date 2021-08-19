import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';

class ReportInfectionPage extends StatelessWidget {
  const ReportInfectionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    var db = FirebaseFirestore.instance;
    Set<String> dataSet = {};
    return Scaffold(
        body: SafeArea(child:
        Center(
          child: Column(
            children: [
              ElevatedButton(child: Text('Report'),
                onPressed: () async{
                Timestamp dateToCompare = Timestamp.fromDate(DateTime.parse('2021-08-09 00:00:00.000'));
                var result = await db.collection('meetings').where('participantsId',arrayContains: userData.uid).where('date', isGreaterThan: dateToCompare).get();
                  // var result = await db.collection('meetings').where('teacherName',isEqualTo: "Maciek Last").get();
                  int counter = 0;
                  print(result.docs[0]['date']);
                  print(dateToCompare);
                  result.docs.forEach((element) {
                    print("title = ${element['title']}");
                    List<ParticipantsDataModel> names = List<ParticipantsDataModel>.from(element['participants'].map((item) {
                      return new ParticipantsDataModel(
                          fcmToken: item['fcmToken'],
                          userName: item['UserName']); }));
                    for(int i = 0; i < names.length; i++){
                      // print(names[i].fcmToken);
                      dataSet.add(names[i].fcmToken);
                    }
                    counter++;
                    // print(element['participants']);
                  });
                  List<String> testMap;
                  testMap = dataSet.toList();
                  print('data set is: $dataSet');
                  print('data set as list is: $testMap');
                  int value = testMap.length;
                  print('Length of list to send notification: $value');
                  print('Docs returned: $counter');

                  String fcmUserToken = await FirebaseMessaging.instance.getToken();
                  dataSet.remove(fcmUserToken);
                print('data set without userToken: $dataSet');

                await FirebaseFirestore.instance.collection('reports').add(
                      {
                        'reporterName': userData.firstName + ' ' + userData.lastName,
                        //TODO: change date to actual date not hardcoded value
                        'dateOfInfection': dateToCompare,
                        'reportDate': DateTime.now(),
                        //TODO: change hardcoded value to boolean from sending notification
                        'isNotificationSent': true,
                        // 'participants': FieldValue.arrayUnion([userData.uid]),
                        'peopleToNotify': dataSet.toList(),
                        'reporterId': userData.uid,
                      }
                  );
                  }
              ),
              // Text('QR value: '+ _qrCodeData)
            ],
          ),
        ),

        )
    );
  }
}
