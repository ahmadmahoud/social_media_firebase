import 'package:flutter/material.dart';

class TextButtonCustom extends StatelessWidget {
  const TextButtonCustom ({Key? key,required this.text,required this.onClick}) : super(key: key);
  final Function() onClick;
  final String text;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onClick,
        child: Text(
          text,
        ));
  }
}
