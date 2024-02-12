import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/bills.dart';
import 'package:afrikunet/forms/bills/cabletv_form.dart';
import 'package:afrikunet/forms/bills/electricity_form.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:flutter/material.dart';

class BillItem extends StatefulWidget {
  final String title;
  final Bills bill;
  final PreferenceManager manager;
  const BillItem({
    Key? key,
    required this.title,
    required this.bill,
    required this.manager,
  }) : super(key: key);

  @override
  State<BillItem> createState() => _BillItemState();
}

class _BillItemState extends State<BillItem>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: true,
        title: TextMedium(
          text: widget.title,
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
                  child: TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: Constants.primaryColor,
                    indicatorColor: Constants.primaryColor,
                    indicatorWeight: 2,
                    indicatorSize: TabBarIndicatorSize.label,
                    controller: tabController,
                    tabs: [
                      Tab(
                        child: widget.title.toLowerCase() == "cable tv"
                            ? Image.asset("assets/images/gotv.png")
                            : const Text(
                                "Prepaid",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "OpenSans",
                                ),
                              ),
                        height: 21,
                      ),
                      Tab(
                        child: widget.title.toLowerCase() == "cable tv"
                            ? Image.asset("assets/images/dstv.png")
                            : const Text(
                                "Postpaid",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "OpenSans",
                                ),
                              ),
                        height: 21,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: widget.title.toLowerCase() != "cable tv"
                      ? [
                          ElectricityForm(
                            networks: widget.bill.networks!,
                            manager: widget.manager,
                          ),
                          ElectricityForm(
                            networks: widget.bill.networks!,
                            manager: widget.manager,
                          ),
                        ]
                      : [
                          CableTvForm(
                            network: widget.bill.networks![0],
                            manager: widget.manager,
                          ),
                          CableTvForm(
                            network: widget.bill.networks![1],
                            manager: widget.manager,
                          ),
                        ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
