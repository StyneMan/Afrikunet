import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Color? bgColor;
  final Color? strokeColor;
  final Widget icon;
  final double radius;
  final Function()? onPressed;
  const ActionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.radius = 32.0,
    this.bgColor = Colors.white,
    this.strokeColor = Constants.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Center(
        child: icon,
      ),
      style: TextButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: strokeColor,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(
            color: strokeColor ?? Constants.primaryColor,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
