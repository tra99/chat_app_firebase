import 'package:chat_app_new_version/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // register
  Future registerUserWithEmailandPassword(
      String username, String email, String password) async {
    try {
      User user=(await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password)).user!;
          if(user!= null){
            // all our database service to update the user data.
            await DatabaseService(uid: user.uid).updateUserData(username, email);
            return true;
          }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
