import 'package:afrikunet/components/cards/giftcard_item.dart';
import 'package:afrikunet/components/cards/giftcard_mini.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/forms/voucher/split_voucher_form.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class VoucherSplittingScreen extends StatelessWidget {
  final String type;
  const VoucherSplittingScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StateController>(builder: (controller) {
      return LoadingOverlayPro(
        isLoading: controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
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
                    child: const Icon(
                      CupertinoIcons.back,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
                TextMedium(
                  text: "",
                  color: Colors.black,
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  elevation: 2.0,
                  child: type == "blue"
                      ? const SizedBox(
                          height: 165,
                          child: GiftCardMini(
                            amount: "1000",
                            bgImage: "assets/images/giftcard_bg.png",
                            code: "XDT12IUNWpo1HN",
                            logo: "assets/images/afrikunet_logo_white.png",
                            type: "blue",
                          ),
                        )
                      : const SizedBox(
                          height: 165,
                          child: GiftCardMini(
                            amount: "1000",
                            bgImage: "assets/images/giftcard_bg.png",
                            code: "XDT12IUNWpo1HN",
                            logo: "assets/images/logo_blue.png",
                            type: "white",
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24.0),
              SplitVoucherForm()
            ],
          ),
        ),
      );
    });
  }
}
