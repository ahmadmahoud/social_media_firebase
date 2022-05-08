import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:social_firebase/core/constants.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/core/widget/main_scaffold.dart';
import 'package:social_firebase/features/home/page/homePage.dart';
import 'package:social_firebase/features/register/page/register.dart';
import 'package:social_firebase/features/register/wedget/app_button.dart';
import 'package:social_firebase/features/register/wedget/app_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isDisabled = true;
  String btn = 'login';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          navigateAndFinish(context, const HomeScreen());
        }
      },
      builder: (context, state) {
        return MainScaffold(
          scaffold: Scaffold(
            appBar: AppBar(
              title: Text(
                "Login Page",
                style: Theme.of(context).textTheme.headline6,
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Lottie.asset('assets/images/login.json',
                        width: 200, height: 200),
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
                    space30Vertical,
                    AppButton(
                      onPress: !isDisabled
                          ? () {
                              MainBloc.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          : null,
                      label: btn,
                    ),
                    space10Vertical,
                    AppButton(
                      onPress: () {
                        navigateTo(context, const RegisterPage());
                      },
                      color: cyanClr,
                      label: 'Register',
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void enableLoginButton() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isDisabled = false;
      setState(() {});
    } else {
      isDisabled = true;
      setState(() {});
    }
  }
}
