import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:afrikunet/helper/constants/constants.dart';

class RoundedInputMoney extends StatelessWidget {
  final String hintText;
  final String errorText;
  final String helperText;
  final IconData icon;
  final bool? enabled;
  final String? currencySymbol;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  var validator;
  final Color strokeColor;
  final double borderRadius;

  RoundedInputMoney(
      {Key? key,
      required this.hintText,
      this.icon = Icons.money,
      this.errorText = "",
      this.helperText = "",
      this.enabled,
      this.strokeColor = Colors.black,
      required this.onChanged,
      required this.controller,
      required this.validator,
      this.borderRadius = 4.0,
      this.currencySymbol = '₦',
      s})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: Theme.of(context).colorScheme.secondary,
      controller: controller,
      validator: validator,
      enabled: enabled,
      inputFormatters: <TextInputFormatter>[
        CurrencyTextInputFormatter(
          locale: 'en',
          decimalDigits: 0,
          symbol: currencySymbol,
        ),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          borderSide: BorderSide(
            color: strokeColor,
          ),
          gapPadding: 4.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          borderSide: BorderSide(
            color: strokeColor,
          ),
          gapPadding: 4.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          borderSide: BorderSide(
            color: strokeColor,
          ),
          gapPadding: 4.0,
        ),
        filled: false,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText.isEmpty ? null : errorText,
        focusColor: Constants.accentColor,
        hintStyle: TextStyle(
          fontFamily: "OpenSans",
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          fontFamily: "OpenSans",
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}
