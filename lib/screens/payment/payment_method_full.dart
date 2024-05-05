import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef InitCallback(bool params, String name);

class FullPaymentMethod extends StatefulWidget {
  final InitCallback onChecked;
  final PreferenceManager manager;
  var payload;
  FullPaymentMethod({
    Key? key,
    required this.onChecked,
    this.payload,
    required this.manager,
  }) : super(key: key);

  @override
  State<FullPaymentMethod> createState() => _FullPaymentMethodState();
}

class _FullPaymentMethodState extends State<FullPaymentMethod> {
  bool _isChecked = true;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool _isChecked5 = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
              padding: const EdgeInsets.all(12.0),
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
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                          const SizedBox(width: 10.0),
                          TextSmall(
                            text: "Bank Transfer",
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ],
                      ),
                      Checkbox(
                        value: _isChecked3,
                        onChanged: (val) {
                          setState(() {
                            _isChecked = false;
                            _isChecked2 = false;
                            _isChecked3 = val!;
                            _isChecked4 = false;
                            _isChecked5 = false;
                          });

                          widget.onChecked(val ?? _isChecked3, "Bank Transfer");
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
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                          const SizedBox(width: 10.0),
                          TextSmall(
                            text: "Card",
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ],
                      ),
                      Checkbox(
                        value: _isChecked4,
                        onChanged: (val) {
                          setState(() {
                            _isChecked4 = val!;
                            _isChecked2 = false;
                            _isChecked = false;
                            _isChecked3 = false;
                            _isChecked5 = false;
                          });
                          widget.onChecked(val ?? !_isChecked4, "Card");
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         SvgPicture.asset(
                  //           "assets/images/voucher_payment.svg",
                  //           width: 24,
                  //           height: 24,
                  //           fit: BoxFit.cover,
                  //         ),
                  //         const SizedBox(width: 10.0),
                  //         TextSmall(
                  //           text: "Voucher",
                  //           color: const Color(0xFF3B3B3B),
                  //         ),
                  //       ],
                  //     ),
                  //     Checkbox(
                  //       value: _isChecked5,
                  //       onChanged: (val) {
                  //         setState(() {
                  //           _isChecked5 = val!;
                  //           _isChecked4 = false;
                  //           _isChecked3 = false;
                  //           _isChecked2 = false;
                  //           _isChecked = false;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
