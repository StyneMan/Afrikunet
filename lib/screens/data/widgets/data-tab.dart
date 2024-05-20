import 'dart:convert';

import 'package:afrikunet/components/buttons/dropdown_button.dart';
import 'package:afrikunet/components/cards/micro_giftcard.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/custom_phone_input.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/shimmer/banner_shimmer.dart';
import 'package:afrikunet/components/shimmer/circular_shimmer.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/airtime/widgets/networks_bottom_sheet.dart';
import 'package:afrikunet/screens/auth/otp/verifyotp.dart';
import 'package:afrikunet/screens/vouchers/buy_voucher.dart';
import 'package:afrikunet/screens/vouchers/widgets/redeem_actions.dart';
import 'package:afrikunet/screens/vouchers/widgets/sheets/redeemable_africa_bottom_sheet.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataTab extends StatefulWidget {
  final PreferenceManager manager;
  const DataTab({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<DataTab> createState() => _DataTabState();
}

class _DataTabState extends State<DataTab> {
  int _current = 10;
  // String _selectedNetworkName = "";
  var _currentPlans = [];
  String _selectedVariationCode = "";
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
  var _selectedCountry, _selectedVariation, _selectedProvider;
  bool _isLoadingProviders = true;
  bool _showNaija = true, _isAmountFixed = false;
  var _networkProviders = [];
  var _variationCodes = [];
  String _dynamicPlaceholder = "", _dynamicAmount = '';
  RegExp regExp = RegExp(r'[^0-9.]');

  @override
  void initState() {
    _controller.filteredVTUCountries.value =
        _controller.internationVTUData.value;
    super.initState();
    // Initialize selected airtime network to the first item
    if (_controller.internetData.isNotEmpty) {
      _controller.selectedDataNetwork.value =
          _controller.internetData.value['networks'][0];
    }
  }

  _generateServiceId(String name) {
    String serviceId = "";
    if (name.contains("9")) {
      serviceId = "etisalat-data";
    } else if (name.toLowerCase() != 'mtn' &&
        name.toLowerCase() != 'glo' &&
        name.toLowerCase() != 'airtel') {
      if (name.toLowerCase() == 'smile') {
        serviceId = "${name.toLowerCase()}-direct";
      } else {
        serviceId = name.toLowerCase();
      }
    } else {
      serviceId = "${name.toLowerCase()}-data";
    }
    return serviceId;
  }

  _fetchCurrentPlan(String name) async {
    _controller.isLoadingPackages.value = true;
    try {
      final _response =
          await APIService().getPlans('${_generateServiceId(name)}');
      print("FECTHED ::: ${_response.body}");
      _controller.isLoadingPackages.value = false;
      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_response.body);
        setState(() {
          _currentPlans = map['data']['content']['varations'];
        });
      }
    } catch (e) {
      print("ERROR ==> $e");
      _controller.isLoadingPackages.value = false;
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
      _showNaija = val['prefix'] == '234' ? true : false;
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
      child: _controller.internetData.isEmpty
          ? const SizedBox()
          : Obx(
              () => ListView(
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
                    items: _controller.filteredVTUCountries.value,
                    onSelected: _onCountrySelected,
                    caller: 'data',
                  ),
                  const SizedBox(height: 8.0),
                  TextSmall(
                    text: "Select your preferred network",
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  _showNaija
                      ? SizedBox(
                          child: GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            children: [
                              for (var i = 0;
                                  i <
                                      _controller.internetData.value['networks']
                                          .length;
                                  i++)
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
                                      setState(() => _current = i);
                                      _controller.selectedDataNetwork.value =
                                          _controller.internetData
                                              .value['networks'][i];

                                      setState(() {
                                        _currentPlans = [];
                                        _selectedVariationCode = "";
                                      });

                                      _controller.selectedDataPlan.value = {};

                                      _fetchCurrentPlan(_controller.internetData
                                          .value['networks'][i]['name']);
                                    },
                                    child: Image.network(
                                      "${_controller.internetData.value['networks'][i]['icon']}",
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : _isLoadingProviders
                          ? GridView.count(
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              children: [
                                for (var i = 0; i < 4; i++)
                                  const CircularShimmer()
                              ],
                            )
                          : SizedBox(
                              height: 100,
                              child: GridView.count(
                                crossAxisCount: 4,
                                shrinkWrap: true,
                                children: [
                                  for (var i = 0;
                                      i < _networkProviders.length;
                                      i++)
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
                                            _selectedProvider =
                                                _networkProviders[i];
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
                  // const SizedBox(height: 18.0),
                  _showNaija
                      ? TextSmall(
                          text: _current == 10
                              ? 'Select network first'
                              : 'Select a data bundle for ' +
                                  _controller.selectedDataNetwork.value['name'],
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      : const SizedBox(),
                  _showNaija
                      ? Obx(
                          () => DropDownButton(
                            onPressed: _current == 6
                                ? () {
                                    Constants.showInfoDialog(
                                      context: context,
                                      message:
                                          "To continue, select a network first!",
                                      status: 'error',
                                    );
                                  }
                                : () {
                                    Get.bottomSheet(
                                      _bottomSheetContent,
                                    );
                                  },
                            title:
                                '${_selectedVariationCode.isEmpty ? _controller.selectedDataNetwork.value['name'] : _controller.selectedDataPlan.value['name'].toString().length > 48 ? _controller.selectedDataPlan.value['name'].toString().substring(0, 48) + '...' : _controller.selectedDataPlan.value['name']}',
                          ),
                        )
                      : _variationCodes.isNotEmpty
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
                                flag: _selectedProvider['operator_image'],
                                items: _variationCodes,
                                onSelected: (value) {
                                  print("AIR VALUE ::: ${value} ");
                                  setState(
                                    () {
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
                                    },
                                  );
                                },
                              ),
                            );
                          },
                          title: _selectedVariation != null
                              ? "${_selectedVariation['name'] ?? ""} - ${_selectedVariation['variation_amount'] ?? ""}"
                                          .length >
                                      26
                                  ? "${_selectedVariation['name'] ?? ""} - ${_selectedVariation['variation_amount'] ?? ""}"
                                          .substring(0, 24) +
                                      "..."
                                  : "${_selectedVariation['name'] ?? ""} - ${_selectedVariation['variation_amount'] ?? ""}"
                              : "Select variation",
                        )
                      : const SizedBox(),
                  _selectedVariation == null
                      ? const SizedBox()
                      : const SizedBox(height: 21.0),
                  const SizedBox(
                    height: 8.0,
                  ),
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
                  _showNaija && _controller.selectedDataPlan.value.isNotEmpty
                      ? TextSmall(
                          text: "Amount",
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 4.0,
                  ),
                  _selectedVariation == null
                      ? const SizedBox()
                      : RoundedInputMoney(
                          hintText: "Amount",
                          enabled: false,
                          onChanged: (value) {
                            if (value.toString().contains("-")) {}
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
                  _showNaija && _controller.selectedDataPlan.value.isNotEmpty
                      ? RoundedInputMoney(
                          hintText: "Amount",
                          enabled: false,
                          onChanged: (value) {
                            if (value.toString().contains("-")) {}
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
                        )
                      : const SizedBox(),
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
            ),
    );
  }

  Container get _bottomSheetContent => Container(
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * 0.84,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16.0),
                    _controller.isLoadingPackages.value
                        ? ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 24.0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: const BannerShimmer(),
                                  ),
                                  const SizedBox(
                                    height: 21.0,
                                    width: 16,
                                    child: BannerShimmer(),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: 5,
                          )
                        : _currentPlans.isEmpty
                            ? const SizedBox(height: 16.0)
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return _currentPlans.isEmpty
                                      ? const SizedBox()
                                      : Obx(
                                          () => TextButton(
                                            onPressed: () {
                                              _controller.selectedDataPlan
                                                  .value = _currentPlans[index];

                                              setState(() {
                                                _selectedVariationCode =
                                                    _currentPlans[index]
                                                        ['variation_code'];
                                              });

                                              setState(() {
                                                _amountController.text =
                                                    "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(_currentPlans[index]['variation_amount']))}";
                                              });

                                              _controller.internetDataAmount
                                                      .value =
                                                  double.parse(
                                                      "${_currentPlans[index]['variation_amount']}");

                                              // Future.delayed(
                                              //     const Duration(seconds: 1),
                                              //     () {
                                              Get.back();
                                              // });
                                            },
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 0.0,
                                                vertical: 2.0,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextBody1(
                                                        text: '${_currentPlans[index]['name']}'
                                                                    .capitalize!
                                                                    .length >
                                                                40
                                                            ? '${_currentPlans[index]['name']}'
                                                                    .capitalize!
                                                                    .substring(
                                                                        0, 40) +
                                                                "..."
                                                            : '${_currentPlans[index]['name']}'
                                                                .capitalize,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiary,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Radio(
                                                  activeColor: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  value: _currentPlans[index]
                                                      ['variation_code'],
                                                  groupValue: _controller
                                                      .selectedDataPlan
                                                      .value['variation_code'],
                                                  onChanged: null,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: (_currentPlans).length,
                              ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      );

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

        if (_showNaija) {
          Map _payload = {
            "serviceID":
                "${_controller.selectedDataNetwork.value['vtpass_code']}",
            "phone": int.parse(_phoneController.text.trim()),
            "email": "${widget.manager.getUser()['email_address']}",
            "amount": int.parse(_amountController.text.replaceAll(regExp, '')),
            "billersCode": _phoneController.text.trim(),
            "variation_code": _showNaija
                ? _controller.selectedDataPlan.value['variation_code']
                : _selectedVariation['variation_code'],
          };

          _controller.internationalTopupPayload.value = _payload;

          Get.back();
          Get.to(
            VerifyOTP(
              email: email,
              caller: 'vtu',
              manager: widget.manager,
              bankData: null,
              vtuType: "data",
              voucherCode: _inputController.text.trim(),
            ),
            transition: Transition.cupertino,
          );
        } else {
          var _payload = {
            "serviceID": "foreign-airtime",
            "billersCode": _phoneController.text.trim(),
            "variation_code": _selectedVariation['variation_code'],
            "phone": _phoneController.text.trim(),
            "operator_id": _networkProviders[_current]['operator_id'],
            "country_code": _selectedCountry['country_code'],
            "product_type_id": _selectedCountry['content'][0]
                ['product_type_id'],
            "email": widget.manager.getUser()['email_address'],
            "amount":
                double.parse(_amountController.text.replaceAll(regExp, '')),
          };

          print("SNJS PAYLOAD ::: ${_payload}");

          _controller.internationalTopupPayload.value = _payload;

          Get.back();
          Get.to(
            VerifyOTP(
              email: email,
              caller: 'vtu',
              manager: widget.manager,
              bankData: null,
              vtuType: "data",
              voucherCode: _inputController.text.trim(),
            ),
            transition: Transition.cupertino,
          );
        }
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

      if ("${map['message']}".toLowerCase() == "voucher has been used") {
        _showErrorDialog(status: 'used', message: map['message']);
      } else if ("${map['message']}".toLowerCase().contains("exist")) {
        _showErrorDialog(status: 'invalid', message: map['message']);
      } else {
        // Now generate otp here
        _generateOTP(email: map['data']['email']);
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
                              print('VOUCHER DATA HERE :::  ${item}');
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


/*
SizedBox(height: MediaQuery.of(context).size.height * 0.225),
                PrimaryButton(
                  fontSize: 15,
                  bgColor: Theme.of(context).colorScheme.primaryContainer,
                  buttonText: "Pay",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          height: MediaQuery.of(context).size.height * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(21),
                              topRight: Radius.circular(21),
                            ),
                            color: Theme.of(context).colorScheme.surface,
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
                                      size: 21,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              DottedDivider(),
                              const SizedBox(height: 16.0),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          CupertinoIcons.exclamationmark_circle,
                                          size: 75,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface,
                                        ),
                                        const SizedBox(height: 16.0),
                                        SizedBox(
                                          width: 256,
                                          child: Text(
                                            "You are about to purchase ${_controller.selectedDataPlan.value['name']} for this phone number ${_phoneController.text}.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 24.0),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: PrimaryButton(
                                          buttonText: "Confirm",
                                          fontSize: 15,
                                          onPressed: () {
                                            Get.back();
                                            Get.to(
                                              PayNow(
                                                title: 'Data Subscription',
                                                manager: widget.manager,
                                                customerData: {},
                                                payload: {
                                                  "type": "data",
                                                  "amount": double.parse(
                                                    _controller.selectedDataPlan
                                                            .value[
                                                        'variation_amount'],
                                                  ),
                                                  "billersCode":
                                                      _phoneController.text,
                                                  "variation_code":
                                                      _selectedVariationCode,
                                                  "phone":
                                                      _phoneController.text,
                                                  "name": _controller
                                                      .selectedDataNetwork
                                                      .value['name']
                                                      .toLowerCase(),
                                                  "product_type_id": int.parse(
                                                      _controller.internetData
                                                          .value['id']),
                                                  "network_id": _controller
                                                      .selectedDataNetwork
                                                      .value['id'],
                                                  "otherParams": {
                                                    "billersCode":
                                                        _phoneController.text,
                                                    "variation_code":
                                                        _selectedVariationCode,
                                                  }
                                                },
                                                dataVal: _controller
                                                    .selectedDataPlan
                                                    .value['name'],
                                              ),
                                              transition: Transition.cupertino,
                                            );
                                            // _sendRequest();
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

*/