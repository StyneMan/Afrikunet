import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/model/onboarding.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          CachedNetworkImage(
            imageUrl: item.image,
            width: 256,
            height: 320,
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
