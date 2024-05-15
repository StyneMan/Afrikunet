import 'dart:convert';

import 'package:afrikunet/components/shimmer/banner_shimmer.dart';
import 'package:afrikunet/components/shimmer/cart_shimmer.dart';
import 'package:afrikunet/components/shimmer/product_shimmer.dart';
import 'package:afrikunet/components/shimmer/summary_shimmer.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/forms/bank/add_bank.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import 'package:http/http.dart' as http;
import 'widgets/bank_card.dart';

class AddBank extends StatelessWidget {
  final PreferenceManager manager;
  AddBank({
    Key? key,
    required this.manager,
  }) : super(key: key);

  final _accController = TextEditingController();
  var _selectedBank = "";
  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
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
                  text: "Add Bank",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: SafeArea(
            child: StreamBuilder<http.Response>(
              stream: APIService().getUserBankAccounts(
                accessToken: manager.getAccessToken(),
                emailAddress: manager.getUser()['email_address'],
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, index) {
                      return const SizedBox(
                        height: 125,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: BannerShimmer(),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: 4,
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('An error occurred! Check your internet'));
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/empty.png"),
                        TextSmall(
                          text: "No bank account added",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showBankBottomSheet(context);
                          },
                          icon: Icon(
                            CupertinoIcons.add,
                            size: 16,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          label: TextBody2(
                            text: "Add bank",
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var dt = snapshot.data;
                Map<String, dynamic> _mp = jsonDecode(dt!.body);
                print("TOROBINA HERE ::: ${dt.body}");

                if ((_mp['data'] ?? [])?.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/empty.png"),
                        TextSmall(
                          text: "No bank account added",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showBankBottomSheet(context);
                          },
                          icon: Icon(
                            CupertinoIcons.add,
                            size: 16,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          label: TextBody2(
                            text: "Add bank",
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        var data = _mp['data'][index];
                        return BankCard(data: data);
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: (_mp['data'] ?? []).length,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            showBankBottomSheet(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.add,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                  size: 13,
                                ),
                                TextBody2(
                                  text: 'Add more',
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  showBankBottomSheet(var context) {
    double sheetHeight = MediaQuery.of(context).size.height * 0.75;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: sheetHeight,
          width: double.infinity,
          child: const Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: AddBankForm(),
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
