import 'package:flutter/material.dart';
import 'package:afrikunet/helper/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
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

  CustomTextField({
    Key? key,
    this.hintText = "",
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: Constants.secondaryColor,
      controller: controller,
      validator: validator,
      maxLength: hintText == "Phone" ? 11 : null,
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
        filled: false,
        hintText: placeholder ?? hintText,
        focusColor: Constants.strokeColor,
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
