import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Color bgColor;
  final Color foreColor;
  final String buttonText;
  final Function()? onPressed;
  const PrimaryButton({
    Key? key,
    this.bgColor = Constants.primaryColor,
    this.foreColor = Colors.white,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(15.0),
        foregroundColor: foreColor,
        backgroundColor: bgColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
      child: TextBody1(
        text: buttonText,
        color: foreColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
