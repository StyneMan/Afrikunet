import 'package:afrikunet/components/cards/giftcard.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoucherType extends StatefulWidget {
  const VoucherType({Key? key}) : super(key: key);

  @override
  State<VoucherType> createState() => _VoucherTypeState();
}

class _VoucherTypeState extends State<VoucherType> {
  // late TabController tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    // tabController = TabController(length: 3, vsync: this);
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
              color: Colors.black,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(0.0),
          margin: const EdgeInsets.all(0.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFEBEBEB),
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
                      });
                    },
                    child: Text(
                      "GiftCard",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _currentIndex == 0
                                ? Constants.primaryColor
                                : const Color(0xFF5C5B5B),
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
                          ? Constants.primaryColor
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
                      });
                    },
                    child: Text(
                      "Wedding Gift",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _currentIndex == 1
                                ? Constants.primaryColor
                                : const Color(0xFF5C5B5B),
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
                          ? Constants.primaryColor
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
                      });
                    },
                    child: Text(
                      "Birthday Gift",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _currentIndex == 2
                                ? Constants.primaryColor
                                : const Color(0xFF5C5B5B),
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
                      color: _currentIndex == 2
                          ? Constants.primaryColor
                          : Colors.transparent,
                    ),
                  )
                ],
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.ellipsis_circle,
                    color: Constants.primaryColor,
                  ))
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 230,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: const [
              GiftCard(
                amount: "1000",
                bgImage: "assets/images/giftcard_bg.png",
                code: "XDT12IUNWpo1HN",
                logo: "assets/images/afrikunet_logo_white.png",
                type: "blue",
              ),
              SizedBox(width: 16.0),
              GiftCard(
                amount: "1000",
                bgImage: "assets/images/giftcard_bg.png",
                code: "XDT12IUNWpo1HN",
                logo: "assets/images/logo_blue.png",
                type: "white",
              ),
              SizedBox(width: 16.0),
            ],
          ),
        )
      ],
    );
  }
}
