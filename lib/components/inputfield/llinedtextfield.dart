import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';

class LinedTextField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  final bool? isEnabled;
  final bool isFlexed;
  final Widget? prefix;
  var validator;
  LinedTextField({
    Key? key,
    required this.label,
    required this.onChanged,
    required this.controller,
    required this.validator,
    required this.inputType,
    required this.capitalization,
    this.isEnabled = true,
    this.isFlexed = false,
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isFlexed
            ? Expanded(
                flex: 1,
                child: TextBody1(
                  text: label,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              )
            : TextBody1(
                text: label,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.tertiary,
              ),
        Expanded(
          flex: isFlexed ? 2 : 1,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 200,
              minWidth: 100,
            ),
            child: TextFormField(
              onChanged: onChanged,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              cursorColor: Constants.primaryColor,
              controller: controller,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: "Inter",
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              validator: validator,
              maxLength: label == "Phone" ? 11 : null,
              enabled: isEnabled,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 21.0,
                  vertical: 1.0,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                hintText: label,
                labelText: "",
                focusColor: Constants.accentColor,
                hintStyle: const TextStyle(
                  fontFamily: "Inter",
                  color: Colors.black38,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: prefix,
              ),
              keyboardType: inputType,
              textCapitalization: capitalization,
            ),
          ),
        ),
      ],
    );
  }
}
