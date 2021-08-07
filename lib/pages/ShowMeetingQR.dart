import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowMeetingQR extends StatelessWidget {
  final String meetingID;
  // const ShowMeetingQR( , {Key key}) : super(key: key);
  ShowMeetingQR({Key key, @required this.meetingID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(
        child: QrImage(
          data: meetingID,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
      ),
    );
  }
}
