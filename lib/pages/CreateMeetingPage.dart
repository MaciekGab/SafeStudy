import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/utils/Utils.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';
import 'package:test_auth_with_rolebased_ui/widgets/MyInput.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedElevatedButton.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedText.dart';
import 'ShowMeetingQRPage.dart';

class CreateMeetingPage extends StatefulWidget {
  const CreateMeetingPage({Key key}) : super(key: key);

  @override
  _CreateMeetingPageState createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _meetingTitleController = TextEditingController();
  final TextEditingController _classroomNameController = TextEditingController();
  var _db = DatabaseService();
  String classroom,title,result;
  DateTime date = DateTime.now();
  bool isMeetingNotCreated = true;
  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserDataModel>(context);
    final size = MediaQuery.of(context).size;
    return  SafeArea(
        child: Scaffold(
            appBar: GradientAppBar(
              title: Text('Create Meeting'),
            ),
            body: Center(
                    child: Visibility(
                      visible: isMeetingNotCreated,
                      replacement:Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RoundedText(text: 'Show QR', roundedSide: 'right', width: 0.8*size.width, height: 0.1*size.height, alignment: Alignment.centerLeft),
                            RoundedElevatedButton(child: Text('Show Meeting QR'), onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      ShowMeetingQRPage(meetingID: result)));
                            }, alignment: Alignment.center, smallButton: false, icon: Icons.qr_code_rounded,width: 0.7* size.width,height: 0.1*size.height,),
                            SizedBox(height: 0.01*size.height,),
                            SizedBox(height: 0.01*size.height,)
                            // Text('QR value: '+ _qrCodeData)
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RoundedText(text: 'Meeting data', roundedSide: 'right', width: 0.8*size.width,height: 0.1*size.height ,alignment: Alignment.centerLeft),
                          Form(
                            key: _formKey,
                            child: Column(children: [
                              SizedBox(height: 10.0),
                              MyInput(
                                  controller: _meetingTitleController,
                                  hintText: "Title",
                                  multiValidator: MultiValidator([
                                    RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                                  ])
                              ),
                              SizedBox(height: 0.01*size.height,),
                              RoundedElevatedButton(onPressed: () async{
                                await pickDateAndTime(context, date).then((value) {setState(() {
                                  date = value;
                                });});
                              },child: Text(DateFormat('dd-MM-yyyy HH:mm').format(date)),icon: Icons.calendar_today_rounded,smallButton: false,alignment: Alignment.center,),
                              SizedBox(height: 0.01*size.height,),
                              MyInput(
                                controller: _classroomNameController,
                                hintText: "Classroom",
                                multiValidator: MultiValidator([RequiredValidator(errorText: returnValidationError(ValidationError.isRequired))]),
                              ),
                              SizedBox(height: 0.01*size.height,),
                              RoundedElevatedButton(onPressed: () async{
                                await _createMeetingAction(userData, context);
                              },child: Text(' Create '),icon: Icons.check,smallButton: true,alignment: Alignment.centerRight,),
                            ]
                            ),
                          ),
                        ],
                      ),
                    ),
                )
            )
    );
  }

  Future<void> _createMeetingAction(UserDataModel userData, BuildContext context) async {
     if (_formKey.currentState.validate()) {
      classroom = _classroomNameController.text.trim();
      title = _meetingTitleController.text.trim();
      String teacherName = userData.firstName + ' ' + userData.lastName;
      String fcmToken =  await FirebaseMessaging.instance.getToken();

      result = await _db.createMeeting(classroom,date,title,fcmToken,teacherName,userData.uid,true);
      await _db.updatePastMeetings(userData.uid, result, title, date, classroom, teacherName);
      setState(() =>isMeetingNotCreated = false);
      _showSnackBar(context, meetingCreated);
    }
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(meetingCreated),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () { },
      ),
    ));
  }
}

