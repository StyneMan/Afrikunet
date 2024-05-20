import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/shimmer/banner_shimmer.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef void ClickCallback(String varCode, var amount);

class NaijaNetworkSheet extends StatelessWidget {
  final ClickCallback onSelected;
  var currentPackages;
  NaijaNetworkSheet({
    Key? key,
    required this.currentPackages,
    required this.onSelected,
  }) : super(key: key);

  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: MediaQuery.of(context).size.height * 0.84,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
        ),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextBody1(
                text: "Select a Package",
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  _controller.isLoadingPackages.value
                      ? ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 24.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: const BannerShimmer(),
                                ),
                                const SizedBox(
                                  height: 21.0,
                                  width: 16,
                                  child: BannerShimmer(),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: 5,
                        )
                      : currentPackages.isEmpty
                          ? const SizedBox(height: 16.0)
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return currentPackages.isEmpty
                                    ? const SizedBox()
                                    : Obx(
                                        () => TextButton(
                                          onPressed: () {
                                            // _controller.selectedDataPlan.value =
                                            //     currentPackages[index];

                                            onSelected(
                                              currentPackages[index]
                                                  ['variation_code'],
                                              "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(currentPackages[index]['variation_amount']))}",
                                            );

                                            _controller
                                                    .internetDataAmount.value =
                                                currentPackages[index]
                                                    ['variation_amount'];
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 0.0,
                                              vertical: 2.0,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextBody1(
                                                      text:
                                                          '${currentPackages[index]['name']}'
                                                              .capitalize,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .tertiary,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Radio(
                                                activeColor: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                value: currentPackages[index]
                                                    ['variation_code'],
                                                groupValue: _controller
                                                    .selectedDataPlan
                                                    .value['variation_code'],
                                                onChanged: null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: (currentPackages).length,
                            ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: PrimaryButton(
                buttonText: "Done",
                fontSize: 15,
                bgColor: Theme.of(context).colorScheme.primaryContainer,
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
