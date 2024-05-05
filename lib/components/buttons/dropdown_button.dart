import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';

class DropDownButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  const DropDownButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Constants.strokeColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(
            left: 21.0,
            top: 12.0,
            bottom: 12.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
                fontSize: 13,
                fontFamily: 'OpenSans',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 21,
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
