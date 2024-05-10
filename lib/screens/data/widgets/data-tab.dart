import 'dart:convert';

import 'package:afrikunet/components/buttons/dropdown_button.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/shimmer/banner_shimmer.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/bills/pay.dart';
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
  int _current = 6;
  String _countryCode = "+234", _selectedNetworkName = "";
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _controller = Get.find<StateController>();
  final _amountController = TextEditingController();

  var _currentPlans = [];
  String _selectedVariationCode = "";

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _controller.internetData.isEmpty
          ? const SizedBox()
          : ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(5.0),
              children: [
                TextSmall(
                  text: "Select your preferred network",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                SizedBox(
                  child: GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    children: [
                      for (var i = 0;
                          i < _controller.internetData.value['networks'].length;
                          i++)
                        Container(
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
                              _controller.selectedDataNetwork.value =
                                  _controller.internetData.value['networks'][i];

                              setState(() {
                                _currentPlans = [];
                                _selectedVariationCode = "";
                              });

                              _controller.selectedDataPlan.value = {};

                              _fetchCurrentPlan(_controller
                                  .internetData.value['networks'][i]['name']);
                            },
                            child: Image.network(
                              "${_controller.internetData.value['networks'][i]['icon']}",
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18.0),
                TextSmall(
                  text: "Phone number",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 4.0),
                SizedBox(
                  width: double.infinity,
                  child: CustomTextField(
                    onChanged: (val) {},
                    controller: _phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                    prefix: CountryCodePicker(
                      alignLeft: false,
                      onChanged: null,
                      padding: const EdgeInsets.all(0.0),
                      initialSelection:
                          '${widget.manager.getUser()['country_code']}',
                      showCountryOnly: true,
                      showFlag: true,
                      showDropDownButton: false,
                      hideMainText: true,
                      showOnlyCountryWhenClosed: false,
                      enabled: false,
                    ),
                    inputType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 24.0),
                TextSmall(
                  text: _current == 6
                      ? 'Select network first'
                      : 'Select a data bundle for ' +
                          _controller.selectedDataNetwork.value['name'],
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                Obx(
                  () => DropDownButton(
                    onPressed: _current == 6
                        ? () {
                            Constants.showInfoDialog(
                              context: context,
                              message: "To continue, select a network first!",
                              status: 'error',
                            );
                          }
                        : () {
                            Get.bottomSheet(
                              _bottomSheetContent,
                            );
                          },
                    title:
                        '${_selectedVariationCode.isEmpty ? _controller.selectedDataNetwork.value['name'] : _controller.selectedDataPlan.value['name'].toString().length > 42 ? _controller.selectedDataPlan.value['name'].toString().substring(0, 40) + '...' : _controller.selectedDataPlan.value['name']}',
                  ),
                ),
                const SizedBox(
                  height: 21.0,
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
                                                  _currentPlans[index]
                                                      ['variation_amount'];
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
                                                        text:
                                                            '${_currentPlans[index]['name']}'
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
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: PrimaryButton(
                  buttonText: "Done",
                  fontSize: 15,
                  bgColor: Theme.of(context).colorScheme.primaryContainer,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ),
          ],
        ),
      );
}
