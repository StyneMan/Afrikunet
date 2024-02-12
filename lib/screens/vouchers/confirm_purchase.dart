import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/cards/giftcard_item.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/payment/payment_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class ConfirmPurchase extends StatefulWidget {
  final PreferenceManager manager;
  const ConfirmPurchase({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<ConfirmPurchase> createState() => _ConfirmPurchaseState();
}

class _ConfirmPurchaseState extends State<ConfirmPurchase> {
  final _controller = Get.find<StateController>();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isValidEmail = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 6.0,
                    top: 4.0,
                    bottom: 4.0,
                    left: 0.0,
                  ),
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
                  text: "Confirm Purchase",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 16.0),
                Text(
                  "Purchase Info",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 32.0),
                const SizedBox(
                  height: 230,
                  width: double.infinity,
                  child: GiftCardItem(
                    width: double.infinity,
                    amount: "100,000",
                    bgImage: "assets/images/giftcard_bg.png",
                    code: "XDT12IUNWpo1HN",
                    logo: "assets/images/logo_blue.png",
                    type: "white",
                  ),
                ),
                const SizedBox(height: 32.0),
                Text(
                  "Alt email for 2FA",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 10.0),
                CustomTextField(
                  placeholder: "Enter a valid email",
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        _isValidEmail = false;
                      });
                    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                        .hasMatch(value)) {
                      setState(() {
                        _isValidEmail = false;
                      });
                    } else {
                      setState(() {
                        _isValidEmail = true;
                      });
                    }
                  },
                  endIcon: _isValidEmail
                      ? const Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : const Icon(
                          CupertinoIcons.xmark_circle_fill,
                          color: Colors.red,
                        ),
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or phone';
                    }
                    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                        .hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  inputType: TextInputType.emailAddress,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                PrimaryButton(
                  fontSize: 16,
                  buttonText: "Confirm",
                  bgColor: Theme.of(context).colorScheme.primaryContainer,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.to(
                        PaymentOptions(
                          manager: widget.manager,
                        ),
                        transition: Transition.cupertino,
                      );
                      // _showOTPDialog();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
