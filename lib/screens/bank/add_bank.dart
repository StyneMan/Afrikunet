import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/inputfield/bank_dropdown.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/banks/banks.dart';
import 'package:afrikunet/forms/bank/add_bank.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/add_bank_sheet.dart';

class AddBank extends StatefulWidget {
  AddBank({Key? key}) : super(key: key);

  @override
  State<AddBank> createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  final _accController = TextEditingController();
  var _selectedBank = "";
  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  CupertinoIcons.back,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            TextMedium(
              text: "Add Bank",
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: _controller.banks.value.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/empty.png"),
                    TextSmall(
                      text: "No bank account added",
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _showBottomSheet();
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
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const SizedBox(height: 24.0),
                  TextSmall(
                    text: "Select Bank",
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 4.0),
                  BankCustomDropdown(
                    items: banks,
                    hint: "",
                    onSelected: (value) {
                      setState(() {
                        _selectedBank = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24.0),
                  TextSmall(
                    text: "Account Number",
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 4.0),
                  CustomTextField(
                    hintText: "",
                    placeholder: "Enter account number",
                    onChanged: (val) {},
                    controller: _accController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your account numbber';
                      }

                      return null;
                    },
                    inputType: TextInputType.number,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  PrimaryButton(
                    buttonText: "Save",
                    fontSize: 15,
                    bgColor: Theme.of(context).colorScheme.primaryContainer,
                    onPressed: _accController.text.isNotEmpty &&
                            _selectedBank.isNotEmpty
                        ? () {}
                        : null,
                  ),
                ],
              ),
      ),
    );
  }

  _showBottomSheet() {
    double sheetHeight = MediaQuery.of(context).size.height * 0.75;

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
  }
}
