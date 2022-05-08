import 'package:meta/meta.dart';

@immutable
abstract class MainState {}

class Empty extends MainState {}


class Error extends MainState {
  final String error;
  Error(this.error);
}

class ChangeModeState extends MainState {}

class ThemeLoaded extends MainState {}

class InternetState extends MainState {}

class ChangeDarkMode extends MainState {}

class SocialBottomNavigateState extends MainState {}

class LoginLoadingState extends MainState {}

class LoginSuccessState extends MainState {}

class HomeGetUserLoadingState extends MainState {}

class HomeGetUserSuccessState extends MainState {}

class RegisterLoadingState extends MainState {}

class CreateUserSuccessState extends MainState {}





