import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:afrikunet/helper/constants/constants.dart';

typedef InitCallback();

class PasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final double borderRadius;
  var validator;
  final String? hint;

  PasswordField({
    Key? key,
    required this.validator,
    required this.controller,
    required this.onChanged,
    this.hint,
    this.borderRadius = 6.0,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      cursorColor: Constants.secondaryColor,
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Constants.strokeColor, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius),
            ),
            gapPadding: 1.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Constants.strokeColor, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius),
            ),
            gapPadding: 1.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Constants.strokeColor, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius),
            ),
            gapPadding: 1.0,
          ),
          filled: false,
          focusColor: Constants.strokeColor,
          hintStyle: const TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w400,
              color: Colors.black38,
              fontSize: 14),
          isDense: true,
          hintText: widget.hint ?? "Password",
          labelText: widget.hint ?? "Password",
          suffix: InkWell(
            onTap: () => _togglePass(),
            child: Icon(
              _obscureText ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye,
              color: Colors.black54,
            ),
          ),
          suffixStyle: const TextStyle(color: Colors.black54)
          // border: InputBorder.none,
          ),
    );
  }
}
