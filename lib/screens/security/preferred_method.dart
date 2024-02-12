import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'barcode_screen.dart';
import 'widgets/preferred_method_bottom_sheet.dart';

class PreferredMethod extends StatefulWidget {
  final PreferenceManager manager;
  const PreferredMethod({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<PreferredMethod> createState() => _PreferredMethodState();
}

class _PreferredMethodState extends State<PreferredMethod> {
  bool _isPhoneChecked = true;
  bool _isAuthAppChecked = false;

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
          ],
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(21.0),
        children: [
          const SizedBox(height: 16.0),
          TextMedium(
            text: "Choose your preferred method",
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(height: 48.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextBody1(
                text: "Phone Number",
                color: Theme.of(context).colorScheme.tertiary,
              ),
              Checkbox.adaptive(
                value: _isPhoneChecked,
                onChanged: (value) {
                  setState(() {
                    _isPhoneChecked = value!;
                    _isAuthAppChecked = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          const Divider(),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextBody1(
                text: "Authenticator App",
                color: Theme.of(context).colorScheme.tertiary,
              ),
              Checkbox.adaptive(
                value: _isAuthAppChecked,
                onChanged: (value) {
                  setState(() {
                    _isAuthAppChecked = value!;
                    _isPhoneChecked = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 60.0),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              buttonText: "Proceed",
              fontSize: 15,
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () {
                if (_isPhoneChecked) {
                  Get.bottomSheet(
                    PreferredMethodBottomSheet(
                      manager: widget.manager,
                      caller: _isPhoneChecked ? "phone" : "auth-app",
                      title: _isPhoneChecked
                          ? "Enter your whatsapp number"
                          : "Enter the code generated by your authenticator app (e.g google authenticator, microsoft authenticator)",
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                  );
                } else {
                  Get.to(
                    Barcode2FA(),
                    transition: Transition.cupertino,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
