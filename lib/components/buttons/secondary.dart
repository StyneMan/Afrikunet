import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Color bgColor;
  final Color foreColor;
  final String buttonText;
  final double? fontSize;
  final Widget? startIcon;
  final Function()? onPressed;
  const SecondaryButton({
    Key? key,
    this.bgColor = Colors.transparent,
    this.foreColor = Constants.primaryColor,
    required this.buttonText,
    required this.onPressed,
    this.fontSize,
    this.startIcon = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(15.0),
        foregroundColor: foreColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          strokeAlign: 1.0,
          width: 1.0,
        ),
      ),
      child: fontSize != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                startIcon ?? const SizedBox(),
                Text(
                  buttonText,
                  style: TextStyle(
                    color: foreColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                startIcon ?? const SizedBox(),
                TextBody1(
                  text: buttonText,
                  color: foreColor,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
    );
  }
}
