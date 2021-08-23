import 'package:cloud_firestore/cloud_firestore.dart';

class PastMeetingDataModel {
  final String classroom;
  final Timestamp date;
  final String teacherName;
  final String title;

  PastMeetingDataModel({this.classroom, this.date, this.teacherName, this.title});

  factory PastMeetingDataModel.fromMap(Map data) {
    return PastMeetingDataModel(
        classroom: data['classroom'] ?? '',
        date: data['date'] ?? '',
        title: data['title'] ?? 'user',
        teacherName: data['teacherName'] ?? '',
    );
  }

  factory PastMeetingDataModel.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data();

    return PastMeetingDataModel(
        classroom: data['classroom'] ?? '',
        date: data['date'] ?? '',
        title: data['title'] ?? 'user',
        teacherName: data['teacherName'] ?? '',
    );
  }
}