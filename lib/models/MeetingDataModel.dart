import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingDataModel {
  String classroom;
  String date;
  String teacherID;
  String teacherName;
  String title;
  bool isActive;
  List<ParticipantsDataModel> participants;

  MeetingDataModel({this.classroom, this.date, this.teacherID, this.title, this.participants,this.teacherName,this.isActive});

  factory MeetingDataModel.fromMap(Map data) {
    return MeetingDataModel(
        classroom: data['classroom'] ?? '',
        date: data['date'] ?? '',
        teacherID: data['teacherID'] ?? '',
        title: data['title'] ?? 'user',
        participants: data['participants'] ?? '',
        teacherName: data['teacherName'] ?? '',
        isActive: data['isActive'] ?? ''
    );
  }

  factory MeetingDataModel.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data();

    return MeetingDataModel(
        classroom: data['classroom'] ?? '',
        date: data['date'] ?? '',
        teacherID: data['teacherID'] ?? '',
        title: data['title'] ?? 'user',
        participants: data['participants'] ?? '',
        teacherName: data['teacherName'] ?? '',
        isActive: data['isActive'] ?? ''
    );
  }

  Map<String, dynamic> participantsList(String participantUID, String userName){
      return {
        'participants': FieldValue.arrayUnion([
          {
            'UID': participantUID,
            'UserName': userName
          }
        ])
      };
  }
}

class ParticipantsDataModel {
  final String uid;
  final String userName;

  ParticipantsDataModel({this.uid, this.userName});
}