import 'dart:async';
import 'dart:developer';

import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:get/get.dart';

class VoucherScanner extends StatefulWidget {
  const VoucherScanner({Key? key}) : super(key: key);

  @override
  State<VoucherScanner> createState() => _VoucherScannerState();
}

class _VoucherScannerState extends State<VoucherScanner> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

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
            TextMedium(
              text: "Voucher Scanner",
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ScalableOCR(
              paintboxCustom: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4.0
                ..color = const Color.fromARGB(153, 102, 160, 241),
              boxLeftOff: 0,
              boxBottomOff: 2.5,
              boxRightOff: 0,
              boxTopOff: 2.5,
              boxHeight: MediaQuery.of(context).size.height * .75,
              getRawData: (value) {
                inspect(value);
              },
              getScannedText: (value) {
                setText(value);
              },
            ),
            StreamBuilder<String>(
              stream: controller.stream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Result(
                    text: snapshot.data != null ? snapshot.data! : "");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text("Readed text: $text");
  }
}
