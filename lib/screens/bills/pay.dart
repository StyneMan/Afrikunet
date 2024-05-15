import 'dart:convert';

import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/payment_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/payment/payment_method_full.dart';
import 'package:afrikunet/screens/payment/payment_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class PayNow extends StatefulWidget {
  final String title;
  final PreferenceManager manager;
  var payload;
  var customerData;
  final String dataVal;
  PayNow({
    Key? key,
    required this.title,
    required this.manager,
    required this.payload,
    this.dataVal = "",
    required this.customerData,
  }) : super(key: key);

  @override
  State<PayNow> createState() => _PayNowState();
}

class _PayNowState extends State<PayNow> {
  final _controller = Get.find<StateController>();
  bool _isChecked = false;
  String _selectedPaymentName = "";

  _onChecked(bool checked, String name) {
    setState(() {
      _isChecked = checked;
      _selectedPaymentName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            automaticallyImplyLeading: true,
            title: TextMedium(
              text: widget.title,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        FullPaymentMethod(
                          onChecked: _onChecked,
                          manager: widget.manager,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      buttonText: "Pay",
                      bgColor: Theme.of(context).colorScheme.primaryContainer,
                      onPressed: !_isChecked
                          ? null
                          : () {
                              // Send Request for payment and trigger payment form
                              var _customerRef =
                                  "Afrikunet_${DateTime.now().millisecondsSinceEpoch}_${widget.manager.getUser()['first_name']}_pay";
                              var _payload = {
                                "full_name":
                                    "${widget.manager.getUser()['first_name']} ${widget.manager.getUser()['last_name']}",
                                "phone":
                                    widget.manager.getUser()['phone_number'],
                                "email":
                                    widget.manager.getUser()['email_address'],
                                "amount": widget.payload['amount'],
                                "merchant_id": '65d3404666a4d',
                                "payment_type": 'card',
                                "customer_ref": _customerRef,
                                "webhook_url":
                                    "https://afrikunet-api-orcin.vercel.app/bkapi/vouchers/webhook",
                              };

                              var _credentials = jsonEncode(_payload);

                              if (kDebugMode) {
                                print("$_credentials");
                              }

                              Codec<String, String> stringToBase64Url =
                                  utf8.fuse(base64Url);
                              String encoded =
                                  stringToBase64Url.encode(_credentials);
                              if (kDebugMode) {
                                print("ENCODED BASE64 ::: $encoded");
                              }

                              // final _djks = Get.put(PaymentController());
                              Get.lazyPut<PaymentController>(
                                  () => PaymentController(),
                                  fenix: true);

                              Get.to(
                                const PaymentView(),
                                arguments: {
                                  'data': encoded,
                                  "customerRef": _customerRef,
                                  'customerData': widget.customerData,
                                  'payload': widget.payload,
                                  'accessToken':
                                      widget.manager.getAccessToken(),
                                  'manager': widget.manager,
                                  'selectedDataPlanName': widget.dataVal,
                                  'usecase': 'vtu',
                                },
                              );
                            },
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
