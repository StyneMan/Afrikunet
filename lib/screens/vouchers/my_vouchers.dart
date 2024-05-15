import 'dart:convert';

import 'package:afrikunet/components/cards/micro_giftcard.dart';
import 'package:afrikunet/components/shimmer/banner_shimmer.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/vouchers/buy_voucher.dart';
import 'package:afrikunet/screens/vouchers/voucher_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MyVouchersPage extends StatelessWidget {
  final PreferenceManager manager;
  MyVouchersPage({
    Key? key,
    required this.manager,
  }) : super(key: key);

  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextMedium(
              text: "My Vouchers",
              color: Theme.of(context).colorScheme.tertiary,
            ),
            SvgPicture.asset(
              "assets/images/mi_voucher.svg",
              width: 48,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<http.Response>(
            future: APIService().getUserVouchers(
              accessToken: manager.getAccessToken(),
              page: 1,
              limit: 2,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return const BannerShimmer();
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemCount: 4,
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: TextBody2(
                    text: 'An error occured. Check your internet!',
                  ),
                );
              }

              final data = snapshot.data;
              print('my voucher response ;; ${data!.body}');
              Map<String, dynamic> _map = jsonDecode(data.body);

              if (_map['vouchers'].isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/empty.png"),
                      TextSmall(
                        text: "You have not purchased any vouchers",
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Get.to(BuyVoucher(manager: manager));
                        },
                        icon: Icon(
                          CupertinoIcons.add,
                          size: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        label: TextBody2(
                          text: "Buy voucher",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(1.0),
                  itemBuilder: (context, index) {
                    final item = _controller.userVouchers.value[index];
                    return TextButton(
                      onPressed: () {
                        Get.to(
                          VoucherDetail(data: item),
                          transition: Transition.cupertino,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 140,
                                  height: 96,
                                  child: MicroGiftCard(
                                    amount: "${item['amount']}",
                                    bgType: item['bg_type'],
                                    code: item['code'],
                                    status: item['status'],
                                    type: item['type'],
                                  ),
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextSmall(
                                      text:
                                          "Voucher  ${item['code'].toString().substring(0, 4)}****",
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                    TextBody2(
                                      text:
                                          "${Constants.formatDate("${item['created_at']}")} (${Constants.timeUntil(DateTime.parse(item['created_at']))})",
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Column(
                    children: [
                      SizedBox(height: 16.0),
                      Divider(),
                      SizedBox(height: 16.0),
                    ],
                  ),
                  itemCount: _controller.userVouchers.value.length,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
