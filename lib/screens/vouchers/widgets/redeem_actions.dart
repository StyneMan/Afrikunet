import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/buttons/secondary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/forms/bank/add_bank.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/vouchers/voucher_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'voucher_scanner.dart';

typedef void ClickCallback(bool value);

class VoucherRedeemActions extends StatefulWidget {
  final PreferenceManager manager;
  final String caller;
  final ClickCallback? onClicked;
  VoucherRedeemActions({
    Key? key,
    required this.caller,
    required this.manager,
    this.onClicked,
  }) : super(key: key);

  @override
  State<VoucherRedeemActions> createState() => _VoucherRedeemActionsState();
}

class _VoucherRedeemActionsState extends State<VoucherRedeemActions> {
  final _controller = Get.find<StateController>();
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: PrimaryButton(
            buttonText: "Scan",
            bgColor: Theme.of(context).colorScheme.primaryContainer,
            onPressed: () {
              if (_controller.userBankAccounts.value.isEmpty) {
                Constants.showErrorDialog(
                  context: context,
                  message:
                      "You have not added any bank account. Add bank to proceed ",
                  dismissible: true,
                  widget: TextButton.icon(
                    onPressed: () {
                      Get.back();
                      _showBankBottomSheet(
                        context,
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.add,
                      size: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    label: TextBody2(
                      text: "Add bank",
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                );
              } else {
                print("OPEN SCANNER HERE !!!");
                Get.to(
                  const VoucherScanner(),
                  transition: Transition.cupertino,
                );
              }
            },
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: SecondaryButton(
            buttonText: "Enter Code",
            foreColor: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              if (_controller.userBankAccounts.value.isEmpty) {
                Constants.showErrorDialog(
                  context: context,
                  message:
                      "You have not added any bank account. Add bank to proceed ",
                  dismissible: true,
                  widget: TextButton.icon(
                    onPressed: () {
                      Get.back();
                      _showBankBottomSheet(
                        context,
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.add,
                      size: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    label: TextBody2(
                      text: "Add bank",
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                );
              } else {
                if (widget.caller == "bank") {
                  Get.to(
                    VoucherCode(
                      manager: widget.manager,
                    ),
                    transition: Transition.cupertino,
                  );
                } else if (widget.caller == "utility") {
                  widget.onClicked!(!_isOpen);
                  setState(() {
                    _isOpen = !_isOpen;
                  });
                }
              }
            },
          ),
        ),
      ],
    );
  }

  _showBankBottomSheet(var context) {
    double sheetHeight = MediaQuery.of(context).size.height * 0.75;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: sheetHeight,
          width: double.infinity,
          child: const Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: AddBankForm(),
              ),
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
    );
  }
}
