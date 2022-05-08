import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase/core/constants.dart';
import 'package:social_firebase/core/cubit/MyBlocObserver.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/core/di/injection.dart';
import 'package:social_firebase/core/network/local/cache.dart';
import 'package:social_firebase/core/di/injection.dart' as di;
import 'package:social_firebase/core/network/local/cache_helper.dart';
import 'package:social_firebase/features/home/page/homePage.dart';
import 'package:social_firebase/features/login/page/login.dart';
import 'package:social_firebase/features/register/page/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await di.init();
  await CacheHelperw.init();

  bool isDark = false;
  await sl<CacheHelper>().get('isDark').then((value) {
    debugPrint('dark mode ------------- $value');
    if (value != null) {
      isDark = value;
    } else {
      isDark = false;
    }
  });

  Widget widget;
  await sl<CacheHelper>().get('uId').then((value) {
    if (value != null) {
      uIdUser = value;
      print('u id $uIdUser');
    } else {
      uIdUser = null;
    }
  });

  if (uIdUser != null) {
    widget = const HomeScreen();
    print(uIdUser);
  } else {
    widget = const LoginPage();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isDark,required this.startWidget}) : super(key: key);
  final bool isDark;
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MainBloc>()
        ..setThemes(change: isDark)
        ..getUserDate(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return MaterialApp(
            theme: MainBloc.get(context).lightTheme,
            themeMode:
                MainBloc.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: startWidget,
          );
        },
      ),
    );
  }
}
