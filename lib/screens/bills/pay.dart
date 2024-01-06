import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/screens/success_screen.dart';
import 'package:afrikunet/screens/vouchers/widgets/payment_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayNow extends StatelessWidget {
  final String title;
  const PayNow({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Constants.secondaryColor,
        automaticallyImplyLeading: true,
        title: TextMedium(
          text: title,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 16.0,
              ),
              const Expanded(
                child: Column(
                  children: [
                    PaymentMethod(),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  buttonText: "Pay",
                  onPressed: () {
                    Get.bottomSheet(
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        height: MediaQuery.of(context).size.height * 0.8,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(21),
                            topRight: Radius.circular(21),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.xmark_circle,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            DottedDivider(),
                            const SizedBox(height: 16.0),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Column(
                                    children: [
                                      Icon(
                                        CupertinoIcons.exclamationmark_circle,
                                        size: 75,
                                        color: Constants.primaryColor,
                                      ),
                                      SizedBox(height: 16.0),
                                      SizedBox(
                                        width: 256,
                                        child: Text(
                                          "You are on the verge of acquiring prepaid electricity credits totaling 5700 for the meter with number 01348873****46.",
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 24.0),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: PrimaryButton(
                                        buttonText: "Confirm",
                                        onPressed: () {
                                          Get.back();
                                          Get.to(
                                            const SuccessPage(
                                              isVoucher: true,
                                            ),
                                            transition: Transition.cupertino,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
