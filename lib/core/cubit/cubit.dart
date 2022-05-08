import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_firebase/core/constants.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/core/di/injection.dart';
import 'package:social_firebase/core/models/user_data.dart';
import 'package:social_firebase/core/network/local/cache_helper.dart';
import 'package:social_firebase/core/network/repository.dart';
import 'package:social_firebase/features/chat/page/chat.dart';
import 'package:social_firebase/features/feed/page/feed.dart';
import 'package:social_firebase/features/home/widget/iconBroken.dart';
import 'package:social_firebase/features/settings/page/settings.dart';
import 'package:social_firebase/features/users/page/users.dart';

class MainBloc extends Cubit<MainState> {
  final Repository _repository;

  MainBloc({
    required Repository repository,
  })
      : _repository = repository,
        super(Empty());

  static MainBloc get(context) => BlocProvider.of(context);

  /// variables bool
  bool isRtl = false;
  bool isDark = false;

  /// dark colors
  String scaffoldBackground = '11202a';
  String mainColorDark = 'ffffff';
  String mainColorVariantDark = '8a8a89';

  /// dark colors
  String secondaryDark = 'ffffff';
  String secondaryVariantDark = '8a8a89';

  late ThemeData lightTheme;
  late ThemeData darkTheme;

  bool noInternetConnection = false;

  /// ChangePage --------------------------------- start ||
  int currentIndex = 0;

  List<Widget> screens = [
    const FeedPage(),
    const ChatsPage(),
    const UsersPage(),
    const SettingsPage(),
  ];

  List<String> titles = [
    'Home Page',
    'Chat Page',
    'User Page',
    'Setting Page',
  ];

  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(IconBroken.Home),
      label: "Home",
    ),
    const BottomNavigationBarItem(
        icon: Icon(IconBroken.Chat), label: "Chats"),
    const BottomNavigationBarItem(
      icon: Icon(IconBroken.User),
      label: "Users",
    ),
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.settings), label: "Settings"),
  ];

  void changeBottomNavigationBar(int index) {
    currentIndex = index;
    emit(SocialBottomNavigateState());
  }

  /// ChangePage --------------------------------- end ||
  /// firebase --------------------------------- start
  String? name;
  String? email;
  String? phone;
  File? imageFile;
  String? imageUrl;
  String? uId;

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
    required File imageFile,
  }) async {
    this.email = email;
    this.name = name;
    this.phone = phone;
    this.imageFile = imageFile;

    emit(RegisterLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email,
        password: password)
        .then((value) {
        uId = value.user!.uid;
      _uploadImage();
    }).catchError((error) {
      emit(Error(error.toString()));
    });
  }

  void _uploadImage() async {
    print('_uploadImage -----------------');
    try {
      await FirebaseStorage.instance
          .ref('profileImages/$uId')
          .putFile(imageFile!);

      _getImageUrl();
    } on FirebaseException catch (e) {
      emit(Error(e.toString()));
    }
  }

  void _getImageUrl() async {
    print('_getImageUrl -----------------');
    imageUrl = await FirebaseStorage.instance
        .ref('profileImages/$uId')
        .getDownloadURL();
          userCreate();
  }

  void userCreate() async {
    UserModel userModel = UserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      imageUrl: imageUrl,
    );
  print('userCreate -----------------');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      sl<CacheHelper>().put('uId', uIdUser);
      getUserDate();
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(Error(error.toString()));
    });
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email,
        password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      uId = value.user!.uid;
      getUserDate();
    }).catchError((error) {
      emit(Error(error.toString()));
    });
  }

  UserModel? userModel;
  void getUserDate() {
    emit(HomeGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uIdUser).get().then((value) {
      userModel = UserModel.fromMap(value.data()!);
      print(FirebaseAuth.instance.currentUser!.emailVerified);
      emit(HomeGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(Error(error));
    });
  }

  /// firebase --------------------------------- end

  void checkConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      debugPrint('Internet Connection ------------------------');
      debugPrint('${result.index}');
      debugPrint(result.toString());
      if (result.index == 0 || result.index == 1) {
        noInternetConnection = false;
      } else if (result.index == 2) {
        noInternetConnection = true;
      }
      emit(InternetState());
    });
  }

  void checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      noInternetConnection = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      noInternetConnection = false;
    } else {
      noInternetConnection = true;
    }
    emit(InternetState());
  }

  void changeDarkMode() {
    isDark = !isDark;
    sl<CacheHelper>().put('isDark', isDark);
    setThemes(change: isDark);
    emit(ChangeDarkMode());
  }

  void setThemes({required bool change}) {
    isDark = change;
    isDarkMode = isDark;
    changeTheme();
    emit(ThemeLoaded());
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  void changeTheme() {
    lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: Platform.isIOS
            ? null
            : const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 20.0,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 50.0,
        selectedItemColor: HexColor(textColorD),
        unselectedItemColor: HexColor(grey),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          height: 1.5,
        ),
      ),
      primarySwatch: MaterialColor(int.parse('0xff$secondaryColorD'), color),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: isDark ? HexColor(textColorD) : HexColor(TextMainColor),
          height: 1.3,
        ),
        bodyText1: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: isDark ? HexColor(textColorD) : HexColor(TextMainColor),
          height: 1.4,
        ),
        bodyText2: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w700,
          color: isDark ? HexColor(secondaryDark) : HexColor(TextMainColor),
          height: 1.4,
        ),
        subtitle1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          color: isDark ? HexColor(textColorD) : HexColor(TextMainColor),
          height: 1.4,
        ),
        subtitle2: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: isDark ? HexColor(textColorD) : HexColor(TextMainColor),
          height: 1.4,
        ),
        caption: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
          height: 1.4,
        ),
        button: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1.4,
        ),
      ),
    );

    darkTheme = ThemeData(
      primaryColor: Colors.yellow,
      primaryColorLight: Colors.yellow,
      primaryColorDark: Colors.yellow,
      // background
      scaffoldBackgroundColor: Colors.black38,
      // canvasColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: Platform.isIOS
            ? null
            : const SystemUiOverlayStyle(
          statusBarColor: Color(0x00060a0c),
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: darkGreyClr,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: IconThemeData(
          size: 20.0,
          color: HexColor(mainColorDark),
        ),
        titleTextStyle: TextStyle(
          color: HexColor(grey),
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: HexColor(scaffoldBackground),
        elevation: 50.0,
        selectedItemColor: HexColor(mainColor),
        unselectedItemColor: HexColor(grey),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          height: 1.5,
        ),
      ),
      // any selected item .
      primarySwatch: MaterialColor(int.parse('0xff$mainColorD'), color),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: HexColor(surface),
          height: 1.3,
        ),
        bodyText1: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: HexColor(surface),
          height: 1.4,
        ),
        bodyText2: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.w700,
          color: HexColor(surface),
          height: 1.4,
        ),
        subtitle1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          color: HexColor(surface),
          height: 1.4,
        ),
        subtitle2: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: HexColor(surface),
          height: 1.4,
        ),
        caption: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: HexColor(surface),
          height: 1.4,
        ),
        button: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1.4,
        ),
      ),
    );
  }

  void changeMode({required bool value}) {
    isDark = value;
    sl<CacheHelper>().put('isDark', isDark);
    emit(ChangeModeState());
  }
}
