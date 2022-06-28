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

class PickProfileImageState extends MainState {}

class PickCoverImageState extends MainState {}

class UploadUserDataLoadingState extends MainState {}

class UploadProfileImageSuccessState extends MainState {}

class UploadProfileImageErrorState extends MainState {}

class UploadCoverImageSuccessState extends MainState {}

class UploadCoverImageErrorState extends MainState {}

class UpdateUserErrorState extends MainState {}

class LogoutLoadingState extends MainState {}

class CreatePostErrorState extends MainState {}

class CreatePostLoadingState extends MainState {}

class RemovePostImageState extends MainState {}
class SocialSendMessageSuccessState extends MainState {}
class SocialSendMessageErrorState extends MainState {}

class PicPostImageState extends MainState {}

class HomeGetPostsSuccessState extends MainState {}
class SocialGetAllUsersSuccessState extends MainState {}
class SocialGetMessagesSuccessState extends MainState {}

class SocialNewPostState extends MainState {}
class SocialLikePostSuccessState extends MainState {}

class HomeGetPostsErrorInitialState extends MainState {
  String error;

  HomeGetPostsErrorInitialState(this.error);
}
class SocialGetAllUsersErrorState extends MainState {
  String error;

  SocialGetAllUsersErrorState(this.error);
}
class SocialLikePostErrorState extends MainState {
  String error;

  SocialLikePostErrorState(this.error);
}
