import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/bank_dropdown.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/banks/banks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBankForm extends StatefulWidget {
  const AddBankForm({Key? key}) : super(key: key);

  @override
  State<AddBankForm> createState() => _AddBankFormState();
}

class _AddBankFormState extends State<AddBankForm> {
  var _selectedBank = "";
  final _accController = TextEditingController();
  bool _isValidating = false;
  bool _showName = false;

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
      child: ListView(
        padding: const EdgeInsets.all(16.0),
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
          const SizedBox(height: 21.0),
          TextSmall(
            text: "Select Bank",
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(height: 21.0),
          TextBody1(
            text: "Bank",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(height: 4.0),
          BankCustomDropdown(
            items: banks,
            hint: "",
            onSelected: (selected) {
              setState(() {
                _selectedBank = selected;
              });
            },
          ),
          const SizedBox(height: 16.0),
          TextBody1(
            text: "Account Number",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(height: 4.0),
          CustomTextField(
            onChanged: (value) {
              if (value.length >= 10) {
                // Trigger validation
                setState(() {
                  _isValidating = true;
                });
                Future.delayed(const Duration(seconds: 5), () {
                  setState(() {
                    _isValidating = false;
                    _showName = true;
                  });
                });
              } else {
                setState(() {
                  _isValidating = false;
                  _showName = false;
                });
              }
            },
            controller: _accController,
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Account number is required!";
              }
            },
            inputType: TextInputType.number,
          ),
          const SizedBox(height: 16.0),
          _showName
              ? TextSmall(
                  text: "Precious Odinga",
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.tertiary,
                )
              : const SizedBox(),
          const SizedBox(height: 48.0),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              buttonText: "Save Account",
              fontSize: 16,
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
