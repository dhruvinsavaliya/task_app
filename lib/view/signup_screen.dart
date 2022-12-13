// ignore_for_file: body_might_complete_normally_nullable, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController userController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  bool isPassVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40.w),
                  Text(
                    'Sign Up',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.w),
                  ),
                  SizedBox(height: 10.w),
                  TextFormField(
                    controller: userController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'invalid input!';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Username',
                      prefixIcon: const Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.white70,
                      focusColor: Colors.green,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.w),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'invalid input!';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.white70,
                      focusColor: Colors.green,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.w),
                  TextFormField(
                    controller: passController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'invalid input!';
                      }
                    },
                    obscureText: isPassVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPassVisible = !isPassVisible;
                            });
                          },
                          icon: Icon(isPassVisible
                              ? Icons.visibility_off
                              : Icons.visibility)),
                      filled: true,
                      fillColor: Colors.white70,
                      focusColor: Colors.green,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.w),
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      if (formKey.currentState!.validate()) {
                        String msg = await isSignUp(
                            userName: userController.text,
                            email: emailController.text,
                            password: passController.text);

                        if (msg == 'User was registered successfully!') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(msg)))
                              .closed
                              .then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  )));
                        }
                      }
                    },
                    child: Container(
                      height: 15.w,
                      width: 50.w,
                      decoration: const BoxDecoration(color: Colors.black12),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 5.w, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future isSignUp(
      {required String? userName,
      required String? email,
      required String? password}) async {
    Map<String, dynamic> reqBody = {
      'username': userName,
      'email': email,
      'password': password
    };

    http.Response response = await http.post(
        Uri.parse('http://tasks-demo.herokuapp.com/api/auth/signup'),
        body: reqBody);

    var result = jsonDecode(response.body);
    return result['message'];
  }
}
