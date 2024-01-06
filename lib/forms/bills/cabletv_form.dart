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
          TextSmall(text: "Smartcard Number"),
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
          TextSmall(text: "${widget.network.name} Packages"),
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
          TextSmall(text: "Amount"),
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Get.to(
                    const PayNow(
                      title: 'Cable TV',
                    ),
                    transition: Transition.cupertino,
                  );
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextBody1(
                    text: "Select a Package",
                    color: Colors.black,
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
                                ),
                                Text(
                                  "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(widget.network.packages![index].amount)}",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Radio(
                            activeColor: Colors.black87,
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
}