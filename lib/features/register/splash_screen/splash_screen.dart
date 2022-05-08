import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_firebase/core/widget/main_scaffold.dart';
import 'package:social_firebase/features/home/page/homePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                const HomeScreen()
            )
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      scaffold: Scaffold(
        appBar: AppBar(),
        body: Center(
        child: Lottie.asset('assets/images/success_login.json',),
        ),
      ),
    );
  }
}
