import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';

class DatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<UserDataModel> streamUserData(String id){
    return _db.collection('profiles').doc(id).snapshots().map((doc) => UserDataModel.fromFirestore(doc));
  }
  Stream<MeetingDataModel> streamMeetingData(String id){
    return _db.collection('meetings').doc(id).snapshots().map((doc) => MeetingDataModel.fromFirestore(doc));
  }
  Future<String> updateUserData(String firstName, String lastName, String role, String email, String uid) async{
    await _db.collection('profiles').doc(uid).set({'firstName': firstName, 'lastName': lastName, 'email': email, 'role': role, 'uid': uid});
    return 'User data has been updated.';
  }
  Stream<List<UserDataModel>> getUsers(String email) {
    return _db.collection('profiles').where('email',isEqualTo: email).snapshots().map((list) => list.docs.map((doc) =>  UserDataModel.fromFirestore(doc)));
  }
  Future<UserDataModel> getUsersData(String email) async{
    var ref =  await _db.collection('profiles').where('email',isEqualTo: email).get();
    return UserDataModel.fromMap(ref.docs[0].data());
  }
  Future<void> editUserData(String uid, String role, String firstName, String lastName) async{
    await _db.collection('profiles').doc(uid).update({'role': role, 'firstName': firstName, 'lastName': lastName,});
  }
  Future<UserDataModel> getUserByEmail(String userEmail) async{
    UserDataModel resultModel;
    var result = await _db.collection('profiles').where('email', isEqualTo: userEmail).get();
    if(result.size > 0){
      result.docs.forEach((element) => resultModel = UserDataModel.fromFirestore(element));
    }
    return resultModel;
  }
  Future<List<MeetingDataModel>> getMeetings() async {
    List<MeetingDataModel> result = [];
    await _db.collection('meetings').get().then((value) => value.docs.forEach((element) => result.add(MeetingDataModel.fromFirestore(element))));
    return result;
  }
  Future<List<MeetingDataModel>> getMeetingsForTeacher(String uid) async {
    List<MeetingDataModel> result = [];
    await _db.collection('meetings').where('teacherID', isEqualTo: uid).get().then((value) => value.docs.forEach((element) => result.add(MeetingDataModel.fromFirestore(element))));
    return result;
  }
  Future<String> createMeeting(String classroom, DateTime date, String title, String fcmToken, String userName, String uid, bool isActive) async{
    var result = await FirebaseFirestore.instance.collection('meetings').add(
        {
          'classroom': classroom,
          'date': date,
          'title': title,
          'participants': FieldValue.arrayUnion([{
            'fcmToken': fcmToken,
            'UserName': userName
          }]),
          'participantsId': FieldValue.arrayUnion([uid]),
          'teacherID': uid,
          'isActive': isActive,
          'teacherName': userName
        }
    );
    return result.id;
  }
  Future<void> updatePastMeetings(String uid,String docId, String title, DateTime date, String classroom, String teacherName) async{
    await _db.collection('profiles').doc(uid).collection('pastMeetings').doc(docId).set({'title': title, 'date': date, 'classroom': classroom, 'teacherName': teacherName});
  }
  Future<void> closeMeeting(String meetingId)async{
    _db.collection('meetings').doc(meetingId).update({'isActive': false});
  }
  Future<void> joinMeeting(String meetingId, MeetingDataModel meetingDataModel, String messageToken, String name, uid) async{
    await _db.collection('meetings').doc(meetingId).update(meetingDataModel.joinMeeting(messageToken,name,uid));
  }
  Future<void> reportInfection(String reporterName, Timestamp dateToCompare, bool isNotificationSent,List<String> peopleToNotify, String reporterId) async{
    await _db.collection('reports').add(
        {
          'reporterName': reporterName,
          'dateOfInfection': dateToCompare,
          'reportDate': DateTime.now(),
          'isNotificationSent': isNotificationSent,
          'peopleToNotify': peopleToNotify,
          'reporterId': reporterId,
        }
    );
  }
  Future<List<MeetingDataModel>> getMeetingsWithInfectedPerson(String uid, Timestamp dateToCompare) async{
    List<MeetingDataModel> listOfMeetings = [];
    await _db.collection('meetings').where('participantsId',arrayContains: uid).where('date', isGreaterThanOrEqualTo: dateToCompare).get().then((value) => value.docs.forEach((element) {listOfMeetings.add(MeetingDataModel.fromMap(element.data())); }));
    return listOfMeetings;
  }
}