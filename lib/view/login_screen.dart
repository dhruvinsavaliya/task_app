// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:task_app/view/signup_screen.dart';

import '../utils/shared_pref_utils.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isProgress = false;
  bool isVisible = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.cyanAccent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 8,
                      ),
                      Text(
                        'Log In',
                        style: GoogleFonts.pacifico(
                            wordSpacing: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.w),
                      ),
                      SizedBox(height: 15.w),
                      TextFormField(
                        controller: usernameController,
                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'invalid data';
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
                      SizedBox(height: 5.w),
                      TextFormField(
                        controller: passwordController,
                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'invalid data';
                          }
                        },
                        obscureText: isVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: Icon(isVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
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
                            String msg = await isLogin(
                                username: usernameController.text,
                                password: passwordController.text);

                            if (msg == 'Successfully LogIn') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(msg)))
                                  .closed
                                  .then(
                                    (value) => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(),
                                      ),
                                    ),
                                  );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(msg)));
                            }
                          }
                        },
                        child: Container(
                          height: 15.w,
                          width: 50.w,
                          decoration:
                              const BoxDecoration(color: Colors.black12),
                          child: Center(
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                  fontSize: 5.w, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Text('Already have an Account? '),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: const Text('SignUp')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isProgress == false
                  ? const SizedBox()
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
            ],
          ),
        ));
  }

  isLogin({required String? username, required String? password}) async {
    setState(() {
      isProgress = true;
    });

    Map<String, dynamic> reqBody = {'username': username, 'password': password};

    http.Response response = await http.post(
        Uri.parse('http://tasks-demo.herokuapp.com/api/auth/signin'),
        body: reqBody);

    var result = jsonDecode(response.body);

    setState(() {
      isProgress = false;
    });

    if (response.statusCode == 200) {
      await SharedPreferenceUtils.setIsLogin('isLogin');
      await SharedPreferenceUtils.setToken(result['accessToken']);

      return 'Successfully LogIn';
    } else if (response.statusCode == 401) {
      return result['message'];
    } else {
      return result['message'];
    }
  }
}
