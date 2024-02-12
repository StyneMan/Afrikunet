import 'package:afrikunet/components/buttons/dropdown_button.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/formatted_textfield.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/bills.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/bills/pay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElectricityForm extends StatefulWidget {
  final List<BillNetwork> networks;
  final PreferenceManager manager;
  const ElectricityForm({
    Key? key,
    required this.networks,
    required this.manager,
  }) : super(key: key);

  @override
  State<ElectricityForm> createState() => _ElectricityFormState();
}

class _ElectricityFormState extends State<ElectricityForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _meterNumberController = TextEditingController();
  // var _selectedPackage;
  double? _selectedAmount;

  @override
  Widget build(BuildContext context) {
    print("KLJKB ::   ${_controller.cableTvPackageName.value}");

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          TextSmall(
            text: "Meter Number",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(
            height: 4.0,
          ),
          FormattedTextField(
            hintText: "e.g 0123 4567 89",
            onChanged: (value) {},
            controller: _meterNumberController,
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Meter number is required!";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24.0,
          ),
          TextSmall(
            text: "Email address",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(
            height: 4.0,
          ),
          CustomTextField(
            hintText: "",
            placeholder: "Enter email address",
            onChanged: (val) {},
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                  .hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 24.0,
          ),
          TextSmall(
            text: "Distributor",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(
            height: 4.0,
          ),
          Obx(
            () => DropDownButton(
              onPressed: () {
                Get.bottomSheet(
                  _bottomSheetContent,
                );
              },
              title: _controller.electricityDistributorName.value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _amountController.text.isEmpty ? " Select a distributor" : "",
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextSmall(
            text: "Amount",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(
            height: 4.0,
          ),
          RoundedInputMoney(
            hintText: "Amount",
            enabled: true,
            strokeColor: Constants.strokeColor,
            onChanged: (value) {
              if (value.toString().contains("-")) {
                setState(() {
                  _amountController.text = value.toString().replaceAll("-", "");
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
          const SizedBox(
            height: 24.0,
          ),
          TextSmall(
            text: "Phone number",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(
            height: 4.0,
          ),
          CustomTextField(
            inputType: TextInputType.number,
            placeholder: "Enter phone number",
            onChanged: (val) {},
            controller: _phoneController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              buttonText: "Proceed",
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Get.bottomSheet(_confirmBottomSheetContent);
                }
              },
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Container get _bottomSheetContent => Container(
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * 0.70,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextBody1(
                    text: "Select a distributor",
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
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Obx(
                    () => TextButton(
                      onPressed: () {
                        setState(() {
                          _controller.electricityDistributorName.value =
                              widget.networks[index].name;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 2.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/${widget.networks[index].logo}",
                                  width: 48,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  widget.networks[index].name,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Radio(
                            activeColor: Theme.of(context).colorScheme.tertiary,
                            value: widget.networks[index].name,
                            groupValue:
                                _controller.electricityDistributorName.value,
                            onChanged: (value) {
                              _controller.electricityDistributorName.value =
                                  (value as String?)!;
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: (widget.networks).length,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: PrimaryButton(
                    buttonText: "Done",
                    bgColor: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 15,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Container get _confirmBottomSheetContent => Container(
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * 0.70,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
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
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              DottedDivider(),
              const SizedBox(height: 16.0),
              Center(
                child: TextHeading(
                  text: "Customer Details",
                  color: Theme.of(context).colorScheme.tertiary,
                  align: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    _itemRow(title: "Customer Name", value: "Precious Wen"),
                    const SizedBox(height: 6.0),
                    const Divider(),
                    const SizedBox(height: 6.0),
                    _itemRow(title: "Meter Number", value: "58135805387"),
                    const SizedBox(height: 6.0),
                    const Divider(),
                    const SizedBox(height: 6.0),
                    _itemRow(title: "Address", value: "30 Ray Avenue, Ph"),
                    const SizedBox(height: 36.0),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: PrimaryButton(
                    buttonText: "Confirm",
                    fontSize: 15,
                    bgColor: Theme.of(context).colorScheme.primaryContainer,
                    onPressed: () {
                      Get.to(
                        PayNow(
                          title: 'Electricity Bill',
                          manager: widget.manager,
                        ),
                        transition: Transition.cupertino,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 21.0),
            ],
          ),
        ),
      );

  Widget _itemRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextBody1(
          text: title,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        TextBody1(
          text: value,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ],
    );
  }
}
