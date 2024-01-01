import 'package:afrikunet/components/buttons/action.dart';
import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/drawer/custom_drawer.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/screens/vouchers/buy_voucher.dart';
import 'package:afrikunet/screens/vouchers/redeem_voucher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
      drawer: CustomDrawer(),
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

  Widget _header(context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
        decoration: const BoxDecoration(
          color: Constants.secondaryColor,
          image: DecorationImage(
            image: AssetImage("assets/images/home_watermark.png"),
            fit: BoxFit.fill,
          ),
        ),
        height: 210,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      foregroundImage:
                          AssetImage("assets/images/developer.jpg"),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good evening, STANLEY",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          "Last login 03/12/2023 08:30pm",
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
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextSmall(text: "History", color: Colors.white),
                      const SizedBox(
                        width: 4.0,
                      ),
                      const Icon(
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
                    fontSize: 16,
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
                  width: 12.0,
                ),
                Expanded(
                  child: PrimaryButton(
                    buttonText: "Redeem Voucher",
                    fontSize: 16,
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
            )
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
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        onPressed: () {},
                      ),
                      const SizedBox(height: 8.0),
                      TextBody1(text: "Bill Pay")
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
                        onPressed: () {},
                      ),
                      const SizedBox(height: 8.0),
                      TextBody1(text: "Airtime")
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
                        onPressed: () {},
                      ),
                      const SizedBox(height: 8.0),
                      TextBody1(text: "Add Bank")
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
                        onPressed: () {},
                      ),
                      const SizedBox(height: 8.0),
                      TextBody1(text: "Split Voucher")
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
