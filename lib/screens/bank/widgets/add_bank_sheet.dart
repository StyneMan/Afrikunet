import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBankSheet extends StatelessWidget {
  const AddBankSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
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
                        size: 21,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                DottedDivider(),
                const SizedBox(height: 10.0),
                Column(
                  children: [
                    TextBody1(
                      text: "Select Bank",
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // final RenderBox renderBox =
                        //     key.currentContext.findRenderObject();
                        // final componentPosition =
                        //     renderBox.localToGlobal(Offset.zero);
                      },
                      child: const Text('Add Bank +'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: PrimaryButton(
              fontSize: 16,
              buttonText: "Continue",
              onPressed: () {
                //
              },
            ),
          ),
        ],
      ),
    );
  }
}
