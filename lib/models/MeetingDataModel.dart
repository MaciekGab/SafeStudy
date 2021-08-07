import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingDataModel {
  String classroom;
  String date;
  String teacherID;
  String title;
  List participants;

  MeetingDataModel({this.classroom, this.date, this.teacherID, this.title, this.participants});

  factory MeetingDataModel.fromMap(Map data) {
    return MeetingDataModel(
        classroom: data['classroom'] ?? '',
        date: data['date'] ?? '',
        teacherID: data['teacherID'] ?? '',
        title: data['title'] ?? 'user',
        participants: data['participants'] ?? ''
    );
  }

  factory MeetingDataModel.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data();

    return MeetingDataModel(
        classroom: data['classroom'] ?? '',
        date: data['date'] ?? '',
        teacherID: data['teacherID'] ?? '',
        title: data['title'] ?? 'user',
        participants: data['participants'] ?? ''
    );
  }

  Map<String, dynamic> participantsList(String participantUID){
      return {
        'participants': FieldValue.arrayUnion([
          {
            "participantUID": participantUID
          }
        ])
      };
  }
}