import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingDataModel {
  String classroom;
  Timestamp date;
  String teacherID;
  String teacherName;
  String title;
  bool isActive;
  List<dynamic> participants;
  List<dynamic> participantsId;

  MeetingDataModel(
      {this.classroom, this.date, this.teacherID, this.title, this.participants,this.participantsId ,this.teacherName, this.isActive});

  factory MeetingDataModel.fromMap(Map data) {
    return MeetingDataModel(
        classroom: data['classroom'] ?? '',
        date: data['date'] ?? '',
        teacherID: data['teacherID'] ?? '',
        title: data['title'] ?? 'user',
        participants: data['participants'] ?? '',
        participantsId: data['participantsId'] ?? '',
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

//   Map<String, dynamic> participantsList(String participantUID, String userName, String fcmToken){
//       return {
//         'participants': FieldValue.arrayUnion([
//           {
//             'UID': participantUID,
//             'UserName': userName,
//             'FcmToken': fcmToken
//           }
//         ])
//       };
//   }
// }
  Map<String, dynamic> participantsList(String fcmToken,
      String userName) {
    return {
      'participants': FieldValue.arrayUnion([
        {
          'fcmToken': fcmToken,
          'UserName': userName,
        }
      ])
    };
  }

  Map<String, dynamic> participantsIdList(String uid) {
    return {
      'participantsId': FieldValue.arrayUnion([uid])
    };
  }
}
class ParticipantsDataModel {
  final String fcmToken;
  final String userName;

  ParticipantsDataModel({this.fcmToken, this.userName});
}