import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingDataModel {
  String classroom;
  Timestamp date;
  String teacherID;
  String teacherName;
  String title;
  bool isActive;
  List<ParticipantsDataModel> participants;
  List<ParticipantsIdDataModel> participantsId;

  MeetingDataModel(
      {this.classroom, this.date, this.teacherID, this.title, this.participants,this.participantsId ,this.teacherName, this.isActive});

  factory MeetingDataModel.fromMap(Map data) {
    return MeetingDataModel(
        classroom: data['classroom'] ?? '',
        date: data['date'] ?? '',
        teacherID: data['teacherID'] ?? '',
        title: data['title'] ?? 'user',
        participants: List<ParticipantsDataModel>.from(data['participants'].map((item) => ParticipantsDataModel( fcmToken: item['fcmToken'], userName: item['UserName']))) ?? '',
        participantsId: List<ParticipantsIdDataModel>.from(data['participantsId'].map((item) => ParticipantsIdDataModel(uid: item))) ?? '',
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
        participants: List<ParticipantsDataModel>.from(data['participants'].map((item) => ParticipantsDataModel( fcmToken: item['fcmToken'], userName: item['UserName']))) ?? '',
        participantsId: List<ParticipantsIdDataModel>.from(data['participantsId'].map((item) => ParticipantsIdDataModel(uid: item))) ?? '',
        teacherName: data['teacherName'] ?? '',
        isActive: data['isActive'] ?? ''
    );
  }

  Map<String, dynamic> joinMeeting(String fcmToken,String userName, String uid){
    return {
      'participants': FieldValue.arrayUnion([
        {
          'fcmToken': fcmToken,
          'UserName': userName,
        }
      ]),
      'participantsId': FieldValue.arrayUnion([uid])
    };
  }
}

class ParticipantsDataModel {
  final String fcmToken;
  final String userName;

  ParticipantsDataModel({this.fcmToken, this.userName});
}

class ParticipantsIdDataModel{
  final String uid;

  ParticipantsIdDataModel({this.uid});
}