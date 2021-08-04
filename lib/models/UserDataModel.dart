import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  final String firstName;
  final String lastName;
  final String email;
  final String role;

  UserDataModel({this.firstName, this.lastName, this.email, this.role});

  factory UserDataModel.fromMap(Map data) {
    return UserDataModel(
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user'
    );
  }

  factory UserDataModel.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data();

    return UserDataModel(
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        role: data['role'] ?? 'user'
    );
  }
}