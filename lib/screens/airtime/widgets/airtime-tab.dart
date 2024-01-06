import 'package:afrikunet/components/buttons/action.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/networks.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/screens/success_screen.dart';
import 'package:afrikunet/screens/vouchers/widgets/payment_method.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirtimeTab extends StatefulWidget {
  const AirtimeTab({Key? key}) : super(key: key);

  @override
  State<AirtimeTab> createState() => _AirtimeTabState();
}

class _AirtimeTabState extends State<AirtimeTab> {
  int _current = 0;
  String _countryCode = "+234";
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(5.0),
        children: [
          TextSmall(text: "Select your preferred network"),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var i = 0; i < networksAirtime.length; i++)
                  Expanded(
                    child: Container(
                      height: 75,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: _current == i
                              ? Constants.primaryColor
                              : Colors.transparent,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() => _current = i);
                        },
                        child: Image.asset(
                          "assets/images/${networksAirtime[i].icon}",
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18.0),
          TextSmall(text: "Phone number"),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 75,
                child: CountryCodePicker(
                  alignLeft: false,
                  onChanged: (val) {
                    setState(() {
                      _countryCode = val as String;
                    });
                  },
                  padding: const EdgeInsets.all(0.0),
                  initialSelection: 'NG',
                  favorite: ['+234', 'NG'],
                  showCountryOnly: true,
                  showFlag: true,
                  showDropDownButton: true,
                  hideMainText: true,
                  showOnlyCountryWhenClosed: false,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: CustomTextField(
                  onChanged: (val) {},
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                  inputType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          TextSmall(
            text:
                "How much ${networksAirtime[_current].name} airtime are you buying?",
          ),
          _amountSection(context),
          const SizedBox(height: 24.0),
          const PaymentMethod(),
          const SizedBox(height: 16.0),
          PrimaryButton(
            fontSize: 15,
            buttonText: "Pay",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.height * 0.8,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(21),
                        topRight: Radius.circular(21),
                      ),
                      color: Colors.white,
                    ),
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
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        DottedDivider(),
                        const SizedBox(height: 16.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Icon(
                                    CupertinoIcons.exclamationmark_circle,
                                    size: 75,
                                    color: Constants.primaryColor,
                                  ),
                                  const SizedBox(height: 16.0),
                                  SizedBox(
                                    width: 256,
                                    child: Text(
                                      "You are about to recharge ${_amountController.text} from access bank to this phone number ${_phoneController.text}.",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 24.0),
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: PrimaryButton(
                                    buttonText: "Confirm",
                                    onPressed: () {
                                      Get.back();
                                      Get.to(
                                        const SuccessPage(
                                          isVoucher: false,
                                        ),
                                        transition: Transition.cupertino,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _amountSection(context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 6.0,
          ),
          RoundedInputMoney(
            hintText: "Amount",
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
            height: 6.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ActionButton(
                  strokeColor: Colors.black,
                  icon: const Text(
                    "₦200",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 10,
                  onPressed: () {
                    setState(() {
                      _amountController.text = "₦200";
                    });
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ActionButton(
                  strokeColor: Colors.black,
                  icon: const Text(
                    "₦300",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 10,
                  onPressed: () {
                    setState(() {
                      _amountController.text = "₦300";
                    });
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ActionButton(
                  radius: 10,
                  strokeColor: Colors.black,
                  icon: const Text(
                    "₦500",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _amountController.text = "₦500";
                    });
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ActionButton(
                  strokeColor: Colors.black,
                  icon: const Text(
                    "₦1000",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 10,
                  onPressed: () {
                    setState(() {
                      _amountController.text = "₦1,000";
                    });
                  },
                ),
              ),
            ],
          )
        ],
      );
}
