import 'dart:convert';

import 'package:afrikunet/components/buttons/action.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'confirm_purchase.dart';
import 'widgets/voucher_type.dart';

class BuyVoucher extends StatefulWidget {
  final PreferenceManager manager;
  const BuyVoucher({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<BuyVoucher> createState() => _BuyVoucherState();
}

class _BuyVoucherState extends State<BuyVoucher> {
  final _amountController = TextEditingController();
  final _quantityController = TextEditingController();
  late TextSelection _selection;
  bool _hasFetchedCharge = false;
  var _redeemableAmount = "0.0";

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      _selection = _amountController.selection;
    });
  }

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
            TextMedium(
              text: "Buy Voucher",
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _amountSection(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _showChooser();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 2.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.add,
                          size: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        TextBody2(
                          text: "Qty",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              bottom: 16.0,
              right: 16.0,
            ),
            child: VoucherType(
              currentAmount: _amountController.text,
              manager: widget.manager,
              finalValue: _redeemableAmount,
              hasFetchedCharge: _hasFetchedCharge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountSection(context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Amount",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            height: 6.0,
          ),
          RoundedInputMoney(
            hintText: "Amount",
            onChanged: (value) async {
              if (value.toString().contains("-")) {
                setState(() {
                  _amountController.text = value.toString().replaceAll("-", "");
                  _amountController.selection = _selection;
                });
              } else {
                setState(() {
                  _hasFetchedCharge = false;
                });
                try {
                  final amt = value.replaceAll("₦", "").replaceAll(",", "");
                  Map _payload = {
                    "type": "deposit",
                    "amount": int.parse(amt),
                  };

                  final _response = await APIService().fetchVoucherCharge(
                    accessToken: widget.manager.getAccessToken(),
                    payload: _payload,
                  );

                  debugPrint("FETCHED CHARGE  HERE :::: ${_response.body}");
                  setState(() {
                    _hasFetchedCharge = true;
                  });

                  if (_response.statusCode >= 200 &&
                      _response.statusCode <= 299) {
                    Map<String, dynamic> map = jsonDecode(_response.body);
                    print("DATA CHECK :::: ${map}");
                    setState(() {
                      _redeemableAmount = "${map['final_value']}";
                    });
                  }
                } catch (e) {
                  print("$e");
                }
              }
            },
            strokeColor:
                Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
            controller: _amountController,
            validator: (value) {
              if (value.toString().contains("-")) {
                return "Negative numbers not allowed";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ActionButton(
                  strokeColor: Colors.black,
                  icon: const Text(
                    "₦500",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 16,
                  onPressed: () async {
                    setState(() {
                      _amountController.text = "₦500";
                      _hasFetchedCharge = false;
                    });
                    try {
                      Map _payload = {
                        "type": "deposit",
                        "amount": 500,
                      };

                      final _response = await APIService().fetchVoucherCharge(
                        accessToken: widget.manager.getAccessToken(),
                        payload: _payload,
                      );

                      debugPrint("FETCHED CHARGE  HERE :::: ${_response.body}");
                      setState(() {
                        _hasFetchedCharge = true;
                      });

                      if (_response.statusCode >= 200 &&
                          _response.statusCode <= 299) {
                        Map<String, dynamic> map = jsonDecode(_response.body);
                        print("DATA CHECK :::: ${map}");
                        setState(() {
                          _redeemableAmount = "${map['final_value']}";
                        });
                      }
                    } catch (e) {
                      print("$e");
                    }
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ActionButton(
                  strokeColor: Colors.black,
                  icon: const Text(
                    "₦700",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 16,
                  onPressed: () async {
                    setState(() {
                      _amountController.text = "₦700";
                      _hasFetchedCharge = false;
                    });
                    try {
                      Map _payload = {
                        "type": "deposit",
                        "amount": 700,
                      };

                      final _response = await APIService().fetchVoucherCharge(
                        accessToken: widget.manager.getAccessToken(),
                        payload: _payload,
                      );

                      debugPrint("FETCHED CHARGE  HERE :::: ${_response.body}");
                      setState(() {
                        _hasFetchedCharge = true;
                      });

                      if (_response.statusCode >= 200 &&
                          _response.statusCode <= 299) {
                        Map<String, dynamic> map = jsonDecode(_response.body);
                        print("DATA CHECK :::: ${map}");
                        setState(() {
                          _redeemableAmount = "${map['final_value']}";
                        });
                      }
                    } catch (e) {
                      print("$e");
                    }
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ActionButton(
                  radius: 16,
                  strokeColor: Colors.black,
                  icon: const Text(
                    "₦1000",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      _amountController.text = "₦1,000";
                      _hasFetchedCharge = false;
                    });
                    try {
                      Map _payload = {
                        "type": "deposit",
                        "amount": 1000,
                      };

                      final _response = await APIService().fetchVoucherCharge(
                        accessToken: widget.manager.getAccessToken(),
                        payload: _payload,
                      );

                      debugPrint("FETCHED CHARGE  HERE :::: ${_response.body}");
                      setState(() {
                        _hasFetchedCharge = true;
                      });

                      if (_response.statusCode >= 200 &&
                          _response.statusCode <= 299) {
                        Map<String, dynamic> map = jsonDecode(_response.body);
                        print("DATA CHECK :::: ${map}");
                        setState(() {
                          _redeemableAmount = "${map['final_value']}";
                        });
                      }
                    } catch (e) {
                      print("$e");
                    }
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ActionButton(
                  strokeColor: Colors.black,
                  icon: const Text(
                    "₦1500",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 16,
                  onPressed: () async {
                    setState(() {
                      _amountController.text = "₦1,500";
                      _hasFetchedCharge = false;
                    });
                    try {
                      Map _payload = {
                        "type": "deposit",
                        "amount": 1500,
                      };

                      final _response = await APIService().fetchVoucherCharge(
                        accessToken: widget.manager.getAccessToken(),
                        payload: _payload,
                      );

                      debugPrint("FETCHED CHARGE  HERE :::: ${_response.body}");
                      setState(() {
                        _hasFetchedCharge = true;
                      });

                      if (_response.statusCode >= 200 &&
                          _response.statusCode <= 299) {
                        Map<String, dynamic> map = jsonDecode(_response.body);
                        print("DATA CHECK :::: ${map}");
                        setState(() {
                          _redeemableAmount = "${map['final_value']}";
                        });
                      }
                    } catch (e) {
                      print("$e");
                    }
                  },
                ),
              ),
            ],
          )
        ],
      );

  _showChooser({var items}) {
    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: SingleChildScrollView(
          child: _quantitySection(context),
        ),
      ),
    );
  }

  Widget _quantitySection(context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Text(
            "Quantity",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            height: 6.0,
          ),
          CustomTextField(
            onChanged: (e) {},
            controller: _quantityController,
            validator: (value) {
              if (value.toString().contains("-")) {
                return "Negative numbers not allowed";
              }
              return null;
            },
            inputType: TextInputType.number,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ActionButton(
                  strokeColor: Colors.black,
                  icon: const Text(
                    "5",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 16,
                  onPressed: () async {
                    setState(() {
                      _quantityController.text = "5";
                    });
                  },
                ),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: ActionButton(
                  strokeColor: Colors.black,
                  icon: const Text(
                    "10",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 16,
                  onPressed: () async {
                    setState(() {
                      _quantityController.text = "10";
                    });
                  },
                ),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: ActionButton(
                  radius: 16,
                  strokeColor: Colors.black,
                  icon: const Text(
                    "25",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      _quantityController.text = "25";
                    });
                  },
                ),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: ActionButton(
                  strokeColor: Colors.black,
                  icon: const Text(
                    "50",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 16,
                  onPressed: () async {
                    setState(() {
                      _quantityController.text = "50";
                    });
                  },
                ),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: ActionButton(
                  strokeColor: Colors.black,
                  icon: const Text(
                    "100",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 16,
                  onPressed: () async {
                    setState(() {
                      _quantityController.text = "100";
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: PrimaryButton(
              fontSize: 16,
              buttonText: "Done",
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ],
      );
}
