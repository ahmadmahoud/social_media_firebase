import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_firebase/core/di/injection.dart';
import 'package:social_firebase/core/network/local/cache_helper.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';

const String mainColor = 'f5f5eb';
const String appBarColor = 'efefd1';
const String brownColor = '4b1e1e';
const String TextMainColor = '31837f';
const String statusColor = 'bcbca4';
const String soundBarColor = 'fffdf3';
const String textFormFiledColor = '525E75';

/// Dark Mode Colors
const String mainColorD = '008fd3';
const String secondaryColorD = '203440';
const String textColorD = '008fd3';
const String textColorGrayD = 'EEEEEE';
const String brownColorD = 'a89f9a';


const String black = '#5E5F61';
const Color secondaryVariant = Color.fromRGBO(33, 36, 36, 0.7019607843137254);
const Color starColor = Colors.amber;
const String red = '#F21A0E';
const String grey = '#898989';
const String green = '#125c03';
const String surface = '#f5f5f5';
const String greyWhite = '#8fe1e7f0';
const String disableButton = '#A7B1D7';

//dark theme
const String secondBackground = '393d40';
const String secondaryVariantDark = '8a8a89';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color cyanClr = Color(0xFF2F7387);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const Color primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);
const Color appbarColor = Color(0xffe8e8e8);

const Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

String? formatTime(Duration duration) {
String twdDigits(int n)=> n.toString().padLeft(2,'0');
final hours = twdDigits(duration.inHours);
final minutes = twdDigits(duration.inMinutes.remainder(60));
final seconds = twdDigits(duration.inSeconds.remainder(60));

return [
  if (duration.inHours > 0) hours,minutes,seconds].join(':');
}

dynamic parseMapFromServer(String text) => jsonDecode(
    text.replaceAll(r'\', r'').replaceAll(r'\\', r'').replaceAll(r'\\\', r''));

// List<Widget> bottomPages = [
//   const HomePage(),
//   const Categories(),
//   const SavedPage(),
//   AccountPage(),
// ];

bool? isDarkMode;
bool isDark = false;
int indexPage = 0;
String? uIdUser;

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

void showToast({
  required String message,
  required ToastStates toastStates,
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: choseToastColor(toastStates),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color choseToastColor(ToastStates toastStates) {
  Color color;
  switch (toastStates) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
  }
  return color;
}

Widget myDivider(context) => Divider(
      height: 0.0,
      color: HexColor(grey),
    );

Widget bigDivider(context) => Container(
      width: double.infinity,
      height: 4.0,
      color: HexColor(grey),
    );

const space3Vertical = SizedBox(
  height: 3.0,
);

const space4Vertical = SizedBox(
  height: 4.0,
);

const space5Vertical = SizedBox(
  height: 5.0,
);

const space8Vertical = SizedBox(
  height: 8.0,
);

const space10Vertical = SizedBox(
  height: 10.0,
);

const space15Vertical = SizedBox(
  height: 15.0,
);

const space20Vertical = SizedBox(
  height: 20.0,
);

const space30Vertical = SizedBox(
  height: 30.0,
);

const space40Vertical = SizedBox(
  height: 40.0,
);

const space50Vertical = SizedBox(
  height: 50.0,
);

const space60Vertical = SizedBox(
  height: 60.0,
);

const space70Vertical = SizedBox(
  height: 70.0,
);

const space80Vertical = SizedBox(
  height: 80.0,
);

const space90Vertical = SizedBox(
  height: 90.0,
);

const space100Vertical = SizedBox(
  height: 100.0,
);

const space3Horizontal = SizedBox(
  width: 3.0,
);

const space4Horizontal = SizedBox(
  width: 4.0,
);

const space5Horizontal = SizedBox(
  width: 5.0,
);

const space10Horizontal = SizedBox(
  width: 10.0,
);
const space15Horizontal = SizedBox(
  width: 15.0,
);

const space6Horizontal = SizedBox(
  width: 6.0,
);

const space20Horizontal = SizedBox(
  width: 20.0,
);

const space30Horizontal = SizedBox(
  width: 30.0,
);

const space40Horizontal = SizedBox(
  width: 40.0,
);

const space50Horizontal = SizedBox(
  width: 50.0,
);

const space60Horizontal = SizedBox(
  width: 60.0,
);

const space70Horizontal = SizedBox(
  width: 70.0,
);

const space80Horizontal = SizedBox(
  width: 80.0,
);

const space90Horizontal = SizedBox(
  width: 90.0,
);

const space100Horizontal = SizedBox(
  width: 100.0,
);

Widget defaultTextButton({
  required Function()? onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? onTap,
  Function(String)? onChanged,
  Function()? suffixPressed,
  Function(String)? onSubmit,
  required TextInputType type,
  required String? Function(String?)? validate,
  bool isPassword = false,
}) =>
    TextFormField(
      validator: validate,
      keyboardType: type,
      onTap: onTap,
      obscureText: isPassword,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
          ),
        )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function()? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 45.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );
