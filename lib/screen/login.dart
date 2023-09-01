import 'package:chat_app_new_version/helper/heper_function.dart';
import 'package:chat_app_new_version/screen/register.dart';
import 'package:chat_app_new_version/service/auth.dart';
import 'package:chat_app_new_version/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widget/widget.dart';
import 'homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading=false;
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)):
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "PINK Chat",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 244, 146, 240)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Login now to see what they are talking!",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 244, 146, 240)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset("assets/talking.webp"),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                        print(email);
                      });
                    },
                    validator: (value) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!)
                          ? null
                          : "Please enter a valid email";
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        )),
                    validator: (value) {
                      if (value!.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text('Login',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Color.fromARGB(255,244,146,240), fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Register here",
                            style: const TextStyle(
                              color: Color.fromARGB(255,244,146,240),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              changeScreen(context, const RegisterPage());
                            })
                      ]))
                ],
              )),
        ),
      ),
    );
  }

  login() async{
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot= await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
          // saving the value to shared references
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);
          await HelperFunction.saveUserNameSF(
            snapshot.docs[0]['username']
          );
          changeScreenReplacement(context, const HomeScreen());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
