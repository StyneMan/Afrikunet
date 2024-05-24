import 'dart:convert';

import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/bank_countries_dropdown.dart';
import 'package:afrikunet/components/inputfield/bank_dropdown.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBankForm extends StatefulWidget {
  const AddBankForm({Key? key}) : super(key: key);

  @override
  State<AddBankForm> createState() => _AddBankFormState();
}

class _AddBankFormState extends State<AddBankForm> {
  Map<String, dynamic> _selectedCountry = {
    "code": "ng",
    "name": "Nigeria",
    "logo":
        "https://afrikunet-api-orcin.vercel.app/uploads/images/country_logos/nigeria.png"
  };

  Map<String, dynamic> _selectedBank = {
    "id": 144,
    "code": "070",
    "name": "Fidelity Bank",
    "logo":
        "https://afrikunet-api-orcin.vercel.app/uploads/images/banks/ng/070.png"
  };

  final _accController = TextEditingController();
  bool _isValidating = false;
  bool _showName = false, _isSaving = false;
  var _banks = [];
  var _customerName = '', _accountNumber = '';

  String _errorMsg = '', _text = '';
  final _controller = Get.find<StateController>();

  _onCountrySelected(var country) async {
    setState(() {
      _selectedCountry = country;
      // _banks = [];
      _selectedBank = {};
    });

    print("SELCTED CONUNTRY ::: $country ");

    // Make new API request to get banks here

    try {
      final _response = await APIService().getBanks(country['code']);
      print("${country['name']} banks ;;; ${_response.body}");
      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_response.body);
        setState(() {
          _banks = map['banks'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _validateAccount() async {
    try {
      Map _payload = {
        "account_number": _accController.text,
        "account_bank": _selectedBank['code'],
      };

      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";

      final _resp = await APIService().validateBank(_token, _payload);
      print("VALIDATE RESPONSE :: ${_resp.body}");
      if (_resp.statusCode >= 200 && _resp.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_resp.body);
        setState(() {
          _isValidating = false;
          _showName = true;
        });
        if ("${map['message']}".contains('invalid')) {
          setState(() {
            _text = map['message'] ?? "";
          });
        } else {
          setState(() {
            _text = map['data']['account_name'];
            _customerName = map['data']['account_name'];
            _accountNumber = map['data']['account_number'];
          });
        }
      }
    } catch (e) {
      print('${e}');
    }
  }

  _initBanks() async {
    try {
      final _response = await APIService().getBanks(_selectedCountry['code']!);
      // print("${_selectedCountry['name']} banks ;;; ${_response.body}");
      if (_response.statusCode >= 200 && _response.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_response.body);
        setState(() {
          _banks = map['banks'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    _initBanks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        physics: const NeverScrollableScrollPhysics(),
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
          const SizedBox(height: 5.0),
          DottedDivider(),
          const SizedBox(height: 21.0),
          TextSmall(
            text: "Add New Bank",
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(height: 21.0),
          TextBody1(
            text: "Country",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(height: 4.0),
          BankCountriesCustomDropdown(
            items: _controller.bankCountries.value,
            hint: "Select country",
            onSelected: _onCountrySelected,
            value: _selectedCountry,
          ),
          const SizedBox(height: 24.0),
          _banks.isEmpty
              ? const SizedBox()
              : TextBody1(
                  text: "Bank",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
          const SizedBox(height: 4.0),
          BankCustomDropdown(
            items: _banks,
            hint: "Select bank",
            value: _selectedBank,
            onSelected: (selected) {
              setState(() {
                _selectedBank = selected;
              });
            },
          ),
          const SizedBox(height: 4.0),
          _banks.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 48,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        child: LinearProgressIndicator(
                          color: Theme.of(context).colorScheme.tertiary,
                          minHeight: 3,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    )
                  ],
                )
              : const SizedBox(),
          const SizedBox(height: 16.0),
          _selectedBank == null && _banks.isEmpty
              ? const SizedBox()
              : TextBody1(
                  text: "Account Number",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
          const SizedBox(height: 4.0),
          _selectedBank == null && _banks.isEmpty
              ? const SizedBox()
              : CustomTextField(
                  maxLength: _selectedCountry['code'] == 'ng' ? 10 : null,
                  isEnabled: !_isValidating,
                  onChanged: (value) {
                    if (_selectedCountry['code'] == 'ng') {
                      // Nigerian validation
                      if (value.length < 10) {
                        // Trigger validation
                        // setState(() {
                        _errorMsg = '10 digits min';
                        _showName = false;
                        // });
                        // Future.delayed(const Duration(seconds: 5), () {
                        //   setState(() {
                        //     _isValidating = false;
                        //     _showName = true;
                        //   });
                        // });
                      } else {
                        setState(() {
                          _errorMsg = '';
                          _isValidating = true;
                        });
                        // Make a trip to validation API here
                        _validateAccount();
                      }
                    }
                  },
                  controller: _accController,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Account number is required!";
                    }
                  },
                  inputType: TextInputType.number,
                  // endIcon: !_isValidating
                  //     ? Align(
                  //         alignment: Alignment.centerRight,
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(right: 8.0),
                  //           child: Text(
                  //             _errorMsg,
                  //             textAlign: TextAlign.end,
                  //             style: const TextStyle(
                  //               fontSize: 11,
                  //               color: Colors.red,
                  //               fontFamily: 'roboto',
                  //               fontStyle: FontStyle.italic,
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     : Image.asset(
                  //         'assets/images/loading.gif',
                  //         width: 56,
                  //         height: 56,
                  //       ),
                ),
          _showName
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextSmall(
                      text: _text.capitalize,
                      fontWeight: FontWeight.w500,
                      color: _text.contains('invalid')
                          ? Colors.red
                          : Theme.of(context).colorScheme.tertiary,
                    ),
                    _text.contains('invalid')
                        ? const Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 16,
                          )
                        : const Icon(
                            CupertinoIcons.checkmark,
                            color: Colors.green,
                            size: 16,
                          )
                  ],
                )
              : const SizedBox(),
          const SizedBox(height: 56.0),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              buttonText: "Save",
              fontSize: 15,
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: _text.isEmpty || _text.contains('invalid') || _isSaving
                  ? null
                  : () {
                      _saveBank();
                    },
            ),
          ),
        ],
      ),
    );
  }

