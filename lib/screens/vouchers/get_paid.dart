import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/forms/voucher/payment_link_form.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class GetPaid extends StatefulWidget {
  final PreferenceManager manager;
  const GetPaid({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<GetPaid> createState() => _GetPaidState();
}

class _GetPaidState extends State<GetPaid> {
  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: true,
            title: TextMedium(
              text: "Generate Link",
              color: Colors.white,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Image.asset("assets/images/money_bank.png", width: 64),
                // TextSmall(
                //   text: "Lorem ipsum ... ",
                //   align: TextAlign.center,
                // ),
                const SizedBox(
                  height: 10.0,
                ),
                PaymentLinkForm(
                  manager: widget.manager,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
