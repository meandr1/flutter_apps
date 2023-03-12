

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lang_log_b/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService{
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<LLUser> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _fAuth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user-id', user.uid);
      await prefs.setString('user-email', user.email);
      return LLUser.fromFirebase(user);
    } catch(error){
      print(error);
      return null;
    }
  }

  Future<LLUser> registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user-id', user.uid);
      await prefs.setString('user-email', user.email);
      return LLUser.fromFirebase(user);
    } catch(error){
      print(error);
      return null;
    }
  }

  void resetPasswordWithEmail(String email) async {
    try{
      await _fAuth.sendPasswordResetEmail(email: email);
    } catch(error){
      print(error);
      return null;
    }
  }

  Future logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user-id');
    await prefs.remove('user-email');
    await prefs.remove('isPremium');
    await _fAuth.signOut();
  }

  Stream<LLUser> get currentUser{
    return _fAuth.authStateChanges().map((User user) => user != null ? LLUser.fromFirebase(user) : null);
  }

}