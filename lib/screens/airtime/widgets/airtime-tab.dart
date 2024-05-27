import 'dart:convert';

import 'package:afrikunet/components/buttons/dropdown_button.dart';
import 'package:afrikunet/components/cards/micro_giftcard.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/inputfield/custom_phone_input.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/shimmer/circular_shimmer.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/constants/currencies.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/otp/verifyotp.dart';
import 'package:afrikunet/screens/vouchers/buy_voucher.dart';
import 'package:afrikunet/screens/vouchers/widgets/redeem_actions.dart';
// import 'package:afrikunet/screens/vouchers/widgets/sheets/my_vouchers_sheet.dart';
import 'package:afrikunet/screens/vouchers/widgets/sheets/redeemable_africa_bottom_sheet.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'amount_section.dart';
import 'networks_bottom_sheet.dart';

class AirtimeTab extends StatefulWidget {
  final PreferenceManager manager;
  const AirtimeTab({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<AirtimeTab> createState() => _AirtimeTabState();
}

class _AirtimeTabState extends State<AirtimeTab> {
  int _current = 10;
  String _countryCode = "+234",
      _errorMsg = "",
      _errText = "",
      _countryFlag = 'https://vtpass.com/resources/images/flags/NG.png';
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _controller = Get.find<StateController>();
  bool _isOpenInput = false;
  var _selectedCountry, _selectedVariation;
  bool _isLoadingProviders = true;
  bool _isAmountFixed = false;
  var _networkProviders = [];
  var _variationCodes = [];
  String _providerFlag = "", _dynamicPlaceholder = "", _dynamicAmount = '';
  RegExp regExp = RegExp(r'[^0-9.]');

  // Replace all non-numeric characters with an empty string
  // String numericData = data.replaceAll(regExp, '');

  @override
  void initState() {
    super.initState();
    _controller.filteredVTUCountries.value =
        _controller.internationVTUTopup.value;

    // Initialize selected airtime network to the first item
    if (_controller.airtimeData.isNotEmpty) {
      _controller.selectedAirtimeNetwork.value =
          _controller.airtimeData.value['networks'][0];
    }
  }

  _onClicked(bool value) {
    print('TEST VAL :: $value');
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _showInputSheet();
      }
    }
  }

  _onCountrySelected(val) async {
    print('SELECTED COUNTRY DATA ::: ::: $val');
    setState(() {
      _selectedCountry = val;
      _isLoadingProviders = true;
      _countryCode = "+${val['prefix']}";
      _variationCodes = [];
      _selectedVariation = null;
      _dynamicPlaceholder = "";
      _dynamicAmount = "";
    });

    // Now load operators for this country
    try {
      final _resp = await APIService().getCountryOperators(
        countryCode: val['country_code'],
        productTypeID: "${val['content'][0]['product_type_id']}",
      );
      debugPrint("COUNTRY OPERATORS DATA ::: ${_resp.body}");
      if (_resp.statusCode >= 200 && _resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_resp.body);
        setState(() {
          _isLoadingProviders = false;
          _networkProviders = map['content'];
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _isLoadingProviders = false;
      });
    }
  }

