import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/material.dart';

class HorzTextDivider extends StatelessWidget {
  final String text;
  const HorzTextDivider({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: double.infinity, //size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextBody2(
              text: text,
              color: Colors.black54,
              fontWeight: FontWeight.w400,
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Colors.grey,
        height: 1.2,
      ),
    );
  }
}
