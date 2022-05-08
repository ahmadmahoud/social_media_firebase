import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InternetConnectionPage extends StatelessWidget {
  const InternetConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/no_internet_2.json'),
          ],
        ),
      ),
    );
  }
}