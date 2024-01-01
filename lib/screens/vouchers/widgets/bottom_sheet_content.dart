import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/temp_accounts.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/auth/otp/verifyotp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VoucherBottomSheet extends StatefulWidget {
  const VoucherBottomSheet({Key? key}) : super(key: key);

  @override
  State<VoucherBottomSheet> createState() => _VoucherBottomSheetState();
}

class _VoucherBottomSheetState extends State<VoucherBottomSheet> {
  int _currIndex = 0;
  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(8.0),
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
          Column(
            children: [
              TextMedium(
                text: "Your voucher is valid and worth",
                fontWeight: FontWeight.w500,
                color: const Color(0xFF131313),
              ),
              const SizedBox(height: 8.0),
              Text(
                "${Constants.nairaSign(context).currencySymbol}1,000,000",
                style: const TextStyle(
                  fontSize: 30,
                  color: Color(0xFF161616),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16.0),
              TextBody1(
                text: "Choose a redeeming bank account",
                fontWeight: FontWeight.w500,
                color: const Color(0xFF505050),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < tempAccounts.length; i++)
                _accountRow(tempAccounts[i], i)
            ],
          ),
          const SizedBox(height: 24.0),
          PrimaryButton(
              fontSize: 17,
              buttonText: "Continue",
              onPressed: () {
                Get.back();
                _controller.setLoading(true);
                Future.delayed(const Duration(seconds: 3), () {
                  _controller.setLoading(false);
                  Get.to(
                    VerifyOTP(
                      caller: 'voucher',
                      email: 'wenprecious@gamail.com',
                    ),
                    transition: Transition.cupertino,
                  );
                });
              }),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _accountRow(AccountModel data, int index) {
    return Card(
      child: TextButton(
        onPressed: () {
          setState(() {
            _currIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(data.bankLogo),
                  TextSmall(text: data.bankName),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextMedium(text: data.accName),
                  TextSmall(text: data.accNumber),
                ],
              ),
              _currIndex == index
                  ? SvgPicture.asset("assets/images/inactive_rect.svg")
                  : SvgPicture.asset("assets/images/active_rect.svg"),
            ],
          ),
        ),
      ),
    );
  }
}
