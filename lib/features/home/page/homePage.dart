import 'package:buildcondition/buildcondition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:social_firebase/core/constants.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/core/models/user_data.dart';
import 'package:social_firebase/core/widget/loading.dart';
import 'package:social_firebase/core/widget/main_scaffold.dart';
import 'package:social_firebase/features/home/widget/iconBroken.dart';
import 'package:social_firebase/features/home/widget/text_button.dart';
import 'package:social_firebase/features/new_post/new_post.dart';
import 'package:social_firebase/features/settings/notification/notification.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          navigateTo(
            context,
            const NewPostPage(),
          );
        }
      },
      builder: (context, state) {
        var cubit = MainBloc.get(context);
        return MainScaffold(
          scaffold: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(onPressed: (){
                  navigateTo(context, NotificationPage());
                }, icon: const Icon(IconBroken.Notification,color: Colors.black,size: 28,)),
              ],
              title: Text(cubit.titles[cubit.currentIndex],
              style: Theme.of(context).textTheme.bodyText2,),
              centerTitle: true,
            ),
            body: BuildCondition(
                condition: MainBloc.get(context).userModel != null,
                builder: (_) => cubit.screens[cubit.currentIndex],
                fallback: (_) => const LoadingPage()),
              bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  cubit.changeBottomNav(index);
                },
                items: cubit.bottomItems,
                currentIndex: cubit.currentIndex,
              ),
          ),
        );
      },
    );
  }

  Column buildVerifiedEmail(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/images/error.json',
        ),
        Text(
          'please verified your email',
          style: Theme.of(context).textTheme.headline6,
        ),
        TextButtonCustom(
            text: 'SEND',
            onClick: () {
              FirebaseAuth.instance.currentUser!
                  .sendEmailVerification()
                  .then((value) => {
                        showToast(
                            message: 'send Success',
                            toastStates: ToastStates.SUCCESS),
                      })
                  .catchError((error) {
                showToast(
                    message: error.toString(),
                    toastStates: ToastStates.SUCCESS);
              });
            }),
      ],
    );
  }

}
