import 'package:chat_app_new_version/helper/heper_function.dart';
import 'package:chat_app_new_version/screen/homepage.dart';
import 'package:chat_app_new_version/screen/login.dart';
import 'package:chat_app_new_version/shared/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isSignIn=false;

  @override
  void initState(){
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async{
    await HelperFunction.getUserLoggedInStatus().then((value){
      if(value!=null){
        _isSignIn=value;
      }
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white
      ),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: _isSignIn ? const HomeScreen():const LoginScreen(),
    );
  }
}

