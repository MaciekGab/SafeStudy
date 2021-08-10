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
  // Future<String> joinMeeting(String uid,String userId ,String userName) async{
  //   await _db.collection('meetings').doc(uid).update(' participants': FieldValue.arrayUnion([{'UID': userId,'UserName': userName}]));
  //   return 'User data has been updated.';
  // }

  // Future<UserDataModel> getUserDataForAdmin(String email){
  //   var temp = _db.collection('profiles').where('email', isEqualTo: email).snapshots();
  //   var temp2 = temp.map((event) => UserDataModel.fromFirestore(doc));
  //   var temp3 = temp2.map((doc) => UserDataModel.fromFirestore(doc));
  // }

  Stream<List<UserDataModel>> getUsers(String email) {
    return _db.collection('profiles').where('email',isEqualTo: email).snapshots().map((list) => list.docs.map((doc) =>  UserDataModel.fromFirestore(doc)));
  }
  Future<UserDataModel> getUsersData(String email) async{
    var ref =  await _db.collection('profiles').where('email',isEqualTo: email).get();
    return UserDataModel.fromMap(ref.docs[0].data());
  }


  // Future<UserDataModel> getUserData(String email) async{
  //   QuerySnapshot snap = _db.collection('profiles').where('email',isEqualTo: email).get();
  //   snap.doc
  // }
}