import 'dart:convert';

import 'package:afrikunet/components/buttons/dropdown_button.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/cards/micro_giftcard.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/customdropdown.dart';
import 'package:afrikunet/components/inputfield/formatted_textfield.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
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
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _inputController = TextEditingController();
  final _meterNumberController = TextEditingController();
  var _selectedMeterType;
  var _selectedDistributor;
  RegExp regExp = RegExp(r'[^0-9.]');
  String _countryCode = "+234",
      _errorMsg = "",
      _errText = "",
      _countryFlag = 'https://vtpass.com/resources/images/flags/NG.png';

  Map _payload = {};

  onSelectType(val) {
    setState(() {
      _selectedMeterType = val;
    });
  }

  _sendRequest() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var filteredAmt = _amountController.text.replaceAll("₦", "");
    try {
      _controller.setLoading(true);
      _payload = {
        "type": "electricity",
        "amount": double.parse(filteredAmt.replaceAll(",", "")),
        "variation_code": "$_selectedMeterType".toLowerCase(),
        "phone": _phoneController.text,
        "name": _selectedDistributor['vtpass_code'],
        "product_type_id": _selectedDistributor['product_type_id'],
        "network_id": _selectedDistributor['id'],
        "otherParams": {
          "meterType": "$_selectedMeterType".toLowerCase(),
          "billersCode": _meterNumberController.text.replaceAll(" ", ""),
        }
      };

      print("PAYLOAD :: $_payload");

      final _response = await APIService()
          .initVtuRequest(widget.manager.getAccessToken(), _payload);
      print("INIT  ELECTRICITY REPONSE :: ${_response.body}");
      _controller.setLoading(false);

      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_response.body);
        Get.bottomSheet(_confirmBottomSheetContent(data: map['customerData']));
      }

      //
    } catch (error) {
      _controller.setLoading(false);
      debugPrint(error.toString());
    }
  }

  @override
  void initState() {
    if (mounted) {
      setState(() {
        _phoneController.text = widget.manager.getUser()['phone_number'] ?? "";
      });
    }
    super.initState();
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
    // print("KLJKB ::   ${_controller.cableTvPackageName.value}");

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          TextSmall(
            text: "Meter Type",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(
            height: 4.0,
          ),
          CustomDropdown(
            items: const ['Prepaid', 'Postpaid'],
            hint: '',
            onSelected: onSelectType,
          ),
          const SizedBox(
            height: 21.0,
          ),
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
            height: 21.0,
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
            height: 10.0,
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
          const SizedBox(height: 16),
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
          // SizedBox(
          //   width: double.infinity,
          //   child: PrimaryButton(
          //     buttonText: "Proceed",
          //     bgColor: Theme.of(context).colorScheme.primaryContainer,
          //     onPressed: () {
          //       if (_formKey.currentState!.validate()) {
          //         _sendRequest();
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
                          _selectedDistributor = _controller
                              .electricityData.value['networks'][index];
                        });
                        _controller.electricityDistributorName.value =
                            _controller.electricityData
                                .value['networks'][index]['name']
                                .replaceAll("Electricity", "")
                                .replaceAll("Company", "");

                        Get.back();
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
                            width: MediaQuery.of(context).size.width * 0.88,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  "${_controller.electricityData.value['networks'][index]['icon']}",
                                  width: 48,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    "assets/images/logo_blue.png",
                                    width: 48,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  "${_controller.electricityData.value['networks'][index]['name']}"
                                      .replaceAll("Electricity", "")
                                      .replaceAll("Company", ""),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount:
                    (_controller.electricityData.value['networks']).length,
              ),
              const SizedBox(height: 16.0),
              // SizedBox(
              //   width: double.infinity,
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //     child: PrimaryButton(
              //       buttonText: "Done",
              //       bgColor: Theme.of(context).colorScheme.primaryContainer,
              //       fontSize: 15,
              //       onPressed: () {
              //         Get.back();
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
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
                    _itemRow(
                        title: "Customer Name",
                        value: "${data['Customer_Name']}"),
                    const SizedBox(height: 6.0),
                    const Divider(),
                    const SizedBox(height: 6.0),
                    _itemRow(
                        title: "Meter Number",
                        value:
                            "${data['MeterNumber'] ?? data['Meter_Number']}"),
                    const SizedBox(height: 6.0),
                    const Divider(),
                    const SizedBox(height: 6.0),
                    _itemRow(
                        title: "Address",
                        value: "${data['Address'] ?? data['District']}"),
                    const SizedBox(height: 6.0),
                    const Divider(),
                    const SizedBox(height: 6.0),
                    _itemRow(
                        title: "Meter Type",
                        value: "${data['Meter_Type'] ?? _selectedMeterType}"
                          ..capitalize),
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
                          payload: _payload,
                          customerData: data,
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
          "phone": int.parse(_phoneController.text.trim()),
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
