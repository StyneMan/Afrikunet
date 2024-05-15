import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/model/onboarding.dart';
import 'package:flutter/material.dart';

class OnbaoardingItem extends StatelessWidget {
  final OnboardingSlide item;
  const OnbaoardingItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Image.asset(
              item.image,
              width: MediaQuery.of(context).size.width * 0.7,
              height: 320,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextLarge(text: item.title),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
            child: TextBody1(text: item.desc, align: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
