import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';
import 'package:test_auth_with_rolebased_ui/services/CreatePdfFileService.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';
import 'package:test_auth_with_rolebased_ui/widgets/ListContainer.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedElevatedButton.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedText.dart';

class MeetingDetailPage extends StatelessWidget {
  final MeetingDataModel meeting;
  const MeetingDetailPage({Key key, @required this.meeting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    List<ParticipantsDataModel> names = List<ParticipantsDataModel>.from(meeting.participants);
    names.removeAt(0);
    Timestamp dateToParse = meeting.date;
    DateTime date = dateToParse.toDate();
    CreatePdfFile createPdfFile = CreatePdfFile(meeting: meeting);
    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(
        title: Text('Meeting Detail'),
      ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedText(text: 'Details', roundedSide: 'right', width: 0.5*size.width, height: 0.1*size.height, alignment: Alignment.centerLeft),
                    RoundedElevatedButton(child: Text(' Generate '), onPressed: () async{
                      final createdFile = await createPdfFile.generate();

                      createPdfFile.openFile(createdFile);
                    }, alignment: Alignment.centerRight, smallButton: true, icon: Icons.picture_as_pdf_rounded)
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: ListContainer(child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left:15.0,top:15.0),
                        child: Row(
                          children: [
                          Text('Title: ',style: TextStyle(color: theme.colorScheme.primary),),
                          Text(meeting.title),
                        ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:15.0,top:15.0, right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('Time: ',style: TextStyle(color: theme.colorScheme.primary),),
                                Text(DateFormat('HH:mm').format(date)),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Date: ',style: TextStyle(color: theme.colorScheme.primary),),
                                Text(DateFormat('dd.MM.yyyy').format(date)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:15.0,top:15.0),
                        child: Row(
                          children: [
                            Text('Teacher: ',style: TextStyle(color: theme.colorScheme.primary),),
                            Text(meeting.teacherName),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:15.0,top:15.0),
                        child: Row(
                          children: [
                            Text('Classroom: ',style: TextStyle(color: theme.colorScheme.primary),),
                            Text(meeting.classroom),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:15.0,top:15.0),
                        child: Row(
                          children: [
                            Text('Attendance list: ',style: TextStyle(color: theme.colorScheme.primary),),
                          ],
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: names.length,
                          itemBuilder: (_,index) {
                            return
                              Padding(
                                padding: EdgeInsets.only(left:15.0,top:15.0),
                                child: Row(
                                  children: [
                                    Text('${index + 1}) '),
                                    Text(names[index].userName),
                                  ],
                                ),
                              );
                          }),
                      SizedBox(height: 10,),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}