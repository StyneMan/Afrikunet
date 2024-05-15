import 'dart:convert';

import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/redeem_actions.dart';

class RedeemVoucher extends StatefulWidget {
  final PreferenceManager manager;
  const RedeemVoucher({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<RedeemVoucher> createState() => _RedeemVoucherState();
}

class _RedeemVoucherState extends State<RedeemVoucher> {
  final _controller = Get.find<StateController>();

  _initBanks() async {
    try {
      final _bankAccountsResponse = await APIService().fetchUserBankAccounts(
        accessToken: widget.manager.getAccessToken(),
        userId: widget.manager.getUser()['email_address'],
      );

      if (_bankAccountsResponse.statusCode >= 200 &&
          _bankAccountsResponse.statusCode <= 299) {
        Map<String, dynamic> data = jsonDecode(_bankAccountsResponse.body);
        print("MY BANK ACCOUNTS  ::: ${data['data']}");
        _controller.userBankAccounts.value = data['data'];
      }
    } catch (e) {
      print("$e");
    }
  }

  @override
  void initState() {
    super.initState();
    _initBanks();
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
              text: "Redeem Voucher",
              color: Theme.of(context).colorScheme.tertiary,
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
                  Image.asset("assets/images/money_bank.png"),
                  const SizedBox(height: 24.0),
                  TextLarge(
                    text: "Redeem your voucher via scanning or code",
                    align: TextAlign.center,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 10.0),
                  TextBody1(
                    text: "Your choice, Your Purchase. Quick and easy",
                    align: TextAlign.center,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  VoucherRedeemActions(
                    manager: widget.manager,
                    caller: 'bank',
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
