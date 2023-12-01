import 'package:afrikunet/components/onboarding/onboarding_item.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/model/onboarding.dart';
import 'package:afrikunet/screens/getstarted/getstarted.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _appController = Get.find<StateController>();
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                'https://i.imgur.com/RwCXUQu.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (value) {
                    _appController.onboardingIndex.value = value;
                    _pageController.animateToPage(
                      _appController.onboardingIndex.value,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: onboardingSlides.length,
                  itemBuilder: (context, index) {
                    return OnbaoardingItem(item: onboardingSlides[index]);
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: onboardingSlides.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _pageController.animateToPage(
                          entry.key,
                          duration: const Duration(),
                          curve: Curves.easeIn,
                        ),
                        child: Container(
                          width:
                              _appController.onboardingIndex.value == entry.key
                                  ? 48.0
                                  : 12.0,
                          height: 12.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Constants.primaryColor)
                                    .withOpacity(
                              _appController.onboardingIndex.value == entry.key
                                  ? 0.9
                                  : 0.4,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offAll(
                        const GetStarted(),
                        transition: Transition.cupertino,
                      );
                    },
                    child: TextMedium(
                      text: 'Skip',
                      color: Constants.primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
