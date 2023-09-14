import 'package:chat_app_new_version/chatgpt/providers/chat_provider.dart';
import 'package:chat_app_new_version/chatgpt/providers/models_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_classroom/shared/constant.dart';
import 'chat_classroom/splashscreen/splashscreen.dart';


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

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ModelsProvider()),
        ChangeNotifierProvider(create: (_)=>ChatProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Constants().primaryColor,
          scaffoldBackgroundColor: Colors.white
        ),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: const SplashPage()
        
      ),
    );
  }
}

