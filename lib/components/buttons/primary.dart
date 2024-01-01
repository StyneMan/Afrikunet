import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Color bgColor;
  final Color foreColor;
  final String buttonText;
  final double? fontSize;
  final Function()? onPressed;
  const PrimaryButton({
    Key? key,
    this.bgColor = Constants.primaryColor,
    this.foreColor = Colors.white,
    this.fontSize,
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
      child: fontSize != null
          ? Text(
              buttonText,
              style: TextStyle(
                color: foreColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            )
          : TextBody1(
              text: buttonText,
              color: foreColor,
              fontWeight: FontWeight.w700,
            ),
    );
  }
}
