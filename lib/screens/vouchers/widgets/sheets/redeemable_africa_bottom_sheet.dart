import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RedeemableInAfricaSheet extends StatelessWidget {
  const RedeemableInAfricaSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
}
