import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/card/card_utils.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/formatters/card_date_formatter.dart';
import 'package:afrikunet/helper/formatters/card_number_formatter.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum CardType {
  Master,
  Visa,
  Verve,
  Discover,
  AmericanExpress,
  DinersClub,
  Jcb,
  Others,
  Invalid
}

class PaymentOptions extends StatefulWidget {
  final PreferenceManager manager;
  const PaymentOptions({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  final _controller = Get.find<StateController>();

  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expiryController = TextEditingController();

  // final plugin = PaystackPlugin();
  CardType cardType = CardType.Invalid;
  final _formKey = GlobalKey<FormState>();

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
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 16.0),
              Text(
                "Payment Options",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 24.0),
              TextSmall(
                text: "Card Number",
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(
                height: 4.0,
              ),
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                  CardNumberInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: "e.g 1234 5678",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Constants.strokeColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    gapPadding: 4.0,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Constants.strokeColor, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    gapPadding: 4.0,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Constants.strokeColor, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    gapPadding: 4.0,
                  ),
                  filled: false,
                  focusColor: Constants.strokeColor,
                  hintStyle: const TextStyle(
                    fontFamily: "OpenSans",
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CardUtils.getCardIcon(cardType),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    cardType = CardUtils.getCardTypeFrmNumber(value);
                  });
                },
                validator: (val) {
                  if (val.toString().isEmpty || val == null) {
                    return "Card number is required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              // CVV and Exp Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSmall(
                          text: "Exp.",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _expiryController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                            CardMonthInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            hintText: "MM/YY",
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 12.0,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Constants.strokeColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              gapPadding: 4.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants.strokeColor, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              gapPadding: 4.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants.strokeColor, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              gapPadding: 4.0,
                            ),
                            filled: false,
                            focusColor: Constants.strokeColor,
                            hintStyle: TextStyle(
                              fontFamily: "OpenSans",
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          validator: (val) {
                            if (val.toString().isEmpty || val == null) {
                              return "Expiry date is required";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSmall(
                          text: "CVV",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _cvvController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // Limit the input
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: const InputDecoration(
                            hintText: "CVV",
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 12.0,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Constants.strokeColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              gapPadding: 4.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants.strokeColor, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              gapPadding: 4.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants.strokeColor, width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              gapPadding: 4.0,
                            ),
                            filled: false,
                            focusColor: Constants.strokeColor,
                            hintStyle: TextStyle(
                              fontFamily: "OpenSans",
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          validator: (val) {
                            if (val.toString().isEmpty || val == null) {
                              return "CVV number is required";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.bottomSheet(_cvvBottomSheetContent);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextBody1(
                        text: "What is this?",
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 56.0,
              ),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  buttonText: "Pay",
                  fontSize: 15,
                  bgColor: Theme.of(context).colorScheme.primaryContainer,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _showOTPDialog();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showOTPDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => InfoDialog(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      CupertinoIcons.xmark_circle,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Center(
                child: Text(
                  "Enter Your Pin",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: 320,
                    child: PinCodeTextField(
                      appContext: context,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      pastedTextStyle: const TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 4,
                      autoFocus: true,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderWidth: 1.25,
                        fieldOuterPadding:
                            const EdgeInsets.symmetric(horizontal: 1.0),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        activeFillColor:
                            Theme.of(context).colorScheme.background,
                        activeColor:
                            Theme.of(context).colorScheme.inverseSurface,
                        inactiveColor: Colors.black45,
                      ),
                      cursorColor: Theme.of(context).colorScheme.tertiary,
                      animationDuration: const Duration(milliseconds: 300),
                      keyboardType: TextInputType.number,
                      boxShadows: null,
                      onCompleted: (v) {
                        // setState(() {
                        //   _shouldContinue = true;
                        // });
                        debugPrint("Completed");
                        Get.back();
                        _controller.isLoading.value = true;
                        Future.delayed(const Duration(seconds: 3), () {
                          _controller.isLoading.value = false;

                          Get.to(
                            SuccessPage(manager: widget.manager),
                            transition: Transition.cupertino,
                          );
                        });
                      },
                      onChanged: (value) {
                        // if (value.length < 4) {
                        //   setState(() {
                        //     _shouldContinue = false;
                        //   });
                        // }
                        debugPrint(value);
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                      autoDismissKeyboard: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: TextBody1(
                  text: "Insert Pin to complete this purchase",
                  color: const Color(0xFF575757),
                  align: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 72,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container get _cvvBottomSheetContent => Container(
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * 0.45,
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
                      size: 21,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              DottedDivider(),
              const SizedBox(height: 24.0),
              Center(
                child: TextHeading(
                  text: "What is CVV?",
                  color: Theme.of(context).colorScheme.tertiary,
                  align: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              TextBody1(
                text:
                    "CVV stands for Card Verification Value. It is a three or four-digit security code that is typically printed on the back of credit or debit cards.",
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 16.0),
              TextBody1(
                text:
                    "The CVV is an additional layer of security designed to protect against fraud in card-not-present transactions, such as online or over-the-phone purchases.",
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 21.0),
            ],
          ),
        ),
      );
}
