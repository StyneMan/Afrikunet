import 'package:afrikunet/components/cards/micro_giftcard.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/vouchers/buy_voucher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef void InitSheetCallback();
// typedef void InitValidateCallback();
typedef void InitPressCallback(var value);

class MyVouchersSheet extends StatelessWidget {
  final PreferenceManager manager;
  final InitSheetCallback onShowSheet;
  final InitPressCallback onPressed;
  MyVouchersSheet({
    Key? key,
    required this.manager,
    required this.onPressed,
    required this.onShowSheet,
  }) : super(key: key);

  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextMedium(
              text: 'My Vouchers',
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 14.0,
              ),
              child: _controller.userUnusedVouchers.value.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/empty.png"),
                          TextSmall(
                            text: "You don't have any valid vouchers",
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Get.to(
                                BuyVoucher(
                                  manager: manager,
                                ),
                              );
                            },
                            icon: Icon(
                              CupertinoIcons.add,
                              size: 16,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            label: TextBody2(
                              text: "Buy new voucher",
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(1.0),
                      itemBuilder: (context, index) {
                        final item =
                            _controller.userUnusedVouchers.value[index];
                        return TextButton(
                          onPressed: () {
                            print('VOUCHER DATA HERE :::  ${item}');
                            // setState(() {
                            //   _inputController.text = item['code'];
                            // });s
                            onPressed(item);
                            Get.back();
                            onShowSheet();
                            // _showInputSheet();
                            // Future.delayed(const Duration(seconds: 2), () {
                            //   _validate();
                            // });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      height: 96,
                                      child: MicroGiftCard(
                                        amount: "${item['amount']}",
                                        bgType: item['bg_type'],
                                        code: item['code'],
                                        status: item['status'],
                                        type: item['type'],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextSmall(
                                          text:
                                              "Voucher  ${item['code'].toString().substring(0, 4)}****",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                        TextBody2(
                                          text:
                                              "${Constants.formatDate("${item['created_at']}")} (${Constants.timeUntil(DateTime.parse(item['created_at']))})",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Column(
                        children: [
                          SizedBox(height: 8.0),
                          Divider(),
                          SizedBox(height: 8.0),
                        ],
                      ),
                      itemCount: _controller.userUnusedVouchers.value.length,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
