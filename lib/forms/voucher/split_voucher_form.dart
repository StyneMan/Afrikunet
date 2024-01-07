import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textarea2.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/material.dart';

class SplitVoucherForm extends StatelessWidget {
  SplitVoucherForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  // final _controller = Get.find<StateController>();
  final _numberController = TextEditingController();
  final _amountController = TextEditingController();
  final _usersController = TextEditingController();
  final _noteController = TextEditingController();

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
            enabled: false,
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
          TextSmall(text: "Number of splits"),
          const SizedBox(
            height: 4.0,
          ),
          CustomTextField(
            inputType: TextInputType.number,
            placeholder: "e.g 2",
            onChanged: (val) {},
            controller: _numberController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter number of splits';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          TextSmall(text: "Users"),
          const SizedBox(
            height: 4.0,
          ),
          CustomTextArea2(
            hintText: "",
            onChanged: (value) {},
            controller: _usersController,
            validator: (value) {},
            inputType: TextInputType.emailAddress,
            maxLines: 3,
            borderRadius: 6.0,
          ),
          const SizedBox(
            height: 16.0,
          ),
          TextSmall(text: "Note"),
          const SizedBox(
            height: 4.0,
          ),
          CustomTextArea2(
            hintText: "",
            onChanged: (value) {},
            controller: _noteController,
            validator: (value) {},
            inputType: TextInputType.text,
            maxLines: 3,
            borderRadius: 6.0,
            capitalization: TextCapitalization.sentences,
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
