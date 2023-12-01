import 'package:flutter/material.dart';

class TextLarge extends StatelessWidget {
  late final String? text;
  late final Color color;
  late final TextAlign? align;
  late final FontWeight fontWeight;
  late final bool? softWrap;

  TextLarge({
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w600,
    this.align,
    this.softWrap,
  });

  final fontFamily = "OpenSans";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      softWrap: softWrap,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: 30,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}

class TextMedium extends StatelessWidget {
  late final String? text;
  late final Color color;
  late final FontWeight fontWeight;
  late final TextAlign? align;

  TextMedium({
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w500,
    this.align,
  });

  final fontFamily = "OpenSans";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: 20,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}

class TextSmall extends StatelessWidget {
  late final String? text;
  late final Color color;
  late final FontWeight fontWeight;
  late final TextAlign? align;

  TextSmall({
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.align,
  });

  final fontFamily = "OpenSans";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: 17,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}

class TextBody1 extends StatelessWidget {
  late final String? text;
  late final Color color;
  late final FontWeight fontWeight;
  late final TextAlign? align;

  TextBody1({
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.align,
  });

  final fontFamily = "OpenSans";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: 15,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}

class TextBody2 extends StatelessWidget {
  late final String? text;
  late final Color color;
  late final FontWeight fontWeight;
  late final TextAlign? align;

  TextBody2({
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.align,
  });

  final fontFamily = "OpenSans";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: 14,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}
