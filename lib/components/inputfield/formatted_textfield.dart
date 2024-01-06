import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FormattedTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  var validator;
  final bool? enabled;
  final double borderRadius;
  final Widget suffix;

  FormattedTextField({
    Key? key,
    required this.hintText,
    this.icon = Icons.money,
    this.enabled = true,
    required this.onChanged,
    required this.controller,
    required this.validator,
    this.borderRadius = 6.0,
    this.suffix = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: Constants.primaryColor,
      controller: controller,
      validator: validator,
      inputFormatters: <TextInputFormatter>[
        MaskTextInputFormatter(
          mask: '#### #### #### #### #### ####',
          filter: {"#": RegExp(r'[0-9]')},
          type: MaskAutoCompletionType.lazy,
        )
      ],
      keyboardType: TextInputType.number,
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
        hintText: hintText,
        focusColor: Constants.strokeColor,
        hintStyle: const TextStyle(
          fontFamily: "OpenSans",
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
