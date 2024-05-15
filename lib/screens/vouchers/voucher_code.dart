import 'dart:convert';

import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import 'widgets/sheets/bottom_sheet_content.dart';
import 'widgets/sheets/redeemable_africa_bottom_sheet.dart';

class VoucherCode extends StatefulWidget {
  final PreferenceManager manager;
  const VoucherCode({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<VoucherCode> createState() => _VoucherCodeState();
}

class _VoucherCodeState extends State<VoucherCode> {
  final _formKey = GlobalKey<FormState>();

  var _countryCode = "NG", _errorMsg = "";
  var _data = {};

  final _controller = Get.find<StateController>();
  final _inputController = TextEditingController();

  _validate() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      _controller.setLoading(true);

      final _validateResponse = await APIService().validateVoucherCode(
        accessToken: widget.manager.getAccessToken(),
        voucherCode: _inputController.text,
      );
      _controller.setLoading(false);
      debugPrint("VSLIDATE RESPONSE :::  ${_validateResponse.body}");

      Map<String, dynamic> map = jsonDecode(_validateResponse.body);
      // Constants.toast(map['message']);

      if ("${map['message']}".toLowerCase() == "voucher has been used") {
        _showErrorDialog(status: 'used', message: map['message']);
      } else if ("${map['message']}".toLowerCase().contains("exist")) {
        _showErrorDialog(status: 'invalid', message: map['message']);
      } else {
        // Now show bottom sheet here
        setState(() {
          _data = map['data'];
        });
        _showBankBottomSheet();
      }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  _showErrorDialog({var status, var message}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => InfoDialog(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40.0),
                status == "used"
                    ? Icon(
                        CupertinoIcons.info_circle,
                        size: 84,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    : Icon(
                        CupertinoIcons.xmark_circle_fill,
                        size: 84,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                const SizedBox(height: 10.0),
                TextMedium(
                  text: status == "used" ? "$message" : "Invalid Voucher",
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
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
                  text: "Voucher Code",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                Center(
                  child: TextMedium(
                    text: "Enter your voucher code",
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 21.0),
                Row(
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
                        countryFilter: const [
                          'NG',
                          'GH',
                          'ET',
                          'EG',
                          'MW',
                          'KE',
                          'RW',
                          'ZA',
                          'TZ',
                          'US',
                          'UG',
                          'SL'
                        ],
                        showCountryOnly: true,
                        showFlag: true,
                        showDropDownButton: true,
                        hideMainText: true,
                        showOnlyCountryWhenClosed: false,
                      ),
                    ),
                    Expanded(
                      child: CustomTextField(
                        onChanged: (val) {
                          if (val.isEmpty) {
                            setState(
                              () => _errorMsg = "Voucher code is required",
                            );
                          } else if (val.length < 12) {
                            setState(
                              () => _errorMsg = "12 characters required",
                            );
                          } else {
                            setState(
                              () {
                                _errorMsg = "";
                              },
                            );
                            _validate();
                          }
                        },
                        controller: _inputController,
                        errorText: _errorMsg,
                        hintText: 'E.g: 0GPKZBGFQG5P',
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Voucher code is required';
                          // }
                          // if (value.toString().length < 12) {
                          //   return '12 characters required';
                          // }
                          // return null;
                        },
                        inputType: TextInputType.text,
                        capitalization: TextCapitalization.characters,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: TextButton(
                    onPressed: () {
                      Get.bottomSheet(const RedeemableInAfricaSheet());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.info,
                          size: 16,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        const SizedBox(width: 4.0),
                        TextBody1(
                          text: "Only redeemable in Africa and the US",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(width: 8.0),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showBankBottomSheet() {
    double sheetHeight = MediaQuery.of(context).size.height * 0.75;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: sheetHeight,
          width: double.infinity,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: VoucherBottomSheet(
              manager: widget.manager,
              data: _data,
              voucherCode: _inputController.text,
            ),
          ),
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
