import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/constants.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPress;
  final double width;
  double height;
  Color? color;
  Color? textColor;

  AppButton({
    Key? key,
    required this.label,
    required this.onPress,
    this.width = double.infinity,
    this.height = 50.0,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: MaterialButton(
        enableFeedback: true,
        elevation: 50.0,
        hoverElevation: 150.0,
        color: color ?? Theme.of(context).primaryColor,
        onPressed: onPress,
        disabledColor: HexColor(disableButton),
        child: Text(
          label,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
            color: textColor == null ? HexColor(surface) : textColor,
          ),
        ),
      ),
    );
  }
}