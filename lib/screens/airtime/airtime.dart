import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/airtime-tab.dart';
import 'widgets/data-tab.dart';

class Airtime extends StatefulWidget {
  const Airtime({Key? key}) : super(key: key);

  @override
  State<Airtime> createState() => _AirtimeState();
}

class _AirtimeState extends State<Airtime> with SingleTickerProviderStateMixin {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                child: const Icon(
                  CupertinoIcons.back,
                  color: Constants.primaryColor,
                ),
              ),
            ),
            TextMedium(
              text: "Airtime",
              color: Colors.black,
            ),
          ],
        ),
        centerTitle: false,
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
                    // indicator: BoxDecoration(
                    //   color: Constants.secondaryColor,
                    //   borderRadius: BorderRadius.circular(5),
                    // ),
                    controller: tabController,
                    tabs: const [
                      Tab(
                        child: Text(
                          "Airtime",
                          style:
                              TextStyle(fontSize: 16, fontFamily: "OpenSans"),
                        ),
                        height: 21,
                      ),
                      Tab(
                        child: Text(
                          "Data",
                          style:
                              TextStyle(fontSize: 16, fontFamily: "OpenSans"),
                        ),
                        height: 21,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: const [
                    AirtimeTab(),
                    DataTab(),
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
