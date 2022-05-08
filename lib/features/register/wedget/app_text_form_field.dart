import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_firebase/core/constants.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';

class AppTextFormField extends StatefulWidget {
  final String label;
  final Widget? icon;
  final String hint;
  final bool isPassword;
  final Function callbackHandle;
  final ValueChanged<String>? onChanged;
  final TextInputType type;
  final TextInputAction? textInputAction;
  final bool? readOnly;
  final bool? enabled;
  final ValueChanged<String>? onSubmit;


  const AppTextFormField({
    Key? key,
    this.label = '',
    this.icon,
    this.readOnly = false,
    this.enabled = true,
    this.textInputAction,
    required this.hint,
    this.type = TextInputType.text,
    this.isPassword = false,
    this.onChanged,
    this.onSubmit,
    required this.callbackHandle,
  }) : super(key: key);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  final TextEditingController textEditingController = TextEditingController();
  bool isShown = true;

  @override
  Widget build(BuildContext context) {
    widget.callbackHandle(textEditingController);

    return BlocBuilder<MainBloc, MainState>(
      builder: (BuildContext context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: HexColor(greyWhite),
          ),
          child: TextFormField(
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: secondaryVariant,
            ),
            keyboardType: widget.type,
            enabled:widget.enabled!,
            readOnly: widget.readOnly!,
            controller: textEditingController,
            obscureText: widget.isPassword ? isShown : false,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmit,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: MainBloc.get(context).isDark
                      ? HexColor(grey)
                      : secondaryVariant,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: HexColor(textFormFiledColor),
              ),
              hintText: widget.hint,
              contentPadding: const EdgeInsetsDirectional.only(
                start: 15.0,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                padding: const EdgeInsets.all(15.0),
                onPressed: () {
                  setState(() {
                    isShown = !isShown;
                  });
                },
                icon: isShown
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),

              )
                  : widget.icon == null
                  ? null
                  : Padding(
                padding: const EdgeInsetsDirectional.all(12.0),
                child: widget.icon,
              ),
            ),
          ),
        );
      },
    );
  }
}