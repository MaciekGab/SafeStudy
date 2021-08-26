import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:intl/intl.dart';
import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';

class CreatePdfFile {
  final MeetingDataModel meeting;

  CreatePdfFile({this.meeting});

  Future<File> generate() async{
    String fileName;
    Timestamp dateToParse = meeting.date;
    DateTime date = dateToParse.toDate();
    DateFormat fileNameFormat = DateFormat('dd-MM-yyyy_HH-mm');
    DateFormat hourOfMeeting = DateFormat('HH:mm');
    DateFormat dateOfMeeting = DateFormat('EEEE, MMMM d, yyyy');
    String formattedFileName = fileNameFormat.format(date);
    String formattedHourOfMeeting = hourOfMeeting.format(date);
    String formattedDateOfMeeting = dateOfMeeting.format(date);
    fileName = meeting.title + '_' +formattedFileName;
    final document = Document();

    document.addPage(MultiPage(
        build: (context) => [
          createMeetingDetails(title: meeting.title,date: formattedDateOfMeeting, hour: formattedHourOfMeeting, classroom: meeting.classroom, teacherName: meeting.teacherName),
          createAttendanceList(attendanceList: meeting.participants)
        ],
    ));
    return saveDocument(name: fileName, document: document);
  }

  Future<File> saveDocument({String name, Document document}) async{
    final bytes = await document.save();
    final dir = await getApplicationDocumentsDirectory();
    print(dir.path);
    final file = File('${dir.path}/$name.pdf');

    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> openFile(File file) async{
    final path = file.path;

    await OpenFile.open(path);
  }

  static Widget createTitle({String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 0.8 * PdfPageFormat.cm,)
      ],
    );
  }

  static Widget createAttendanceList({List<ParticipantsDataModel> attendanceList}) {
    List<ParticipantsDataModel> names = List<ParticipantsDataModel>.from(attendanceList);
    names.removeAt(0);
    final headers = [
      'Attendance List'
    ];
    final data = names.map((e) {
      return[
        e.userName
      ];
    }).toList();
    return Table.fromTextArray(
      headers: headers,
      data: data,
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      // cellHeight: 10,
      cellAlignment: Alignment.center
    );
  }

  static Widget createMeetingDetails({String title, String date, String hour ,String classroom, String teacherName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Text('Title: $title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Teacher: $teacherName', style: TextStyle(fontSize: 18)),
            Text(date, style: TextStyle(fontSize: 18))
          ]
        ),
        SizedBox(height: 0.25 * PdfPageFormat.cm),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Classroom: $classroom', style: TextStyle(fontSize: 18)),
              Text(hour, style: TextStyle(fontSize: 18))
            ]
        ),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
      ]
    );

  }
}