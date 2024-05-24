import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textarea2.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/currencies.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/bank/widgets/bank_card2.dart';
import 'package:afrikunet/screens/vouchers/widgets/sheets/add_user_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentLinkForm extends StatelessWidget {
  final PreferenceManager manager;
  PaymentLinkForm({
    Key? key,
    required this.manager,
  }) : super(key: key);

  final regExp = RegExp(r'[^0-9.]');
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();

  _generateLink() async {
    Get.back();
    _controller.setLoading(true);
    try {
      Map _payload = {
        "description": _reasonController.text,
        "amount": _amountController.text.replaceAll(regExp, ''),
        "user_id": manager.getUser()['email_address'],
        "user_photo": manager.getUser()['photo'],
        "status": "active",
        "country_code": _controller.userDefaultBank.value['iso3'],
        "bank_code": _controller.userDefaultBank.value['code'],
        "account_number": _controller.userDefaultBank.value['account_number'],
      };

      print("PAYLOAD CHECK ::: $_payload");

      final _response = await APIService().generatePayLink(
          accessToken: manager.getAccessToken(), payload: _payload);
      _controller.setLoading(false);
      print("LINK GEN RESPONSE ::: ${_response.body}");
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSmall(
            text: "Amount expected",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(
            height: 4.0,
          ),
          RoundedInputMoney(
            hintText: "Amount",
            enabled: true,
            strokeColor: Theme.of(context).colorScheme.tertiary,
            currencySymbol: currencySymbols['${'NGN'}'],
            onChanged: (value) {
              if (value.toString().contains("-")) {
                // setState(() {
                //   _amountController.text = value.toString().replaceAll("-", "");
                // });
              }
            },
            controller: _amountController,
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Amount is required!";
              }
              if (value.toString().contains("-")) {
                return "Negative numbers not allowed";
              }
              return null;
            },
          ),
          TextSmall(
            text: "Purpose of payment (optional)",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(
            height: 2.0,
          ),
          CustomTextArea2(
            hintText: "",
            onChanged: (value) {},
            controller: _reasonController,
            validator: (value) {},
            inputType: TextInputType.text,
            maxLines: 3,
            borderRadius: 6.0,
            capitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16.0),
          _controller.userDefaultBank.value.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextSmall(
                      text: "Receiving Bank",
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    BankCard2(
                      data: _controller.userDefaultBank.value,
                      index: 0,
                      list: [],
                      isChecked: true,
                    ),
                  ],
                )
              : Text(""),
          SizedBox(
            child: TextButton(
              onPressed: () {
                Get.bottomSheet(
                  const AddUserBottomSheet(),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextSmall(
                    text: "Change bank",
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 3.0),
                  Icon(
                    CupertinoIcons.add,
                    size: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          // Obx(
          //   () => ListView.separated(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemBuilder: (context, index) {
          //       return Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Column(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               TextSmall(
          //                 text:
          //                     "${_controller.usersVoucherSplit.value[index]['email_phone']}",
          //                 color: Constants.accentColor,
          //               ),
          //               TextBody1(
          //                 text:
          //                     "${_controller.usersVoucherSplit.value[index]['amount']} ≈ 4 units",
          //               ),
          //             ],
          //           ),
          //           IconButton(
          //             onPressed: () {
          //               // _showDeleteDialog(context: context, index: index);
          //             },
          //             icon: SvgPicture.asset("assets/images/delete.svg"),
          //           ),
          //         ],
          //       );
          //     },
          //     separatorBuilder: (context, index) => const Divider(),
          //     itemCount: _controller.usersVoucherSplit.length,
          //   ),
          // ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              buttonText: "Generate Redeem Link",
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _controller.userDefaultBank.value.isNotEmpty) {
                  Get.bottomSheet(_showConfirmation(context: context));
                } else if (_controller.userDefaultBank.value.isEmpty) {
                  // Constants.sh
                }
              },
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Container _showConfirmation({required var context}) => Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextSmall(
                    text: "Confirm Action",
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
              const SizedBox(height: 16.0),
              TextSmall(
                text:
                    "You are about to generate a redemption link you can share to your customer, family and friends. Are you sure you want to continue?",
                align: TextAlign.center,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  buttonText: "Continue",
                  bgColor: Theme.of(context).colorScheme.primaryContainer,
                  onPressed: () {
                    _generateLink();
                  },
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
}
