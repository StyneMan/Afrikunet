import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/temp_accounts.dart';
import 'package:afrikunet/forms/bank/add_bank.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/otp/verifyotp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VoucherBottomSheet extends StatefulWidget {
  final PreferenceManager manager;
  const VoucherBottomSheet({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<VoucherBottomSheet> createState() => _VoucherBottomSheetState();
}

class _VoucherBottomSheetState extends State<VoucherBottomSheet> {
  int _currIndex = 0;
  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
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
                        size: 21,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                DottedDivider(),
                const SizedBox(height: 10.0),
                Column(
                  children: [
                    TextMedium(
                      text: "Your voucher is valid and worth",
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      "${Constants.nairaSign(context).currencySymbol}1,000,000",
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextBody1(
                      text: "Choose a redeeming bank account",
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < tempAccounts.length; i++)
                      _accountRow(tempAccounts[i], i)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // final RenderBox renderBox =
                        //     key.currentContext.findRenderObject();
                        // final componentPosition =
                        //     renderBox.localToGlobal(Offset.zero);

                        double sheetHeight =
                            MediaQuery.of(context).size.height * 0.75;

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return SizedBox(
                              height: sheetHeight,
                              width: double.infinity,
                              child: const AddBankForm(),
                            );
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                        );
                      },
                      child: const Text('Add Bank +'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: PrimaryButton(
              fontSize: 16,
              buttonText: "Continue",
              onPressed: () {
                Get.back();
                _controller.setLoading(true);
                Future.delayed(const Duration(seconds: 3), () {
                  _controller.setLoading(false);
                  Get.to(
                    VerifyOTP(
                      caller: 'voucher',
                      email: 'wenprecious@gamail.com',
                      manager: widget.manager,
                    ),
                    transition: Transition.cupertino,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountRow(AccountModel data, int index) {
    return Card(
      child: TextButton(
        onPressed: () {
          setState(() {
            _currIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(data.bankLogo),
                  TextSmall(
                    text: data.bankName,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextMedium(
                    text: data.accName,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  TextSmall(
                    text: data.accNumber,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              ),
              _currIndex == index
                  ? SvgPicture.asset("assets/images/inactive_rect.svg")
                  : SvgPicture.asset("assets/images/active_rect.svg"),
            ],
          ),
        ),
      ),
    );
  }
}
