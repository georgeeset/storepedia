import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  AuthenticationService() {
    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
  }

  late FirebaseAuth _auth;
  User? user;

  Future<UserCredential> signinWithEmail(
      {required String email, required String password}) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }
}
