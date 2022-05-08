import 'dart:io';

import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:social_firebase/core/constants.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/core/widget/main_scaffold.dart';
import 'package:social_firebase/features/register/splash_screen/splash_screen.dart';
import 'package:social_firebase/features/register/wedget/app_button.dart';
import 'package:social_firebase/features/register/wedget/app_text_form_field.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isDisabled = true;
  String btn = 'create account';
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if(state is CreateUserSuccessState) {
          navigateAndFinish(context, const SplashScreen());
          return;
        }
        if (state is Error) {
          print(state.error);
          SnackBar snackBar =
          SnackBar(
            content: Text(state.error),action:
          SnackBarAction(
            label: 'ok',
            onPressed: (){},
          ),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
      },
      builder: (context, state) => MainScaffold(
        scaffold: Scaffold(
          appBar: AppBar(
            title: Text("Register Page" ,style: Theme.of(context).textTheme.headline6,),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  buildProfileImage(),
                  space10Vertical,
                  AppTextFormField(
                    hint: 'username',
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: 'username',
                    callbackHandle: (controller) {
                      usernameController = controller;
                    },
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      enableLoginButton();
                    },
                  ),
                  space10Vertical,
                  AppTextFormField(
                    hint: 'email',
                    icon: const Icon(Icons.email_rounded),
                    label: 'email',
                    callbackHandle: (controller) {
                      emailController = controller;
                    },
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      enableLoginButton();
                    },
                  ),
                  space10Vertical,
                  AppTextFormField(
                    hint: 'phone',
                    icon: const Icon(Icons.phone_android_rounded),
                    label: 'phone',
                    callbackHandle: (controller) {
                      phoneController = controller;
                    },
                    type: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      enableLoginButton();
                    },
                  ),
                  space10Vertical,
                  AppTextFormField(
                    hint: 'password',
                    isPassword: true,
                    label: 'password',
                    callbackHandle: (controller) {
                      passwordController = controller;
                    },
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      enableLoginButton();
                    },
                  ),
                  space10Vertical,
                  AppTextFormField(
                    hint: 'confirm password',
                    isPassword: true,
                    label: 'confirm password',
                    callbackHandle: (controller) {
                      confirmPasswordController = controller;
                    },
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      enableLoginButton();
                    },
                  ),
                  space10Vertical,
                  BuildCondition(
                    condition: state is RegisterLoadingState,
                    builder: (context)=> Container(
                        width: double.infinity,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: HexColor(greyWhite),
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: const CupertinoActivityIndicator(),
                    ),
                    fallback: (context)=> AppButton(
                      onPress: !isDisabled ? () {
                        checkData();
                      } : null,
                      label: btn,

                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void enableLoginButton() {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      isDisabled = false;
      setState(() {});
    } else {
      isDisabled = true;
      setState(() {});
    }
  }

  void checkData() {
    if (passwordController.text != confirmPasswordController.text) {
      SnackBar snackBar =
      SnackBar(
        content: const Text("password and Confirm Password don't match'"),action:
      SnackBarAction(
        label: 'ok',
        onPressed: (){},
      ),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (passwordController.text.length < 6) {
      SnackBar snackBarPass =
      SnackBar(
        content: const Text("password should be at least 6 char"),action:
      SnackBarAction(
        label: 'ok',
        onPressed: (){},
      ),);
      ScaffoldMessenger.of(context).showSnackBar(snackBarPass);
      return;
    }
    MainBloc.get(context).userRegister
      (email: emailController.text,
        password: passwordController.text,
        name: usernameController.text,
        phone: phoneController.text,
        imageFile: File(image!.path));
  }

  buildProfileImage() {
    return InkWell(
      onTap: () async {
        final ImagePicker _picker = ImagePicker();
        image = await _picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      child: image == null
          ? Lottie.asset('assets/images/register.json',
          width: 200,height: 200)
          : Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Image.file(
            File(image!.path),
            fit: BoxFit.fill,
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }

}
