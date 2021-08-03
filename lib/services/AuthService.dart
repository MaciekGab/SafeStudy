import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> singIn(String email, String password) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Message IN";
    }on FirebaseAuthException catch (e){
      return e.code;
    }
  }
  Future<String> singUp(String email, String password) async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Message UP";
    }on FirebaseAuthException catch (e){
      return e.code;
    }
  }
}