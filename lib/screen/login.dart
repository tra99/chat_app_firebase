import 'package:chat_app_new_version/screen/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widget/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "GIC Chat",
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
                      hintText: "Email",
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
                        hintText: "Password",
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

  login() {}
}
