import 'package:afrikunet/components/buttons/dropdown_button.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/formatted_textfield.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/bills.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/bills/pay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CableTvForm extends StatefulWidget {
  final BillNetwork network;
  const CableTvForm({
    Key? key,
    required this.network,
  }) : super(key: key);

  @override
  State<CableTvForm> createState() => _CableTvFormState();
}

class _CableTvFormState extends State<CableTvForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _meterNumberController = TextEditingController();
  final _amountController = TextEditingController();
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
            text: "Smartcard Number",
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
                return "Smartcard number is required!";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24.0,
          ),
          TextSmall(
            text: "${widget.network.name} Packages",
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
              title: _controller.cableTvPackageName.value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _amountController.text.isEmpty ? " Select a package" : "",
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
                    text: "Select a Package",
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
                        // setState(() {
                        //   // _selectedPackage = widget.network.packages![index];
                        // });
                        _controller.cableTvAmount.value =
                            widget.network.packages![index].amount;
                        setState(() {
                          _amountController.text =
                              "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(widget.network.packages![index].amount)}";
                          _controller.cableTvPackageName.value =
                              widget.network.packages![index].name;
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
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextBody1(
                                  text: widget.network.packages![index].name,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                Text(
                                  "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(widget.network.packages![index].amount)}",
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
                            value: widget.network.packages![index].amount,
                            groupValue: _controller.cableTvAmount.value,
                            onChanged: (value) {
                              _controller.cableTvAmount.value =
                                  (value as double?)!;
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: (widget.network.packages ?? []).length,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: PrimaryButton(
                    buttonText: "Done",
                    fontSize: 15,
                    bgColor: Theme.of(context).colorScheme.primaryContainer,
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
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Colors.white,
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
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24.0),
                    _itemRow(title: "Customer Name", value: "Precious Wen"),
                    const SizedBox(height: 6.0),
                    const Divider(),
                    const SizedBox(height: 6.0),
                    _itemRow(title: "Customer Number", value: "58135805387"),
                    const SizedBox(height: 6.0),
                    const Divider(),
                    const SizedBox(height: 6.0),
                    _itemRow(title: "Due Date", value: "10th July, 2024"),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: PrimaryButton(
                    buttonText: "Confirm",
                    fontSize: 15,
                    bgColor: Theme.of(context).colorScheme.primaryContainer,
                    onPressed: () {
                      Get.to(
                        const PayNow(
                          title: 'Cable TV',
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
