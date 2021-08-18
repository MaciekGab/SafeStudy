import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/Utils.dart';
import 'ShowMeetingQRPage.dart';

class CreateMeetingPage extends StatefulWidget {
  const CreateMeetingPage({Key key}) : super(key: key);

  @override
  _CreateMeetingPageState createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _meetingTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _classroomNameController = TextEditingController();
  DocumentReference<Map<String, dynamic>> result;
  String classroom,title,date;
  bool isNotMeetingCreated = true;
  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    return  Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(
                  children: [
                    Visibility(
                      visible: isNotMeetingCreated,
                      replacement:
                      ElevatedButton(onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                ShowMeetingQRPage(meetingID: result.id)));
                      }, child: Text('Show QR')),
                      child: Form(
                        key: _formKey,
                        child: Column(children: [
                          Text('Stwórz spotkanie'),
                          SizedBox(height: 10.0),
                          TextFormField(
                              controller: _meetingTitleController,
                              decoration: InputDecoration(hintText: "Nazwa spotkania"),
                              validator: MultiValidator([
                                RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                              ])
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _dateController,
                            decoration: InputDecoration(hintText: "Data"),
                            validator: MultiValidator([
                              RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                            ]),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _classroomNameController,
                            decoration: InputDecoration(hintText: "Sala"),
                            validator: RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  classroom = _classroomNameController.text.trim();
                                  title = _meetingTitleController.text.trim();
                                  date = _dateController.text.trim();
                                  String fcmToken =  await FirebaseMessaging.instance.getToken();
                                  result = await FirebaseFirestore.instance.collection('meetings').add(
                                      {
                                        'classroom': classroom,
                                        'date': DateTime.now(),
                                        'title': title,
                                        // 'participants': FieldValue.arrayUnion([userData.uid]),
                                        'participants': FieldValue.arrayUnion([{
                                          'fcmToken': fcmToken,
                                          'UserName': userData.firstName + ' ' + userData.lastName
                                        }]),
                                        'participantsId': FieldValue.arrayUnion([userData.uid]),
                                        'teacherID': userData.uid,
                                        'isActive': true,
                                        'teacherName': userData.firstName + ' ' + userData.lastName
                                      }
                                  );
                                  await FirebaseFirestore.instance.collection('profiles').doc(userData.uid).collection('pastMeetings').doc(result.id).set({'title': title, 'date': date, 'classroom': classroom, 'teacherName': userData.firstName + ' '+ userData.lastName});
                                  setState(() {
                                    isNotMeetingCreated = false;
                                  });
                                  print(result.id);

                                }
                                else {
                                  print('Error');
                                }
                              },
                              child: Text('Create meeting')),

                        ]

                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    // if(isMeetingCreated) ...{
                    //   ElevatedButton(onPressed: () {
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context) =>
                    //             ShowMeetingQR(meetingID: result.id)));
                    //   }, child: Text('Show QR'))
                    // }
                  ],
                )

            )
        )
    );
  }
}

