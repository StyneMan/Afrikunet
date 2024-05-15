import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/cards/giftcard_item.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/screens/vouchers/confirm_purchase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoucherType extends StatefulWidget {
  final String finalValue;
  final String currentAmount;
  final PreferenceManager manager;
  final bool hasFetchedCharge;
  const VoucherType({
    Key? key,
    required this.manager,
    required this.finalValue,
    required this.currentAmount,
    required this.hasFetchedCharge,
  }) : super(key: key);

  @override
  State<VoucherType> createState() => _VoucherTypeState();
}

class _VoucherTypeState extends State<VoucherType> {
  int _currentIndex = 0;
  int _voucherIndex = 0;
  String _currentVoucherType = 'gift card';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Voucher Type",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(0.0),
          margin: const EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                        _currentVoucherType = "gift card";
                      });
                    },
                    child: Text(
                      "GiftCard",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _currentIndex == 0
                                ? Theme.of(context).colorScheme.inverseSurface
                                : const Color(0xFF5C5B5B),
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 1.5,
                      color: _currentIndex == 0
                          ? Theme.of(context).colorScheme.inverseSurface
                          : Colors.transparent,
                    ),
                  )
                ],
              ),
              const SizedBox(width: 8.0),
              Stack(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 1;
                        _currentVoucherType = "wedding";
                      });
                    },
                    child: Text(
                      "Wedding",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _currentIndex == 1
                                ? Theme.of(context).colorScheme.inverseSurface
                                : const Color(0xFF5C5B5B),
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 1.5,
                      color: _currentIndex == 1
                          ? Theme.of(context).colorScheme.inverseSurface
                          : Colors.transparent,
                    ),
                  )
                ],
              ),
              const SizedBox(width: 8.0),
              Stack(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 2;
                        _currentVoucherType = "birthday";
                      });
                    },
                    child: Text(
                      "Birthday",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _currentIndex == 2
                                ? Theme.of(context).colorScheme.inverseSurface
                                : const Color(0xFF5C5B5B),
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 1.5,
                      color: _currentIndex == 2
                          ? Theme.of(context).colorScheme.inverseSurface
                          : Colors.transparent,
                    ),
                  )
                ],
              ),
              const SizedBox(width: 8.0),
              Stack(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 3;
                        _currentVoucherType = "holiday";
                      });
                    },
                    child: Text(
                      "Holiday",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _currentIndex == 3
                                ? Theme.of(context).colorScheme.inverseSurface
                                : const Color(0xFF5C5B5B),
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 1.5,
                      color: _currentIndex == 3
                          ? Theme.of(context).colorScheme.inverseSurface
                          : Colors.transparent,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 258,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _voucherIndex = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GiftCardItem(
                        amount: widget.finalValue,
                        bgType: "blue",
                        code: "XYZ**********",
                        status: "unused",
                        type: _currentVoucherType,
                        width: 285,
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Radio(
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      value: 0,
                      groupValue: _voucherIndex,
                      onChanged: null,
                    ),
                  ],
                ),
                style: TextButton.styleFrom(padding: const EdgeInsets.all(0.0)),
              ),
              const SizedBox(width: 16.0),
              TextButton(
                onPressed: () {
                  setState(() {
                    _voucherIndex = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GiftCardItem(
                        amount: widget.finalValue,
                        bgType: "white",
                        code: "XDT12IUNWpo1HN",
                        status: "unused",
                        type: _currentVoucherType,
                        width: 285,
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Radio(
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      value: 1,
                      groupValue: _voucherIndex,
                      onChanged: null,
                    ),
                  ],
                ),
                style: TextButton.styleFrom(padding: const EdgeInsets.all(0.0)),
              ),
              const SizedBox(width: 16.0),
              TextButton(
                onPressed: () {
                  setState(() {
                    _voucherIndex = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GiftCardItem(
                        amount: widget.finalValue,
                        bgType: "black",
                        code: "XDT12IUNWpo1HN",
                        type: _currentVoucherType,
                        width: 285,
                        status: 'used',
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Radio(
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      value: 2,
                      groupValue: _voucherIndex,
                      onChanged: null,
                    ),
                  ],
                ),
                style: TextButton.styleFrom(padding: const EdgeInsets.all(0.0)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: PrimaryButton(
            fontSize: 16,
            buttonText: "Pay  ${widget.currentAmount}",
            bgColor: Theme.of(context).colorScheme.primaryContainer,
            onPressed: widget.currentAmount.isEmpty || !widget.hasFetchedCharge
                ? null
                : () {
                    Get.to(
                      ConfirmPurchase(
                        manager: widget.manager,
                        payload: {
                          "voucherType": _currentVoucherType,
                          "amount": widget.currentAmount,
                          "voucherIndex": _voucherIndex,
                          "finalValue": widget.finalValue,
                        },
                      ),
                      transition: Transition.cupertino,
                    );
                  },
          ),
        ),
      ],
    );
  }
}
