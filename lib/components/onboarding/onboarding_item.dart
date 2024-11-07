import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/model/onboarding.dart';
import 'package:flutter/material.dart';

class OnbaoardingItem extends StatelessWidget {
  final OnboardingSlide item;
  const OnbaoardingItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Constants.primaryColor,
            width: double.infinity,
            child: Image.asset(
              item.image,
              width: MediaQuery.of(context).size.width * 0.7,
              height: 320,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextLarge(
                  text: item.title,
                  fontWeight: FontWeight.w700,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextBody1(
                    text: item.desc,
                    align: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
