import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../helper/heper_function.dart';
import '../screen/homescreen_app.dart';
import '../screen/login.dart';
import '../widget/widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isSignIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
    
    Timer(
      const Duration(seconds: 3), () {
        changeScreen(context, _isSignIn ? const HomeScreen():const LoginScreen(),);
      },
    );
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(image: AssetImage('assets/icons/ai.png'), width: 250),
            SizedBox(height: 200,),
            Center(
              child: SpinKitThreeBounce(
                size: 50.0,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: index.isEven
                          ? Color.fromARGB(255, 15, 131, 53)
                          : Color.fromARGB(255, 14, 137, 53),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
