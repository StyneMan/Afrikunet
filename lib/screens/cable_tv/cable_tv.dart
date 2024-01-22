import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/bills.dart';
import 'package:afrikunet/forms/bills/cabletv_form.dart';
import 'package:flutter/material.dart';

class CableTV extends StatefulWidget {
  final Bills bill;
  const CableTV({
    Key? key,
    required this.bill,
  }) : super(key: key);

  @override
  State<CableTV> createState() => _CableTVState();
}

class _CableTVState extends State<CableTV> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: true,
        title: TextMedium(
          text: "CableTV",
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  margin: const EdgeInsets.all(0.5),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: CableTvForm(
                  network: widget.bill.networks![0],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
