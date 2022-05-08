import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/core/widget/internet_connection_page.dart';

import '../constants.dart';

class BackScaffold extends StatelessWidget {
  final Widget body;
  String title;
  String color;
  String iconColor;
  String actionText;
  Widget actionIcon;
  bool titleImage;
  Widget? floatingButton;
  final Color scaffoldBackgroundColor;

  BackScaffold({
    Key? key,
    required this.body,
    this.title = '',
    required this.scaffoldBackgroundColor,
    this.color = black,
    this.iconColor = black,
    this.actionText = '',
    this.actionIcon = const SizedBox(),
    this.titleImage = false,
    this.floatingButton,
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
            widgetBuilder: (context) => Scaffold(
              backgroundColor: scaffoldBackgroundColor,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: scaffoldBackgroundColor,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: HexColor(mainColor),
                    size: 20.0,
                  ),
                ),
                titleSpacing: 20.0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Text(
                        actionText,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: HexColor(color)),
                      ),
                    ),
                  ),
                  actionIcon,
                ],
                title: Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              body: body,
              floatingActionButton: floatingButton,
            ),
            fallbackBuilder: (context) => const InternetConnectionPage(),
          ),
        );
      },
    );
  }
}