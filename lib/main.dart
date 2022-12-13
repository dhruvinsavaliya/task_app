import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:task_app/utils/shared_pref_utils.dart';
import 'package:task_app/view/create_task.dart';
import 'package:task_app/view/home_screen.dart';
import 'package:task_app/view/login_screen.dart';
import 'package:task_app/view/update_task_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? isLogin;

  @override
  void initState() {
    isLogin = SharedPreferenceUtils.getIsLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('===ISLOGIN===${SharedPreferenceUtils.getIsLogin()}');
    log('===Token===${SharedPreferenceUtils.getToken()}');
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: isLogin!.isEmpty ? LoginScreen() : HomeScreen(),
        );
      },
    );
  }
}

///isLogin!.isEmpty ? LoginScreen() : HomeScreen()
