import 'package:flutter/material.dart';
import 'package:afrikunet/helper/constants/constants.dart';

class InfoDialog extends StatelessWidget {
  final Widget body;
  // final String title;
  const InfoDialog({
    required this.body,
    // required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: null,
          ),
          child: body,
        ),
      ],
    );
  }
}
