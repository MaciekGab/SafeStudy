import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedElevatedButton.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedText.dart';

class ShowMeetingQRPage extends StatelessWidget {
  final String meetingID;
  // const ShowMeetingQR( , {Key key}) : super(key: key);
  ShowMeetingQRPage({Key key, @required this.meetingID}) : super(key: key);
  var _db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(
          title: Text('Meeting QR'),
        ),
        body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundedText(text: 'Show QR', roundedSide: 'right', width: 0.8*size.width, height: 0.1*size.height ,alignment: Alignment.centerLeft),
            Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.primary,width: 2),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: QrImage(
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: theme.colorScheme.onBackground,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: theme.colorScheme.onBackground,
                  ),
                  data: meetingID,
                  version: QrVersions.auto,
                  size: 0.35 * size.height,
                ),
              ),
            SizedBox(height: 20,),
      RoundedElevatedButton(child: Text(' Close Meeting '), onPressed: () async {
        return await buildShowDialog(context);
      }, alignment: Alignment.centerRight, smallButton: true, icon: Icons.close),
          ],
      ),
        ),
      ),
    );
  }

  buildShowDialog(BuildContext context) async {
    showDialog<String>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
        title: Text('Do you want to close the meeting?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'NO'),
            child: Text('NO'),
          ),
          TextButton(
            onPressed: () async {
              await _db.collection('meetings').doc(meetingID).update({'isActive': false});
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('YES'),
          ),
        ],
      ));
  }
}
