import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/buttons/secondary.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankCard extends StatelessWidget {
  var data;
  BankCard({Key? key, required this.data}) : super(key: key);

  final _controller = Get.find<StateController>();

  _obscurer(String value) {
    if (value.length == 3 || value.length == 4) {
      var lhs = value.substring(0, 1);
      var rhs = value.substring(value.length - 1, value.length);
      return "$lhs***$rhs";
    } else if (value.length == 5 || value.length == 6 || value.length == 7) {
      var lhs = value.substring(0, 2);
      var rhs = value.substring(value.length - 2, value.length);
      return "$lhs***$rhs";
    } else {
      var lhs = value.substring(0, 3);
      var rhs = value.substring(value.length - 3, value.length);
      return "$lhs***$rhs";
    }
  }

  _removeBank() async {
    try {
      _controller.setLoading(true);
      Map _payload = {
        "email_address": data['user_id'],
      };

      print("ID :: ${data['id']}");
      print("ID :: $_payload");

      final _prefs = await SharedPreferences.getInstance();
      final _accessToken = _prefs.getString('accessToken') ?? "";

      final _response = await APIService().removeBank(
          accessToken: _accessToken, payload: _payload, bankId: data['id']);
      _controller.setLoading(false);
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 8.0,
          bottom: 8.0,
          right: 0.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: '${data['logo']}',
              width: 72,
            ),
            const SizedBox(width: 3.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextMedium(
                    text: '${data['account_name']}',
                    align: TextAlign.center,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  TextBody2(
                    text: '${_obscurer(data['account_number'])}',
                    color: Theme.of(context).colorScheme.tertiary,
                    align: TextAlign.center,
                  )
                ],
              ),
            ),
            const SizedBox(width: 3.0),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => InfoDialog(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: TextMedium(
                              text: "Confirm Action",
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 18.0,
                                ),
                                TextSmall(
                                  text:
                                      "Are you sure you want to remove this bank account?",
                                  align: TextAlign.center,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: SecondaryButton(
                                        buttonText: "Cancel",
                                        foreColor: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface,
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Expanded(
                                      child: PrimaryButton(
                                        buttonText: "Yes proceed",
                                        onPressed: () {
                                          Get.back();
                                          _removeBank();
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(
                CupertinoIcons.delete_left,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