  _saveBank() async {
    try {
      _controller.setLoading(true);
      setState(() {
        _isSaving = true;
      });
      Map _payload = {
        "name": _selectedBank['name'],
        "code": _selectedBank['code'],
        "country": _selectedCountry['code'],
        "iso3": _selectedCountry['iso3'],
        "logo": _selectedBank['logo'],
        "user_id": _controller.userData.value['email_address'],
        "account_name": _customerName,
        "account_number": _accountNumber,
      };

      // print("BANK SAVE PAYLOAD ::: $_payload");

      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString('accessToken') ?? "";
      final _response = await APIService().saveBank(
        accessToken: _token,
        payload: _payload,
      );
      _controller.setLoading(false);
      Get.back();
      print("SAVE BANK RESPONSE L::::: ${_response.body}");

      _showBottomSheet();

      _controller.onInit();
    } catch (e) {
      _controller.setLoading(false);
      setState(() {
        _isSaving = false;
      });
      debugPrint(e.toString());
    }
  }

  _showBottomSheet() {
    double sheetHeight = MediaQuery.of(context).size.height * 0.50;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: sheetHeight,
          width: double.infinity,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                physics: const NeverScrollableScrollPhysics(),
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
                  const SizedBox(height: 5.0),
                  DottedDivider(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/check_all.svg',
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: TextBody1(
                        text: 'Account successfully saved',
                        align: TextAlign.center,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        buttonText: "Done",
                        fontSize: 15,
                        bgColor: Theme.of(context).colorScheme.primaryContainer,
                        onPressed: _text.isEmpty || _text.contains('invalid')
                            ? null
                            : () {
                                Get.back();
                              },
                      ),
                    ),
                  ),
                ],
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
}
