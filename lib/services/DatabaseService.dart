import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_auth_with_rolebased_ui/models/UserDataModel.dart';

class DatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<UserDataModel> streamUserData(String id){
    return _db.collection('profiles').doc(id).snapshots().map((doc) => UserDataModel.fromFirestore(doc));
  }
}