import 'package:flutter/material.dart';
import 'package:afrikunet/helper/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String errorText;
  final String helperText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  final bool? isEnabled;
  var validator;
  final double borderRadius;
  final Widget endIcon;
  final String? placeholder;
  final FocusNode? focusNode;
  final Widget? prefix;
  final int? maxLength;

  CustomTextField({
    Key? key,
    this.hintText = "",
    this.errorText = "",
    this.helperText = "",
    this.icon = Icons.person,
    this.isEnabled = true,
    this.capitalization = TextCapitalization.none,
    required this.onChanged,
    required this.controller,
    required this.validator,
    required this.inputType,
    this.borderRadius = 6.0,
    this.endIcon = const SizedBox(),
    this.placeholder = "",
    this.focusNode,
    this.prefix,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onEditingComplete: () {
        print("IS EDITING COMPLETE OH !!!");
      },
      onFieldSubmitted: (value) {
        print("IS SUBMITTED OHH !!! $value");
      },
      onSaved: (newValue) {
        print("IS SAVED OHH !! newValue");
      },
      cursorColor: Constants.secondaryColor,
      controller: controller,
      validator: validator,
      maxLength: hintText == "Phone" ? 11 : maxLength,
      enabled: isEnabled,
      focusNode: focusNode,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Constants.strokeColor, width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          gapPadding: 4.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Constants.strokeColor, width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          gapPadding: 4.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Constants.strokeColor, width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          gapPadding: 4.0,
        ),
        // errorBorder: errorText.isEmpty
        //     ? null
        //     : OutlineInputBorder(
        //         borderSide: const BorderSide(
        //           color: Constants.strokeColor,
        //           width: 1.0,
        //         ),
        //         borderRadius: BorderRadius.all(
        //           Radius.circular(borderRadius),
        //         ),
        //         gapPadding: 4.0,
        //       ),
        filled: false,
        hintText: placeholder ?? hintText,
        helperText: helperText,
        focusColor: Constants.strokeColor,
        errorText: errorText.isEmpty ? null : errorText,
        hintStyle: const TextStyle(
          fontFamily: "OpenSans",
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: endIcon,
        prefixIcon: prefix,
      ),
      keyboardType: inputType,
      textCapitalization: capitalization,
    );
  }
}
