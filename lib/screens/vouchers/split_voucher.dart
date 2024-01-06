import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplitVoucher extends StatefulWidget {
  const SplitVoucher({Key? key}) : super(key: key);

  @override
  State<SplitVoucher> createState() => _SplitVoucherState();
}

class _SplitVoucherState extends State<SplitVoucher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                child: const Icon(
                  CupertinoIcons.back,
                  color: Constants.primaryColor,
                ),
              ),
            ),
            TextMedium(
              text: "Split Voucher",
              color: Colors.black,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset("assets/images/split.png"),
                  const SizedBox(height: 24.0),
                  TextLarge(
                    text: "Welcome to Split Voucher",
                    align: TextAlign.center,
                    color: const Color(0xFF262626),
                  ),
                  const SizedBox(height: 10.0),
                  TextBody1(
                    text:
                        "Users can divide vouchers into multiple parts, allowing for greater flexibility and customization in how the voucher is used.",
                    align: TextAlign.center,
                    color: const Color(0xFF5D5D5D),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      buttonText: "Proceed",
                      fontSize: 15,
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
