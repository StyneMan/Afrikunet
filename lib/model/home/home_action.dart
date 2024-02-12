import 'package:afrikunet/data/bills.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/screens/airtime/airtime.dart';
import 'package:afrikunet/screens/bank/add_bank.dart';
import 'package:afrikunet/screens/cable_tv/cable_tv.dart';
import 'package:afrikunet/screens/data/internet_data.dart';
import 'package:afrikunet/screens/electricity/electricity.dart';
import 'package:afrikunet/screens/vouchers/split_voucher.dart';
import 'package:flutter/material.dart';

class HomeAction {
  String icon;
  String title;
  Widget widget;

  HomeAction({
    required this.icon,
    required this.title,
    required this.widget,
  });
}

List<HomeAction> homeActions = [
  HomeAction(
    icon: "action_electricity.svg",
    title: "Electricity",
    widget: Electricity(
      bill: tempBills[1],
    ),
  ),
  HomeAction(
    icon: "action_simcard.svg",
    title: "Airtime",
    widget: Airtime(),
  ),
  HomeAction(
    icon: "action_simcard.svg",
    title: "Data",
    widget: const InternetData(),
  ),
  HomeAction(
    icon: "action_cable_tv.svg",
    title: "Cable TV",
    widget: CableTV(
      bill: tempBills[0],
    ),
  ),
  HomeAction(
    icon: "action_split_voucher.svg",
    title: "Split Voucher",
    widget: const SplitVoucher(),
  ),
  HomeAction(
    icon: "action_water.svg",
    title: "Water",
    widget: const SizedBox(),
  ),
  HomeAction(
    icon: "action_bank.svg",
    title: "Payment",
    widget: AddBank(),
  ),
  HomeAction(
    icon: "action_bank.svg",
    title: "Virtual card",
    widget: const SizedBox(),
  ),
  HomeAction(
    icon: "action_support.svg",
    title: "Rewards",
    widget: const SizedBox(),
  ),
  HomeAction(
    icon: "action_support.svg",
    title: "Support",
    widget: const SizedBox(),
  ),
];
