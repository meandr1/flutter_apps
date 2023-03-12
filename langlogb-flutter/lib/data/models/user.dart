
import 'package:firebase_auth/firebase_auth.dart';

class LLUser {
  String id;
  // bool isPremium;
  User firebaseUser;

  LLUser.fromFirebase(User user){
    id = user.uid;
    firebaseUser = user;
  }
}