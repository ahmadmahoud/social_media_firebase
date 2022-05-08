import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/core/widget/internet_connection_page.dart';

class MainScaffold extends StatelessWidget {
  final Widget scaffold;

  const MainScaffold({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Directionality(
          textDirection: MainBloc.get(context).isRtl
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Conditional.single(
            context: context,
            conditionBuilder: (context) =>
            !MainBloc.get(context).noInternetConnection,
            widgetBuilder: (context) => scaffold,
            fallbackBuilder: (context) => const InternetConnectionPage(),
          ),
        );
      },
    );
  }
}