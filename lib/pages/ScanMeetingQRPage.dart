import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';
import 'package:test_auth_with_rolebased_ui/pages/JoinMeetingPage.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';

class ScanMeetingQRPage  extends StatefulWidget {
  @override
  _ScanMeetingQRPageState createState() => _ScanMeetingQRPageState();
}

class _ScanMeetingQRPageState extends State<ScanMeetingQRPage> {
  final db = DatabaseService();
  String _qrCodeData = '';

  Future<void> scanCode() async {
    await FlutterBarcodeScanner.scanBarcode('#000000', 'Cancel', false, ScanMode.QR).then((value) => setState(() => _qrCodeData = value));
  }


  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return  Scaffold(
        body: SafeArea(child:
        Center(
          child: Column(
            children: [
              ElevatedButton(child: Text('Scan'),
                onPressed: () async {
                  await scanCode();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserDataModel>.value(
                      value: db.streamUserData(user.uid),
                      child: JoinMeetingPage(meetingID: _qrCodeData))));
                },
              ),
              // Text('QR value: '+ _qrCodeData)
            ],
          ),
        ),

        )
    );
  }
}
