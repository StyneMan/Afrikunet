import 'dart:convert';

import 'package:afrikunet/components/buttons/dropdown_button.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/cards/micro_giftcard.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/formatted_textfield.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/shimmer/banner_shimmer.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/bills.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/otp/verifyotp.dart';
import 'package:afrikunet/screens/bills/pay.dart';
import 'package:afrikunet/screens/vouchers/buy_voucher.dart';
import 'package:afrikunet/screens/vouchers/widgets/redeem_actions.dart';
import 'package:afrikunet/screens/vouchers/widgets/sheets/redeemable_africa_bottom_sheet.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CableTvForm extends StatefulWidget {
  final BillNetwork network;
  final PreferenceManager manager;
  const CableTvForm({
    Key? key,
    required this.network,
    required this.manager,
  }) : super(key: key);

  @override
  State<CableTvForm> createState() => _CableTvFormState();
}

class _CableTvFormState extends State<CableTvForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _smartcardNumController = TextEditingController();
  final _amountController = TextEditingController();
  final _inputController = TextEditingController();
  int _current = 0;
  double? _selectedAmount;
  var _currentPlans = [];
  String _selectedVariationCode = "";
  RegExp regExp = RegExp(r'[^0-9.]');
  String _countryCode = "+234",
      _errorMsg = "",
      _errText = "",
      _countryFlag = 'https://vtpass.com/resources/images/flags/NG.png';

  Map _payload = {};

  _sendRequest() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);

    try {
      _payload = {
        "type": "cable_tv",
        "amount": double.parse(
            _controller.selectedCableBouquet.value['variation_amount']),
        "otherParams": {
          "billersCode":
              int.parse(_smartcardNumController.text.replaceAll(" ", "")),
          "variation_code": _selectedVariationCode,
        },
        "phone": widget.manager.getUser()['international_phone_format'],
        "name": _controller.selectedCableNetwork.value['name'].toLowerCase(),
        "product_type_id": int.parse(_controller.cableData.value['id']),
        "network_id": _controller.selectedCableNetwork.value['id'],
      };

      print("JUST C jhsdj ${_payload}");

      final _response = await APIService()
          .initVtuRequest(widget.manager.getAccessToken(), _payload);
      print("DATA REQUEST REPONSE :: ${_response.body}");
      _controller.setLoading(false);

      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_response.body);

        Constants.toast('${map['message']}');

        _controller.onInit();

        if ('${map['message']}'.toLowerCase().contains('verified')) {
          Get.bottomSheet(
            _confirmBottomSheetContent(data: map['customerData']),
          );
        }
      } else {
        Map<String, dynamic> errMap = jsonDecode(_response.body);
        Constants.toast('${errMap['message']}');
      }
    } catch (e) {
      _controller.setLoading(false);
    }
  }

  _fetchCurrentPlan(String name) async {
    _controller.isLoadingPackages.value = true;

    try {
      final _response = await APIService().getPlans(name.toLowerCase());
      print("FECTHED ::: ${_response.body}");
      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_response.body);
        setState(() {
          _currentPlans = map['data']['content']['varations'];
        });
        _controller.isLoadingPackages.value = false;
      }
    } catch (e) {
      print("ERROR ==> $e");
      _controller.isLoadingPackages.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (_controller.cableData.isNotEmpty) {
      _controller.selectedCableNetwork.value =
          _controller.cableData.value['networks'][0];
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _controller.cableData.isEmpty
          ? const SizedBox()
          : ListView(
              padding: const EdgeInsets.all(10.0),
              children: [
                TextSmall(
                  text: "Select your preferred network",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var i = 0;
                          i < _controller.cableData.value['networks'].length;
                          i++)
                        Expanded(
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: _current == i
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.transparent,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() => _current = i);
                                _controller.selectedCableNetwork.value =
                                    _controller.cableData.value['networks'][i];

                                setState(() {
                                  _currentPlans = [];
                                  _selectedVariationCode = "";
                                  _amountController.clear();
                                });

                                _controller.selectedCableBouquet.value = {};

                                _fetchCurrentPlan(_controller
                                    .cableData.value['networks'][i]['name']);
                              },
                              child: Image.network(
                                "${_controller.cableData.value['networks'][i]['icon']}",
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18.0),
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
                  controller: _smartcardNumController,
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
                  text:
                      "${_controller.selectedCableNetwork.value['name']} Bouquets",
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
                    title:
                        '${_selectedVariationCode.isEmpty ? _controller.selectedCableNetwork.value['name'] : _controller.selectedCableBouquet.value['name']}',
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
                const SizedBox(height: 16.0),
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
                // SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                // SizedBox(
                //   width: double.infinity,
                //   child: PrimaryButton(
                //     buttonText: "Proceed",
                //     bgColor: Theme.of(context).colorScheme.primaryContainer,
                //     onPressed: () {
                //       if (_formKey.currentState!.validate()) {
                //         _sendRequest();
                //         // Get.bottomSheet(_confirmBottomSheetContent);
                //       }
                //     },
                //     fontSize: 15,
                //   ),
                // ),
              ],
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
                child: Obx(
                  () => Column(
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
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
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
                                                print("CLICKBE JKJSKH>>>");
                                                _controller.selectedCableBouquet
                                                        .value =
                                                    _currentPlans[index];

                                                setState(() {
                                                  _selectedVariationCode =
                                                      _currentPlans[index]
                                                          ['variation_code'];
                                                });
                                                setState(() {
                                                  _amountController.text =
                                                      "${Constants.nairaSign(context).currencySymbol}${Constants.formatMoneyFloat(double.parse(_currentPlans[index]['variation_amount']))}";
                                                });

                                                _controller
                                                        .cableTvAmount.value =
                                                    double.parse(_currentPlans[
                                                            index]
                                                        ['variation_amount']);

                                                _controller.cableTvPackageName
                                                        .value =
                                                    _currentPlans[index]
                                                        ['name'];

                                                Get.back();
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
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.65,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextBody1(
                                                          text:
                                                              '${_currentPlans[index]['name']}'
                                                                  .capitalize,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Radio(
                                                    activeColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .tertiary,
                                                    value: _currentPlans[index]
                                                        ['variation_code'],
                                                    groupValue: _controller
                                                        .selectedCableBouquet
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
            ),
            const SizedBox(height: 16.0),
            // SizedBox(
            //   width: double.infinity,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //     child: PrimaryButton(
            //       buttonText: "Done",
            //       fontSize: 15,
            //       bgColor: Theme.of(context).colorScheme.primaryContainer,
            //       onPressed: () {
            //         Get.back();
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      );

  Container _confirmBottomSheetContent({required var data}) => Container(
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
                    _itemRow(
                        title: "Customer Name",
                        value: "${data['Customer_Name']}"),
                    const SizedBox(height: 6.0),
                    const Divider(),
                    const SizedBox(height: 6.0),
                    _itemRow(
                        title: "Customer Number",
                        value:
                            "${data['Customer_Number'] ?? data['Customer_ID'] ?? data['Smartcard_Number']}"),
                    const SizedBox(height: 6.0),
                    const Divider(),
                    const SizedBox(height: 6.0),
                    _itemRow(
                        title: "Due Date",
                        value: "${data['Due_Date'] ?? data['DUE_DATE']}"),
                    const SizedBox(height: 6.0),
                    const Divider(),
                    const SizedBox(height: 6.0),
                    _itemRow(
                        title: "Renewal Amount",
                        value: "${data['Renewal_Amount']}"),
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
                        PayNow(
                          title: 'Cable TV',
                          manager: widget.manager,
                          customerData: data,
                          payload: _payload,
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

        Map _payload = {
          "serviceID":
              "${_controller.selectedAirtimeNetwork.value['vtpass_code']}",
          // "phone": int.parse(_phoneController.text.trim()),
          "email": "${widget.manager.getUser()['email_address']}",
          "amount": int.parse(_amountController.text.replaceAll(regExp, '')),
        };

        _controller.internationalTopupPayload.value = _payload;

        Get.back();
        Get.to(
          VerifyOTP(
            email: email,
            caller: 'vtu',
            manager: widget.manager,
            bankData: null,
            voucherCode: _inputController.text.trim(),
            vtuType: "topup",
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
