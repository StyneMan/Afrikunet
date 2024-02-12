import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/otp/verifyotp.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PreferredMethodBottomSheet extends StatefulWidget {
  final String title;
  final String caller;
  final PreferenceManager manager;
  const PreferredMethodBottomSheet({
    Key? key,
    required this.title,
    required this.caller,
    required this.manager,
  }) : super(key: key);

  @override
  State<PreferredMethodBottomSheet> createState() =>
      _PreferredMethodBottomSheetState();
}

class _PreferredMethodBottomSheetState
    extends State<PreferredMethodBottomSheet> {
  final _inputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  var _countryCode = "NG";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.caller == "phone"
          ? MediaQuery.of(context).size.height * 0.45
          : MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
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
                    size: 21,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            DottedDivider(),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  widget.caller == "phone"
                      ? TextHeading(
                          text: widget.title,
                          align: TextAlign.center,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      : TextSmall(
                          text: widget.title,
                          align: TextAlign.center,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                  const SizedBox(height: 36.0),
                  TextBody1(
                    text: widget.caller == "phone"
                        ? "WhatsApp number"
                        : "Enter Code",
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  SizedBox(height: widget.caller == "phone" ? 6.0 : 1.0),
                  widget.caller == "phone"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              child: CountryCodePicker(
                                alignLeft: false,
                                onChanged: (val) {
                                  setState(() {
                                    _countryCode = val as String;
                                  });
                                },
                                padding: const EdgeInsets.all(0.0),
                                initialSelection: 'NG',
                                favorite: const ['+234', 'NG'],
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
                                controller: _inputController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  if (value.toString().length < 10) {
                                    return 'Phone number is invalid';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.number,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: CustomTextField(
                            onChanged: (val) {},
                            controller: _inputController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Voucher code is required';
                              }
                              return null;
                            },
                            inputType: TextInputType.text,
                            capitalization: TextCapitalization.sentences,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PrimaryButton(
                fontSize: 15,
                buttonText: "Submit",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submit();
                  }
                },
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.back();
    try {
      _controller.setLoading(true);

      Future.delayed(
        const Duration(seconds: 3),
        () {
          _controller.setLoading(false);
          if (widget.caller == "phone") {
            // Show OTP screen here
            Get.to(
              VerifyOTP(
                email: _inputController.text,
                caller: "2fa",
                manager: widget.manager,
              ),
              transition: Transition.cupertino,
            );
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => InfoDialog(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 24.0,
                        ),
                        SvgPicture.asset("assets/images/check_all.svg"),
                        const SizedBox(height: 10.0),
                        TextSmall(
                          text:
                              "2FA successfully enabled. You can now login with 2FA.",
                          align: TextAlign.center,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          width: double.infinity,
                          child: PrimaryButton(
                            buttonText: "Done",
                            fontSize: 15,
                            onPressed: () {
                              Get.back();
                              Get.back();
                              Get.back();
                              Get.back();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
