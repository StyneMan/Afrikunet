import 'package:afrikunet/components/buttons/action.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'confirm_purchase.dart';
import 'widgets/payment_method.dart';
import 'widgets/voucher_type.dart';

class BuyVoucher extends StatefulWidget {
  const BuyVoucher({Key? key}) : super(key: key);

  @override
  State<BuyVoucher> createState() => _BuyVoucherState();
}

class _BuyVoucherState extends State<BuyVoucher> {
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  CupertinoIcons.back,
                  color: Constants.primaryColor,
                ),
              ),
            ),
          ],
        ),
        title: TextMedium(
          text: "Buy Voucher",
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _amountSection(context),
          ),
          const SizedBox(height: 32.0),
          const Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              bottom: 16.0,
            ),
            child: VoucherType(),
          ),
          const SizedBox(height: 16.0),
          const Padding(
            padding: EdgeInsets.all(
              16.0,
            ),
            child: PaymentMethod(),
          ),
          Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: PrimaryButton(
              fontSize: 18,
              buttonText: "Pay  ₦100,000",
              onPressed: () {
                Get.to(
                  const ConfirmPurchase(),
                  transition: Transition.cupertino,
                );
              },
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
                color: Colors.black,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600),
          ),
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
            controller: _amountController,
            validator: (value) {
              if (value.toString().contains("-")) {
                return "Negative numbers not allowed";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ActionButton(
                  strokeColor: Colors.black,
                  icon: const Text(
                    "₦200",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 16,
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
                  icon: const Text(
                    "₦700",
                    style: TextStyle(
                      color: Color(0xFF505050),
                    ),
                  ),
                  radius: 16,
                  onPressed: () {
                    setState(() {
                      _amountController.text = "₦700";
                    });
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
                  onPressed: () {
                    setState(() {
                      _amountController.text = "₦1,000";
                    });
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
                  onPressed: () {
                    setState(() {
                      _amountController.text = "₦1,500";
                    });
                  },
                ),
              ),
            ],
          )
        ],
      );
}
