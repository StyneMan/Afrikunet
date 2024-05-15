import 'dart:convert';

import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/forms/bank/add_bank.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/otp/verifyotp.dart';
import 'package:afrikunet/screens/bank/widgets/bank_card2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoucherBottomSheet extends StatefulWidget {
  final PreferenceManager manager;
  final Map data;
  final String voucherCode;

  const VoucherBottomSheet({
    Key? key,
    required this.manager,
    required this.data,
    required this.voucherCode,
  }) : super(key: key);

  @override
  State<VoucherBottomSheet> createState() => _VoucherBottomSheetState();
}

class _VoucherBottomSheetState extends State<VoucherBottomSheet> {
  int _currIndex = 0;
  // var _selectedBank;
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
      child: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          CupertinoIcons.xmark_circle,
                          size: 21,
                          color: Theme.of(context).colorScheme.tertiary,
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
                        "${Constants.nairaSign(context).currencySymbol} ${widget.data['amount']}",
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
                      for (var i = 0;
                          i < _controller.userBankAccounts.value.length;
                          i++)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _currIndex = i;
                            });
                          },
                          child: BankCard2(
                            data: _controller.userBankAccounts.value[i],
                            index: i,
                            list: _controller.userBankAccounts.value,
                          ),
                        )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
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
                        child: Text(
                          'Add Bank +',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
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
                onPressed: _controller.isLoading.value
                    ? null
                    : () {
                        _generateOTP();
                      },
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }

  _generateOTP() async {
    try {
      _controller.setLoading(true);
      final _response = await APIService().voucherGenerateOTP(
        accessToken: widget.manager.getAccessToken(),
        voucherCode: widget.voucherCode,
      );
      _controller.setLoading(false);
      print("SEND OTP RESPONSE HERE ${_response.body}");
      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_response.body);
        Constants.toast(map['message']);

        Get.back();
        Get.to(
          VerifyOTP(
            email: '',
            caller: 'voucher',
            manager: widget.manager,
            bankData: _controller.userBankAccounts.value[_currIndex],
            voucherCode: widget.voucherCode,
          ),
          transition: Transition.cupertino,
        );
      }
    } catch (e) {
      _controller.setLoading(false);
      print("$e");
    }
  }
}
