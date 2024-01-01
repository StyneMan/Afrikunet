import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final Color bgColor;
  final Color foreColor;
  final String buttonText;
  final Function()? onPressed;
  const GoogleButton({
    Key? key,
    this.bgColor = Colors.transparent,
    this.foreColor = Constants.primaryColor,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        foregroundColor: foreColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        side: const BorderSide(
          color: Constants.strokeColor,
          strokeAlign: 1.0,
          width: 1.0,
        ),
      ),
      icon: Image.asset(
        "assets/images/google.png",
        height: 32,
        width: 32,
      ),
      label: TextSmall(
        text: buttonText,
        color: foreColor,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
