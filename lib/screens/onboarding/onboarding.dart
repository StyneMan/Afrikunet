import 'package:afrikunet/components/onboarding/onboarding_item.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/model/onboarding.dart';
import 'package:afrikunet/screens/getstarted/getstarted.dart';
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
        body: Column(
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
                  return GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      print("DETAILS ::: ${details.globalPosition.dx}");
                      if (_appController.onboardingIndex.value == 2) {
                        if (details.globalPosition.dx > 75) {
                          print("DELETE LEFT HERE :::");
                          Get.offAll(
                            GetStarted(),
                            transition: Transition.cupertino,
                          );
                        }
                      }
                    },
                    child: OnbaoardingItem(item: onboardingSlides[index]),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
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
                                  ? 36.0
                                  : 10.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 3.0,
                          ),
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
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.offAll(
                        GetStarted(),
                        transition: Transition.cupertino,
                      );
                    },
                    child: TextMedium(
                      text: 'Skip',
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}
