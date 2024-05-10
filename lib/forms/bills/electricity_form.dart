import 'dart:convert';

import 'package:afrikunet/components/buttons/dropdown_button.dart';
import 'package:afrikunet/components/buttons/primary.dart';
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
import 'package:afrikunet/screens/bills/pay.dart';
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
  final _meterNumberController = TextEditingController();
  var _selectedMeterType;
  var _selectedDistributor;
  // double? _selectedAmount;
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
          const SizedBox(
            height: 24.0,
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              buttonText: "Proceed",
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _sendRequest();
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
}
