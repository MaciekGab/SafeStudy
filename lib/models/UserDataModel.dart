import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String uid;

  UserDataModel({this.firstName, this.lastName, this.email, this.role, this.uid});

  factory UserDataModel.fromMap(Map data) {
    return UserDataModel(
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      uid: data['uid'] ?? ''
    );
  }

  factory UserDataModel.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data();

    return UserDataModel(
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        role: data['role'] ?? 'user',
        uid: data['uid'] ?? ''
    );
  }
}