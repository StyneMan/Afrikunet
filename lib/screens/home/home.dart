import 'package:afrikunet/components/buttons/action.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/drawer/custom_drawer.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/screens/airtime/airtime.dart';
import 'package:afrikunet/screens/bank/add_bank.dart';
import 'package:afrikunet/screens/bills/billpay.dart';
import 'package:afrikunet/screens/vouchers/buy_voucher.dart';
import 'package:afrikunet/screens/vouchers/redeem_voucher.dart';
import 'package:afrikunet/screens/vouchers/split_voucher.dart';
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
        backgroundColor: Constants.secondaryColor,
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
            _body(),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
        decoration: const BoxDecoration(
          color: Constants.secondaryColor,
          image: DecorationImage(
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

  Widget _body() => Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ActionButton(
                        icon: SvgPicture.asset(
                          "assets/images/bill_pay.svg",
                          color: Constants.primaryColor,
                          height: 19,
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          Get.to(
                            const BillPay(),
                            transition: Transition.cupertino,
                          );
                        },
                      ),
                      const SizedBox(height: 8.0),
                      TextBody2(text: "Bill Pay")
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ActionButton(
                        icon: SvgPicture.asset(
                          "assets/images/airtime.svg",
                          color: Constants.primaryColor,
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          Get.to(
                            const Airtime(),
                            transition: Transition.cupertino,
                          );
                        },
                      ),
                      const SizedBox(height: 8.0),
                      TextBody2(text: "Airtime")
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ActionButton(
                        icon: SvgPicture.asset(
                          "assets/images/add_bank.svg",
                          color: Constants.primaryColor,
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          Get.to(
                            AddBank(),
                            transition: Transition.cupertino,
                          );
                        },
                      ),
                      const SizedBox(height: 8.0),
                      TextBody2(text: "Add Bank")
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ActionButton(
                        icon: SvgPicture.asset(
                          "assets/images/split_voucher.svg",
                          color: Constants.primaryColor,
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          Get.to(
                            const SplitVoucher(),
                            transition: Transition.cupertino,
                          );
                        },
                      ),
                      const SizedBox(height: 8.0),
                      TextBody2(
                        text: "Split Voucher",
                        align: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 36.0,
            ),
            const HomeSlider()
          ],
        ),
      );
}
