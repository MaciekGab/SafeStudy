import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';
import 'package:test_auth_with_rolebased_ui/widgets/CreatePdfFile.dart';

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
    Timestamp dateToParse = meeting['date'];
    DateTime date = dateToParse.toDate();
    CreatePdfFile createPdfFile = CreatePdfFile(meeting: meeting);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: () async{
                final createdFile = await createPdfFile.generate();

                createPdfFile.openFile(createdFile);
              }, child: Text('Generate PDF')),
              SizedBox(height: 15,),
              Text(meeting['title']),
              SizedBox(height: 10,),
              Text(meeting['teacherName']),
              SizedBox(height: 10,),
              Text(meeting['classroom']),
              SizedBox(height: 10,),
              Text(date.toString()),
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
