import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/networks.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/screens/success_screen.dart';
import 'package:afrikunet/screens/payment/payment_method.dart';
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
  int _current = 0;
  String _countryCode = "+234";
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
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
                for (var i = 0; i < networksAirtime.length; i++)
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
                        },
                        child: Image.asset(
                          "assets/images/${networksAirtime[i].icon}",
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
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 75,
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
                  showCountryOnly: true,
                  showFlag: true,
                  showDropDownButton: true,
                  hideMainText: true,
                  showOnlyCountryWhenClosed: false,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          TextSmall(
            text: "Select a data bundle for ${networksAirtime[_current].name}",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(height: 24.0),
          const PaymentMethod(),
          const SizedBox(height: 16.0),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      "You are about to recharge  from access bank to this phone number ${_phoneController.text}.",
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
                                        SuccessPage(
                                          isVoucher: false,
                                          manager: widget.manager,
                                        ),
                                        transition: Transition.cupertino,
                                      );
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
}
