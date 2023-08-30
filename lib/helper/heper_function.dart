import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
  //key
  static String userLoggedInKey="LOGGEDINKEY";
  static String userNameKey="USERNAMEKEY";
  static String userEmailKey="USEREMAILKEY";

  // saving data to sf
  static Future<bool>saveUserLoggedInStatus(bool isUserLoggedIn)async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }
  static Future<bool>saveUserNameSF(String userNmae)async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userNmae);
  }
  static Future<bool>saveUserEmailSF(String userEmail)async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  // get data from sf
  static Future<bool?> getUserLoggedInStatus() async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
  static Future<String?> getUserEmailFromSF() async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }
  static Future<String?> getUserNameFromSF() async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}