  _getVariationCode({
    required var operatorID,
    required var productTypeID,
  }) async {
    try {
      final _response = await APIService().getInternationalVariationCode(
        operatorID: operatorID,
        productTypeID: productTypeID,
      );
      print('"VARAITION CODE RESPONSE ::: ${_response.body}');

      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_response.body);
        setState(() {
          _variationCodes = map['content']['variations'];
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _controller.airtimeData.isEmpty
          ? const SizedBox()
          : ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(5.0),
              children: [
                TextSmall(
                  text: "Phone number",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                CustonPhoneInputWithSheet(
                  onChanged: (val) {},
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                  items: _controller.internationVTUTopup.value,
                  onSelected: _onCountrySelected,
                  caller: 'topup',
                ),
                const SizedBox(height: 8.0),
                TextSmall(
                  text: "Select your preferred network",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 4.0),
                _isLoadingProviders
                    ? GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        children: [
                          for (var i = 0; i < 4; i++) const CircularShimmer()
                        ],
                      )
                    : SizedBox(
                        height: 100,
                        child: GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          children: [
                            for (var i = 0; i < _networkProviders.length; i++)
                              Container(
                                height: 75,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: _current == i
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.transparent,
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _current = i;
                                      _providerFlag = _networkProviders[i]
                                          ['operator_image'];
                                    });
                                    _getVariationCode(
                                      operatorID:
                                          "${_networkProviders[i]['operator_id']}",
                                      productTypeID:
                                          "${_selectedCountry['content'][0]['product_type_id']}",
                                    );
                                  },
                                  child: Image.network(
                                    "${_networkProviders[i]['operator_image']}",
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                _variationCodes.isNotEmpty
                    ? TextSmall(
                        text: "Packages",
                        color: Theme.of(context).colorScheme.tertiary,
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 4.0,
                ),
                _variationCodes.isNotEmpty
                    ? DropDownButton(
                        onPressed: () {
                          Get.bottomSheet(
                            NetworkBottomSheet(
                              flag: _providerFlag,
                              items: _variationCodes,
                              onSelected: (value) {
                                print("AIR VALUE ::: $value ");
                                setState(() {
                                  _selectedVariation = value;
                                  _dynamicPlaceholder = value['name']
                                          .toString()
                                          .toLowerCase()
                                          .contains('enter')
                                      ? value['name']
                                      : "";

                                  _isAmountFixed = value['fixedPrice']
                                              .toString()
                                              .toLowerCase() ==
                                          "no"
                                      ? false
                                      : true;

                                  _amountController.text =
                                      value['variation_amount'] ?? "";
                                });
                              },
                            ),
                          );
                        },
                        title: _selectedVariation != null
                            ? "${_selectedVariation['name'] ?? ""} - ${_selectedVariation['variation_amount'] ?? ""}"
                            : "Select variation",
                      )
                    : const SizedBox(),
                _selectedVariation == null
                    ? const SizedBox()
                    : const SizedBox(height: 21.0),
                _selectedVariation == null
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextSmall(
                            text: "Amount",
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          TextSmall(
                            text:
                                "${_selectedVariation['variation_amount_min']} - ${_selectedVariation['variation_amount_max']}",
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ],
                      ),
                const SizedBox(height: 4.0),
                _selectedVariation == null
                    ? const SizedBox()
                    : RoundedInputMoney(
                        hintText: _dynamicPlaceholder,
                        enabled: !_isAmountFixed,
                        currencySymbol:
                            currencySymbols['${_selectedCountry['currency']}'],
                        onChanged: (value) {
                          if (value.toString().contains("-")) {}

                          if (int.parse(
                                  value.toString().replaceAll(regExp, '')) <
                              _selectedVariation['variation_amount_min']) {
                            setState(() {
                              _errText = 'Below min amount';
                            });
                          } else if (int.parse(
                                  value.toString().replaceAll(regExp, '')) >
                              _selectedVariation['variation_amount_max']) {
                            setState(() {
                              _errText = 'Above max amount';
                            });
                          } else {
                            setState(() {
                              _errText = '';
                            });
                          }
                        },
                        errorText: _errText,
                        controller: _amountController,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return "Amount is required!";
                          }
                          if (value.toString().contains("-")) {
                            return "Negative numbers not allowed";
                          }

                          print(
                              "REG EX :: ${value.runtimeType}  ${value.toString().replaceAll(regExp, '')}");

                          print(
                              "VARIATION CODE VALIDATOR :: ${_selectedVariation['variation_amount_min'].runtimeType} :::: ${_selectedVariation['variation_amount_min']}");

                          if (double.parse(
                                  value.toString().replaceAll(regExp, '')) <
                              double.parse(
                                  "${_selectedVariation['variation_amount_min']}")) {
                            return 'Below min amount';
                          }

                          if (double.parse(
                                  value.toString().replaceAll(regExp, '')) >
                              double.parse(
                                  "${_selectedVariation['variation_amount_max']}")) {
                            return 'Above max amount';
                          }
                          return null;
                        },
                      ),
                const SizedBox(height: 24.0),
                TextSmall(
                  text: "Pay with voucher",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 6.0),
                VoucherRedeemActions(
                  manager: widget.manager,
                  caller: 'utility',
                  onClicked: _onClicked,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _showVouchersBottomSheet(context);
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.add,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  _generateOTP({
    required String email,
  }) async {
    try {
      _controller.setLoading(true);
      final _response = await APIService().voucherGenerateOTP(
        accessToken: widget.manager.getAccessToken(),
        voucherCode: _inputController.text.trim(),
      );
      _controller.setLoading(false);
      print("SEND OTP RESPONSE HERE ${_response.body}");
      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_response.body);
        Constants.toast(map['message']);

        print("AMT CONTroLLeR VALUE ::: ${_amountController.text}");
        var _payload = {
          "serviceID": "foreign-airtime",
          "billersCode": _phoneController.text.trim(),
          "variation_code": _selectedVariation['variation_code'],
          "phone": _phoneController.text.trim(),
          "operator_id": _networkProviders[_current]['operator_id'],
          "country_code": _selectedCountry['country_code'],
          "product_type_id": _selectedCountry['content'][0]['product_type_id'],
          "email": widget.manager.getUser()['email_address'],
          "amount": double.parse(_amountController.text.replaceAll(regExp, '')),
        };

        print("SNJS PAYLOAD ::: $_payload");

        _controller.internationalTopupPayload.value = _payload;

        Get.back();
        Get.to(
          VerifyOTP(
            email: email,
            caller: 'vtu',
            manager: widget.manager,
            bankData: null,
            voucherCode: _inputController.text.trim(),
          ),
          transition: Transition.cupertino,
        );
      }
    } catch (e) {
      _controller.setLoading(false);
      print("$e");
    }
  }

  _validate() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      _controller.setLoading(true);

      final _validateResponse = await APIService().validateVoucherCode(
        accessToken: widget.manager.getAccessToken(),
        voucherCode: _inputController.text,
      );
      _controller.setLoading(false);
      debugPrint("VALIDATE RESPONSE :::  ${_validateResponse.body}");

      Map<String, dynamic> map = jsonDecode(_validateResponse.body);
      // Constants.toast(map['message']);

      print(
          "AMT CHECK :: ${double.parse(_amountController.text.replaceAll(regExp, ''))}");

      if ("${map['message']}".toLowerCase() == "voucher has been used") {
        _showErrorDialog(status: 'used', message: map['message']);
      } else if ("${map['message']}".toLowerCase().contains("exist")) {
        _showErrorDialog(status: 'invalid', message: map['message']);
      } else {
        // Check if amount matches voucher amount before generating OTP
        // Charging in naira
        final _exchangeRate = _selectedVariation['variation_rate'];
        final _chargedAmount = _selectedVariation['charged_amount'];
        final _fixedPrice = _selectedVariation['fixedPrice'];
        final _variationAmount = _selectedVariation['variation_amount'];

        if (_chargedAmount != null) {
          // Use the fixed amount here
          var _amount =
              double.parse(_amountController.text.replaceAll(regExp, ''));
          var _currencyToNaira = _amount * _exchangeRate;
          print("AMOUNT HERE :: ::: ::: $_currencyToNaira");
          // Now compare with the voucher redeemable amount
        }

        // if (double.parse("${map['data']['amount']}") !=
        //     double.parse(_amountController.text.replaceAll(regExp, ''))) {
        //   Constants.showInfoDialog(
        //     context: context,
        //     message:
        //         "Amount not equivalent to voucher amount of ${map['data']['amount']}",
        //     status: 'error',
        //   );
        // } else {
        // Now generate otp here
        _generateOTP(email: map['data']['email']);
        // }
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

  _showVouchersBottomSheet(var context) {
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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 14.0,
                ),
                child: _controller.userVouchers.value.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/empty.png"),
                            TextSmall(
                              text: "You have not purchased any vouchers",
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Get.to(
                                  BuyVoucher(
                                    manager: widget.manager,
                                  ),
                                );
                              },
                              icon: Icon(
                                CupertinoIcons.add,
                                size: 16,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              label: TextBody2(
                                text: "Buy voucher",
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(1.0),
                        itemBuilder: (context, index) {
                          final item = _controller.userVouchers.value[index];
                          return TextButton(
                            onPressed: () {
                              print('VOUCHER DATA HERE :::  $item');
                              setState(() {
                                _inputController.text = item['code'];
                              });
                              Get.back();
                              _showInputSheet();
                              Future.delayed(const Duration(seconds: 2), () {
                                _validate();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        height: 96,
                                        child: MicroGiftCard(
                                          amount: "${item['amount']}",
                                          bgType: item['bg_type'],
                                          code: item['code'],
                                          status: item['status'],
                                          type: item['type'],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16.0,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextSmall(
                                            text:
                                                "Voucher  ${item['code'].toString().substring(0, 4)}****",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                          ),
                                          TextBody2(
                                            text:
                                                "${Constants.formatDate("${item['created_at']}")} (${Constants.timeUntil(DateTime.parse(item['created_at']))})",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Column(
                          children: [
                            SizedBox(height: 16.0),
                            Divider(),
                            SizedBox(height: 16.0),
                          ],
                        ),
                        itemCount: _controller.userVouchers.value.length,
                      ),
              ),
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

  _showInputSheet() {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
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
                      validator: (value) {},
                      inputType: TextInputType.text,
                      capitalization: TextCapitalization.characters,
                    ),
                  ),
                ],
              ),
              SizedBox(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
