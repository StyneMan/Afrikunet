import 'package:afrikunet/components/dialog/info_dialog.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/bills.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'bill_item.dart';

class BillPay extends StatelessWidget {
  const BillPay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: true,
        title: TextHeading(
          text: "Bills",
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Constants.secondaryColor,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: const SizedBox(
                height: 8.0,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    TextSmall(
                      text: "Select bill payment",
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(height: 16.0),
                    Card(
                      elevation: 2.0,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _billRow(
                          icon: tempBills[index].icon,
                          text: tempBills[index].title,
                          bill: tempBills[index],
                          context: context,
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: tempBills.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(var context) {
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
                Icon(
                  CupertinoIcons.info_circle,
                  size: 84,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 10.0),
                TextMedium(
                  text: "Coming soon!",
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.tertiary,
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

  Widget _billRow({var icon, var text, var bill, var context}) {
    return TextButton(
      onPressed: () {
        if (!text.toString().toLowerCase().startsWith("water")) {
          Get.to(
            BillItem(title: text, bill: bill),
            transition: Transition.cupertino,
          );
        } else {
          _showDialog(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/$icon"),
                const SizedBox(
                  width: 16.0,
                ),
                TextSmall(
                  text: "$text",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.tertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
