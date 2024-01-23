import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/drawer/custom_drawer.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/model/home/home_action.dart';
import 'package:afrikunet/screens/vouchers/buy_voucher.dart';
import 'package:afrikunet/screens/vouchers/redeem_voucher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../history/history.dart';
import 'widgets/home_slider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            if (!_scaffoldKey.currentState!.isDrawerOpen) {
              _scaffoldKey.currentState!.openDrawer();
            }
          },
          icon: SvgPicture.asset(
            "assets/images/drawer_icon.svg",
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/images/bell_icon.svg",
              color: Colors.white,
            ),
          )
        ],
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: ListView(
          children: [
            _header(context),
            _body(context),
          ],
        ),
      ),
    );
  }

  String getGreeting() {
    var hour = DateTime.now().hour;

    if (hour >= 0 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  Widget _header(context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 0.0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          image: const DecorationImage(
            image: AssetImage("assets/images/home_watermark.png"),
            fit: BoxFit.fill,
          ),
        ),
        height: 175,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      foregroundImage:
                          AssetImage("assets/images/developer.jpg"),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getGreeting()}, STANLEY",
                          textScaleFactor: 0.92,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          "Last login 03/12/2023 08:30pm",
                          textScaleFactor: 0.86,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'OpenSans',
                            color: Color(0xFFC5C5C5),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Get.to(
                      const HistoryScreen(),
                      transition: Transition.cupertino,
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.0,
                      vertical: 8.0,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "History",
                        textScaleFactor: 0.86,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'OpenSans',
                          color: Color(0xFFC5C5C5),
                        ),
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: PrimaryButton(
                    buttonText: "Buy Voucher",
                    fontSize: 14,
                    onPressed: () {
                      Get.to(
                        const BuyVoucher(),
                        transition: Transition.cupertino,
                      );
                    },
                    bgColor: const Color(0xFF718191),
                    foreColor: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: PrimaryButton(
                    buttonText: "Redeem Voucher",
                    fontSize: 14,
                    onPressed: () {
                      Get.to(
                        const RedeemVoucher(),
                        transition: Transition.cupertino,
                      );
                    },
                    foreColor: Constants.primaryColor,
                    bgColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 0.5)
          ],
        ),
      );

  Widget _body(context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 0.5,
                mainAxisSpacing: 0.5,
              ),
              itemBuilder: (context, index) {
                return _itemCard(homeActions[index], context);
              },
              itemCount: 8,
            ),
            TextButton(
              onPressed: () {
                double sheetHeight = MediaQuery.of(context).size.height * 0.99;

                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  builder: (context) {
                    return SizedBox(
                      height: sheetHeight,
                      width: double.infinity,
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(Icons.close_outlined),
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              const SizedBox(
                                height: 24.0,
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 100,
                                  childAspectRatio: 2 / 2,
                                  crossAxisSpacing: 0.5,
                                  mainAxisSpacing: 0.5,
                                ),
                                itemBuilder: (context, index) {
                                  return _itemCard(homeActions[index], context);
                                },
                                itemCount: homeActions.length,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  TextSmall(
                    text: "Show All",
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 21.0,
            ),
            const HomeSlider()
          ],
        ),
      );

  Widget _itemCard(HomeAction data, context) {
    return Card(
      child: TextButton(
        onPressed: () {
          Get.to(
            data.widget,
            transition: Transition.cupertino,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/${data.icon}",
                color: Theme.of(context).colorScheme.secondary,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 4.0),
              TextBody2(
                text: data.title,
                align: TextAlign.center,
                lineHeight: 1.0,
                color: Theme.of(context).colorScheme.secondary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
