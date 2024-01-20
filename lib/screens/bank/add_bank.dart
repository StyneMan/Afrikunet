import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/inputfield/bank_dropdown.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/banks/banks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBank extends StatefulWidget {
  AddBank({Key? key}) : super(key: key);

  @override
  State<AddBank> createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  final _accController = TextEditingController();
  var _selectedBank = "";

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
        child: ListView(
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
              onPressed:
                  _accController.text.isNotEmpty && _selectedBank.isNotEmpty
                      ? () {}
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
