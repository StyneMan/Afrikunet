import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUserBottomSheet extends StatelessWidget {
  AddUserBottomSheet({Key? key}) : super(key: key);

  final _emailWhatsappController = TextEditingController();
  final _amountController = TextEditingController();
  final _controller = Get.find<StateController>();

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
                      onPressed: () {},
                      child: TextBody2(
                        text: "Add from contact",
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
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
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    fontSize: 15,
                    buttonText: "Continue",
                    onPressed: () {
                      Get.back();
                      _controller.setLoading(true);
                      Future.delayed(const Duration(seconds: 3), () {
                        _controller.setLoading(false);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
