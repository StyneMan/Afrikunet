import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dialog/success_dialog.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Barcode2FA extends StatelessWidget {
  Barcode2FA({Key? key}) : super(key: key);

  final _controller = Get.find<StateController>();
  final _inputController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
              ],
            ),
            centerTitle: false,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Center(
                  child: QrImageView(
                    data: 'BVCEEDGJSIUUAT',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: TextBody1(
                    text:
                        'Open the authentication application and scan the QR cod using your phone’s camera or enter the secret code below.',
                    align: TextAlign.center,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding: const EdgeInsets.all(10.0),
                    child: TextBody2(
                      text:
                          '*Please Save secret code and do not uninstall authentication application',
                      align: TextAlign.center,
                      color: const Color(0XFFF72B2B),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0XFFEBEBEB),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.5),
                        child: TextBody1(
                          text: ' BVCEEDGJSIUUAT',
                          align: TextAlign.center,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            const ClipboardData(
                              text: "BVCEEDGJSIUUAT",
                            ),
                          );
                          Constants.toast(
                            "Code copied to clipboard",
                          );
                        },
                        icon: SvgPicture.asset(
                          "assets/images/copy_icon.svg",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                TextBody2(
                  text:
                      'After completing the above step, enter the 6 digit code received from the authenticator application and press \'Enable 2FA\'.',
                  align: TextAlign.center,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 48.0),
                SizedBox(
                  width: double.infinity,
                  child: CustomTextField(
                    onChanged: (val) {},
                    controller: _inputController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Secret code is required';
                      }
                      return null;
                    },
                    inputType: TextInputType.text,
                    capitalization: TextCapitalization.sentences,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    buttonText: "Enable 2FA",
                    fontSize: 15,
                    bgColor: Theme.of(context).colorScheme.primaryContainer,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _controller.setLoading(true);
                        Future.delayed(
                          const Duration(seconds: 3),
                          () {
                            _controller.setLoading(false);
                            Dialogs.showSuccessDialog(
                              context: context,
                              message: "You have successfully added 2FA",
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
