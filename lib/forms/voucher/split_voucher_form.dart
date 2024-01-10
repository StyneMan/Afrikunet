import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textarea2.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/screens/vouchers/widgets/add_user_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplitVoucherForm extends StatelessWidget {
  SplitVoucherForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  // final _controller = Get.find<StateController>();
  final _amountController = TextEditingController();
  final _amountPayingController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSmall(text: "Amount to split"),
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
          const SizedBox(
            height: 16.0,
          ),
          TextSmall(text: "Amount I'm Paying"),
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
            controller: _amountPayingController,
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
          const SizedBox(
            height: 16.0,
          ),
          TextSmall(text: "Purpose of Split"),
          const SizedBox(
            height: 4.0,
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
          const SizedBox(height: 2.0),
          SizedBox(
            width: 100,
            child: TextButton(
              onPressed: () {
                Get.bottomSheet(
                  AddUserBottomSheet(),
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
                    text: "Add User ",
                    color: Constants.primaryColor,
                  ),
                  const SizedBox(width: 3.0),
                  const Icon(CupertinoIcons.add, size: 14)
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              buttonText: "Proceed",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Get.to(
                  //   const PayNow(
                  //     title: 'Cable TV',
                  //   ),
                  //   transition: Transition.cupertino,
                  // );
                }
              },
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
