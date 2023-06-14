import 'package:firebase/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //convert to our user
  // UserLocal? _userFromFirebase(User? user) {
  //   return user != null ? UserLocal(user.uid) : null;
  // }

  Stream<User?> get userStream {
    return _auth.authStateChanges();
  }

  //sigin anon
  Future siginInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      // Handle the signed-in user
      User? user = userCredential.user;
      // Do something with the user object
      //return _userFromFirebase(user);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //sing in with eamil and password
   Future signInWithEmailPassowrd(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailPassowrd(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
