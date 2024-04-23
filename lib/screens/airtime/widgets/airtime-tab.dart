import 'package:afrikunet/components/buttons/action.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/networks.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/bills/pay.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  int _current = 0;
  String _countryCode = "+234";
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _controller = Get.find<StateController>();

  @override
  void initState() {
    super.initState();
    // Initialize selected airtime network to the first item
    if (_controller.airtimeData.isNotEmpty) {
      _controller.selectedAirtimeNetwork.value =
          _controller.airtimeData.value['networks'][0];
    }
  }

  @override
  Widget build(BuildContext context) {
    print("AIRTIME ::: ${_controller.airtimeData.value}");

    return Form(
      key: _formKey,
      child: _controller.airtimeData.isEmpty
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
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var i = 0;
                          i < _controller.airtimeData.value['networks'].length;
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
                                _controller.selectedAirtimeNetwork.value =
                                    _controller.airtimeData.value['networks']
                                        [i];
                              },
                              child: Image.network(
                                "${_controller.airtimeData.value['networks'][i]['icon']}",
                              ),
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
                    inputType: TextInputType.number,
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
                  ),
                ),
                const SizedBox(height: 24.0),
                TextSmall(
                  text:
                      "How much ${networksAirtime[_current].name} airtime are you buying?",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 16.0),
                _amountSection(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                PrimaryButton(
                  fontSize: 15,
                  buttonText: "Pay",
                  bgColor: Theme.of(context).colorScheme.primaryContainer,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                            "Your about to topup your mobile number (${_phoneController.text}) with ${_amountController.text} ${networksAirtime[_current].name} airtime.",
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
                                          bgColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          onPressed: () {
                                            var _filteredAmount =
                                                _amountController.text
                                                    .replaceAll(",", "");
                                            var _removeSign = _filteredAmount
                                                .replaceAll("₦", "");
                                            Get.back();
                                            Get.to(
                                              PayNow(
                                                title: 'Airtime Topup',
                                                manager: widget.manager,
                                                customerData: {},
                                                payload: {
                                                  "type": "airtime",
                                                  "amount":
                                                      double.parse(_removeSign),
                                                  "product_type_id": int.parse(
                                                      _controller.airtimeData
                                                          .value['id']),
                                                  "network_id": _controller
                                                      .selectedAirtimeNetwork
                                                      .value['id'],
                                                  "phone":
                                                      _phoneController.text,
                                                  "name": _controller
                                                      .selectedAirtimeNetwork
                                                      .value['name']
                                                      .toLowerCase()
                                                },
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
            strokeColor: Theme.of(context).colorScheme.tertiary,
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
                  icon: Text(
                    "₦200",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  bgColor:
                      Theme.of(context).colorScheme.background.withOpacity(0.8),
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
                  icon: Text(
                    "₦300",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  radius: 10,
                  bgColor:
                      Theme.of(context).colorScheme.background.withOpacity(0.8),
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
                  icon: Text(
                    "₦500",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  bgColor:
                      Theme.of(context).colorScheme.background.withOpacity(0.8),
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
                  icon: Text(
                    "₦1000",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  bgColor:
                      Theme.of(context).colorScheme.background.withOpacity(0.8),
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
