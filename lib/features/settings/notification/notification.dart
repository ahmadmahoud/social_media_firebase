import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:social_firebase/core/constants.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(onPressed: (){
              FirebaseMessaging.instance.subscribeToTopic('AM');
              showToast(message: 'subscribed', toastStates: ToastStates.SUCCESS);
            }, child: const Text('Suscribe AM',style: TextStyle(color: Colors.blue),),style: OutlinedButton.styleFrom(
              side: const BorderSide(width: 1.0, color: Colors.blue),
            ),),
            space10Horizontal,
            OutlinedButton(onPressed: (){
              FirebaseMessaging.instance.unsubscribeFromTopic('AM');
              showToast(message: 'Un subscribed', toastStates: ToastStates.SUCCESS);
            }, child: const Text('unSuscribe AM',style: TextStyle(color: Colors.blue)),style: OutlinedButton.styleFrom(
              side: const BorderSide(width: 1.0, color: Colors.blue),
            ),),
          ],
        ),
      ),
    );
  }
}
