import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
        body: SafeArea(child:
        Center(
          child: Column(
            children: [
              ElevatedButton(child: Text('Report'),
                onPressed: () async{
                Timestamp dateToCompare = Timestamp.fromDate(DateTime.parse('2021-08-16 00:00:00.000'));
                var result = await db.collection('meetings').where('participantsId',arrayContains: userData.uid).where('date', isGreaterThan: dateToCompare).get();
                  // var result = await db.collection('meetings').where('teacherName',isEqualTo: "Maciek Last").get();
                  Set<String> dataSet = {};
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
                  print('data set is: $dataSet');
                  print('Docs returned: $counter');
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
