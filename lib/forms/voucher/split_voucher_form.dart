import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/buttons/secondary.dart';
import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:afrikunet/components/inputfield/textarea2.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/vouchers/widgets/add_user_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplitVoucherForm extends StatelessWidget {
  SplitVoucherForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  final _amountController = TextEditingController();
  final _amountPayingController = TextEditingController();
  final _reasonController = TextEditingController();

  _splitNow(context) {
    _controller.setLoading(true);
    Future.delayed(const Duration(seconds: 3), () {
      _controller.setLoading(false);
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => InfoDialog(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24.0),
                  SvgPicture.asset("assets/images/check_all.svg"),
                  const SizedBox(height: 10.0),
                  TextSmall(
                    text: " again.",
                    align: TextAlign.center,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: double.infinity,
                    child: PrimaryButton(
                      buttonText: "Done",
                      fontSize: 15,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSmall(
            text: "Amount to split",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(
            height: 4.0,
          ),
          RoundedInputMoney(
            hintText: "Amount",
            enabled: true,
            strokeColor: Theme.of(context).colorScheme.tertiary,
            onChanged: (value) {
              if (value.toString().contains("-")) {
                // setState(() {
                //   _amountController.text = value.toString().replaceAll("-", "");
                // });
              }
            },
            controller: _amountController,
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Amount is required!";
              }
              if (value.toString().contains("-")) {
                return "Negative numbers not allowed";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          TextSmall(
            text: "Amount I'm Paying",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(
            height: 4.0,
          ),
          RoundedInputMoney(
            hintText: "Amount",
            enabled: true,
            strokeColor: Theme.of(context).colorScheme.tertiary,
            onChanged: (value) {
              if (value.toString().contains("-")) {
                // setState(() {
                //   _amountController.text = value.toString().replaceAll("-", "");
                // });
              }
            },
            controller: _amountPayingController,
            validator: (value) {
              if (value.toString().isEmpty) {
                return "Amount is required!";
              }
              if (value.toString().contains("-")) {
                return "Negative numbers not allowed";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          TextSmall(
            text: "Purpose of Split",
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(
            height: 4.0,
          ),
          CustomTextArea2(
            hintText: "",
            onChanged: (value) {},
            controller: _reasonController,
            validator: (value) {},
            inputType: TextInputType.text,
            maxLines: 3,
            borderRadius: 6.0,
            capitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 2.0),
          SizedBox(
            width: 100,
            child: TextButton(
              onPressed: () {
                Get.bottomSheet(
                  const AddUserBottomSheet(),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextSmall(
                    text: "Add User ",
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 3.0),
                  Icon(
                    CupertinoIcons.add,
                    size: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSmall(
                          text:
                              "${_controller.usersVoucherSplit.value[index]['email_phone']}",
                          color: Constants.accentColor,
                        ),
                        TextBody1(
                          text:
                              "${_controller.usersVoucherSplit.value[index]['amount']} ≈ 4 units",
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        _showDeleteDialog(context: context, index: index);
                      },
                      icon: SvgPicture.asset("assets/images/delete.svg"),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _controller.usersVoucherSplit.length,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              buttonText: "Proceed",
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _splitNow(context);
                }
              },
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  _showDeleteDialog({var context, required int index}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => InfoDialog(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                const Icon(
                  CupertinoIcons.info_circle,
                  size: 84,
                  color: Constants.primaryColor,
                ),
                const SizedBox(height: 10.0),
                TextSmall(
                  text: "Are you sure you want to delete this user?",
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        buttonText: "Cancel",
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: PrimaryButton(
                        buttonText: "Delete",
                        onPressed: () {
                          _remove(index);
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _remove(index) {
    debugPrint("CURR INDEX >> >> $index");
    _controller.usersVoucherSplit.removeAt(index);
  }
}
