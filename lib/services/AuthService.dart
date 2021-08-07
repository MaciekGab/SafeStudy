import 'package:firebase_auth/firebase_auth.dart';
import 'DatabaseService.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  //zwraca User lub null
  Stream<User> get authStateChanges => _auth.authStateChanges();

  //sign in in anon
  Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign in  with email & password
  Future<String> signIn({String email, String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "signed-in";
    } on FirebaseAuthException catch (e) {
      print(e.message + ' with error code : ${e.code}');
      return e.code;
    }
  }

//register with email, password <- for Firebase Authentication; name and surname <- for Firestore document
  Future<String> signUp(
      {String email, String password, String firstName, String lastName}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await DatabaseService().updateUserData(
          firstName, lastName, 'user', email, result.user.uid);
      return "signed-up";
    } on FirebaseAuthException catch (e) {
      print(e.message + ' with error code : ${e.code}');
      return e.code;
    }
  }

//sing out
  Future<void> singOut() async {
    await _auth.signOut();
  }

  Future<void> reloadData() async {
    await _auth.currentUser.reload();
  }
// it delete user from Auth in firebase :/
}
