import 'dart:typed_data';

import 'package:afrikunet/helper/constants/constants.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> makePdf() async {
  final pdf = Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/images/logo_blue.png'))
          .buffer
          .asUint8List());
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 32,
                    width: 32,
                    child: Image(imageLogo),
                  ),
                  Text(
                    "AfriKunet ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Center(
              child: Text(
                "Here are vital information about your transaction",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: PdfColors.black,
                ),
              ),
            ),
            SizedBox(height: 36.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Type",
                    style: const TextStyle(
                      fontSize: 14,
                    )),
                Text(
                  "Voucher Purchase",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Amount",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "NGN${Constants.formatMoneyFloat(double.parse('2000.00'))}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Amount Paid",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "NGN200.00",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Reference",
                    style: const TextStyle(
                      fontSize: 14,
                    )),
                Text(
                  "'9fnijiddie%jf2'",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Email address",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "email@domain.com",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Payment method",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Bank transfer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Description",
                    style: const TextStyle(
                      fontSize: 14,
                    )),
                Text(
                  "trsskjks dksjdksjdk kdsjdks",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Initiated on",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "10/01/2024 (about 5 mins ago)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Status",
                    style: const TextStyle(
                      fontSize: 14,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: PdfColors.green),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "success".capitalize!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}
