import 'package:chat_app_new_version/helper/heper_function.dart';
import 'package:chat_app_new_version/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // log out
   Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user=(await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password)).user!;
          if(user!= null){
            return true;
          }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future registerUserWithEmailandPassword(
      String username, String email, String password) async {
    try {
      User user=(await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password)).user!;
          if(user!= null){
            // all our database service to update the user data.
            await DatabaseService(uid: user.uid).savingUserData(username, email);
            return true;
          }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  // Log out
  Future signOut()async{
    try{
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await HelperFunction.saveUserNameSF("");
      await firebaseAuth.signOut();
    }catch(e){
      return null;
    }
  }
} 
