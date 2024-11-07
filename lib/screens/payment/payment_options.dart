import 'dart:convert';

import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/payment_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:url_launcher/url_launcher.dart';

import 'payment_view.dart';

typedef InitCallback(bool params, String name);

class PaymentOptions extends StatefulWidget {
  final InitCallback onChecked;
  final PreferenceManager manager;
  var payload;
  PaymentOptions({
    Key? key,
    required this.onChecked,
    this.payload,
    required this.manager,
  }) : super(key: key);

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  bool _isChecked = true;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  final _controller = Get.find<StateController>();

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    print("PAYLOAD :: ${widget.payload}");
  }

  @override
  Widget build(BuildContext context) {
    print("PAYLOAD :: ${widget.payload}");
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 6.0,
                    top: 4.0,
                    bottom: 4.0,
                    left: 0.0,
                  ),
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
                  text: "Confirm Purchase",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              children: [
                const SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(0.0),
                  child: Card(
                    elevation: 1.0,
                    shadowColor: const Color(0xFFF2F2F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        top: 12.0,
                        bottom: 12.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/bank_transfer.svg",
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.cover,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                  ),
                                  const SizedBox(width: 10.0),
                                  TextSmall(
                                    text: "Bank Transfer",
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ],
                              ),
                              Checkbox(
                                value: _isChecked,
                                onChanged: (val) {
                                  setState(() {
                                    _isChecked = val!;
                                    _isChecked2 = false;
                                    _isChecked3 = false;
                                  });

                                  widget.onChecked(
                                    val ?? _isChecked,
                                    "Bank Transfer",
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/card_payment.svg",
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.cover,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                  ),
                                  const SizedBox(width: 10.0),
                                  TextSmall(
                                    text: "Card",
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ],
                              ),
                              Checkbox(
                                value: _isChecked2,
                                onChanged: (val) {
                                  setState(() {
                                    _isChecked2 = val!;
                                    _isChecked = false;
                                    _isChecked3 = false;
                                  });
                                  widget.onChecked(
                                    val ?? !_isChecked2,
                                    "Card",
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/paypal.svg",
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.cover,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                  ),
                                  const SizedBox(width: 10.0),
                                  TextSmall(
                                    text: " Paypal",
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ],
                              ),
                              Checkbox(
                                value: _isChecked3,
                                onChanged: (val) {
                                  setState(() {
                                    _isChecked3 = val!;
                                    _isChecked2 = false;
                                    _isChecked = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: PrimaryButton(
                    fontSize: 16,
                    buttonText: "Pay",
                    bgColor: Theme.of(context).colorScheme.primaryContainer,
                    onPressed: () {
                      if (_isChecked || _isChecked2) {
                        var _customerRef =
                            "Afrikunet_${DateTime.now().millisecondsSinceEpoch}&${widget.manager.getUser()['email_address']}";
                        // Send Request for payment and trigger payment form
                        var _payload = {
                          "full_name":
                              "${widget.manager.getUser()['first_name']} ${widget.manager.getUser()['last_name']}",
                          "email": widget.manager.getUser()['email_address'],
                          "amount": double.parse(widget.payload['amount']),
                          "phone": int.parse(
                              widget.manager.getUser()['phone_number']),
                          "merchant_id": '65d3404666a4d',
                          "payment_type": 'card',
                          "customer_ref": _customerRef,
                          "webhook_url":
                              "https://afrikunet-api-orcin.vercel.app/bkapi/vouchers/webhook",
                        };

                        print("INSPECT PAYLOAD ::: ${_payload}");

                        var _credentials = jsonEncode(_payload);

                        if (kDebugMode) {
                          print(" CREDENTIALD ::: $_credentials");
                        }

                        Codec stringToBase64Url = utf8.fuse(base64Url);
                        String encoded = stringToBase64Url.encode(_credentials);
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
                            "usecase": 'buy-voucher',
                            'payload': widget.payload,
                            'accessToken': widget.manager.getAccessToken(),
                            'manager': widget.manager,
                          },
                        );
                      } else {
                        // Load paypal link
                        _launchInBrowser("https://www.paypal.com/");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _purchaseVoucher() async {
    try {
      // _controller.setLoading(true);
      Map _payload = {
        "type": "${widget.payload['voucherType']}"
            .replaceAll(" ", "")
            .toLowerCase(),
        "amount": widget.payload['amount'],
        "bg_type": widget.payload['voucherIndex'] == 0
            ? "blue"
            : widget.payload['voucherIndex'] == 1
                ? "white"
                : "black",
      };

      // final _resp = await APIService()
      //     .buyVoucher(widget.manager.getAccessToken(), _payload);
      // print("BUY VOUCHER RESPONSE ::: ${_resp.body}");
      // _controller.setLoading(false);
    } catch (e) {
      debugPrint(e.toString());
      // _controller.setLoading(false);
    }
  }
}
