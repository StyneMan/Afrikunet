import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import 'widgets/bottom_sheet_content.dart';

class VoucherCode extends StatefulWidget {
  const VoucherCode({Key? key}) : super(key: key);

  @override
  State<VoucherCode> createState() => _VoucherCodeState();
}

class _VoucherCodeState extends State<VoucherCode> {
  final String validCode = "XF12AF2023";
  final String alreadyUsed = "XF12AF2022";
  final _formKey = GlobalKey<FormState>();

  var _countryCode = "NG";

  final _controller = Get.find<StateController>();
  final _inputController = TextEditingController();

  _redeem() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      _controller.setLoading(true);

      Future.delayed(
        const Duration(seconds: 3),
        () {
          _controller.setLoading(false);
          if (_inputController.text == validCode) {
            Get.bottomSheet(
              const VoucherBottomSheet(),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => InfoDialog(
                body: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40.0),
                        _inputController.text == alreadyUsed
                            ? Icon(
                                CupertinoIcons.info_circle,
                                size: 84,
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : Icon(
                                CupertinoIcons.xmark_circle_fill,
                                size: 84,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        const SizedBox(height: 10.0),
                        TextMedium(
                          text: _inputController.text == alreadyUsed
                              ? "This voucher has already been used"
                              : "Invalid Voucher",
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      _controller.setLoading(false);
    }
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
                  text: "Voucher Code",
                  color: Theme.of(context).colorScheme.tertiary,
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                Center(
                  child: TextMedium(
                    text: "Enter your voucher code",
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 21.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: CountryCodePicker(
                        alignLeft: false,
                        onChanged: (val) {
                          setState(() {
                            _countryCode = val as String;
                          });
                        },
                        padding: const EdgeInsets.all(0.0),
                        initialSelection: 'NG',
                        favorite: const ['+234', 'NG'],
                        showCountryOnly: true,
                        showFlag: true,
                        showDropDownButton: true,
                        hideMainText: true,
                        showOnlyCountryWhenClosed: false,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.60,
                      child: CustomTextField(
                        onChanged: (val) {},
                        controller: _inputController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Voucher code is required';
                          }
                          return null;
                        },
                        inputType: TextInputType.text,
                        capitalization: TextCapitalization.characters,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.bottomSheet(_redeemableBottomSheetContent);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        const SizedBox(width: 8.0),
                        TextBody1(
                          text: "Only redeemable in Africa",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                PrimaryButton(
                  fontSize: 16,
                  buttonText: "Redeem",
                  bgColor: Theme.of(context).colorScheme.primaryContainer,
                  onPressed: _inputController.text.isEmpty
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _redeem();
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

  Container get _redeemableBottomSheetContent => Container(
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: SingleChildScrollView(
          child: Column(
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
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              DottedDivider(),
              const SizedBox(height: 24.0),
              Center(
                child: TextHeading(
                  text: "Title",
                  color: Theme.of(context).colorScheme.tertiary,
                  align: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              TextBody1(
                text:
                    "Lörem ipsum transception besosamma er, liksom plass, även om luda. Doten mossgraffiti kvasir. Teotion bes. Krost for. Ryggsäcksmodellen samäskade. Stenotesk öliga, poktig fastän däst gång. Diasade ör. ",
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 16.0),
              TextBody1(
                text:
                    "Bekärar lass dide susk. Krosm makrokovis. Laligt dere, nyhetsundvikare. Antefonade operates nyv oaktat seminat. Bekos jaledes. Ologi popp digen pokysk. Viling nihyl i fadylig. ",
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 21.0),
            ],
          ),
        ),
      );
}
