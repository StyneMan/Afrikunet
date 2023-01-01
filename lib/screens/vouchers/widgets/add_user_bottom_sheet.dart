import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/contacts/phone_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class AddUserBottomSheet extends StatefulWidget {
  const AddUserBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddUserBottomSheet> createState() => _AddUserBottomSheetState();
}

class _AddUserBottomSheetState extends State<AddUserBottomSheet> {
  final _emailWhatsappController = TextEditingController();
  final _amountController = TextEditingController();
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextMedium(
                    text: "Add User",
                    fontWeight: FontWeight.w600,
                  ),
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
            const SizedBox(
              height: 16.0,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBody1(text: "Email/Whatsapp Number"),
                  const SizedBox(
                    height: 4.0,
                  ),
                  CustomTextField(
                    onChanged: (val) {},
                    placeholder: "Enter email address or whatsapp number",
                    controller: _emailWhatsappController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email or whatsapp phone number';
                      }

                      if (value.toString().startsWith(RegExp(r'[a-z]'))) {
                        if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                            .hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                      }
                      if (value.toString().startsWith(RegExp(r'[0-9]'))) {
                        if (value.toString().length < 10) {
                          return 'Enter a valid whatsapp number';
                        }
                      }

                      return null;
                    },
                    inputType: TextInputType.text,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (await FlutterContacts.requestPermission()) {
                            Get.to(
                              const PhoneContacts(),
                              transition: Transition.cupertino,
                            );
                            // final contact =
                            //     await FlutterContacts.openExternalPick();

                            // debugPrint("SELECTED CONTACT ::: ${contact}");
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 5.0,
                          ),
                        ),
                        child: TextBody2(
                          text: "Add from contact",
                          color: Constants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextBody1(text: "Amount to Pay"),
                  const SizedBox(
                    height: 4.0,
                  ),
                  RoundedInputMoney(
                    hintText: "Amount",
                    enabled: true,
                    onChanged: (value) {
                      if (value.toString().contains("-")) {
                        setState(() {
                          _amountController.text =
                              value.toString().replaceAll("-", "");
                        });
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
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      fontSize: 15,
                      buttonText: "Continue",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Get.back();
                          _controller.setLoading(true);
                          Future.delayed(const Duration(seconds: 3), () {
                            _controller.setLoading(false);
                            _addMoreUser();
                            _showDialog();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  _addMoreUser() async {
    _controller.usersVoucherSplit.add({
      "email_phone": _emailWhatsappController.text,
      "amount": _amountController.text,
    });

    _amountController.clear();
    _emailWhatsappController.clear();
  }

  _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => InfoDialog(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24.0),
                SvgPicture.asset("assets/images/check_all.svg"),
                const SizedBox(height: 10.0),
                TextSmall(
                  text:
                      "You have successfully added ${_emailWhatsappController.text} to split ${_amountController.text} voucher ",
                  align: TextAlign.center,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  child: PrimaryButton(
                    buttonText: "Done",
                    fontSize: 15,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
