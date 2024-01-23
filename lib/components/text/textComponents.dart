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
    this.fontWeight = FontWeight.w500,
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
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontFamily: fontFamily,
            fontWeight: fontWeight,
          ),
    );
  }
}

class TextHeading extends StatelessWidget {
  late final String? text;
  late final Color color;
  late final TextAlign? align;
  late final FontWeight fontWeight;
  late final bool? softWrap;

  TextHeading({
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w500,
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
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
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
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
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
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
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
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: color,
            fontFamily: fontFamily,
          ),
    );
  }
}

class TextBody2 extends StatelessWidget {
  late final String? text;
  late final Color color;
  late final FontWeight fontWeight;
  late final double lineHeight;
  late final TextAlign? align;

  TextBody2({
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.lineHeight = 1.25,
    this.align,
  });

  final fontFamily = "OpenSans";

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align,
      softWrap: true,
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: color, fontFamily: fontFamily, height: lineHeight),
    );
  }
}
