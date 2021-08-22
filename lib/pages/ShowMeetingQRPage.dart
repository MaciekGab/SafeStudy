import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowMeetingQRPage extends StatelessWidget {
  final String meetingID;
  // const ShowMeetingQR( , {Key key}) : super(key: key);
  ShowMeetingQRPage({Key key, @required this.meetingID}) : super(key: key);
  var _db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          Center(
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
              size: 200.0,
            ),
          ),
          SizedBox(height: 20,),
      TextButton(
        onPressed: () => showDialog<String>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Do you want to close the meeting?'),
            content: Text('Click YES to close'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'NO'),
                child: Text('NO'),
              ),
              TextButton(
                onPressed: () async {
                  await _db.collection('meetings').doc(meetingID).update({'isActive': false});
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                // async {
                //   await
                // },
                child: Text('YES'),
              ),
            ],
          ),
        ),
        child: Text('Close meeting'),
      )
        ],
      ),
      ),
    );
  }
}
