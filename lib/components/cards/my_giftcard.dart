import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/giftcards.dart' as GiftCard;

class MyGiftCard extends StatelessWidget {
  final double height;
  final GiftCard.Card data;
  const MyGiftCard({
    Key? key,
    required this.data,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(data.bgImage),
          fit: BoxFit.cover,
        ),
        color: data.type == "blue"
            ? Constants.primaryColor
            : const Color(0xFFC5C5CF),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 21.0),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Gift Card",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: data.type == "blue" ? Colors.white : Colors.black,
                      fontSize: 24,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.0,
                      vertical: 16.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            data.type == "blue" ? Colors.white : Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: TextSmall(
                        text: data.code,
                        color:
                            data.type == "blue" ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextBody1(
                    text: "Status: ",
                    color: data.type == "blue" ? Colors.white : Colors.black,
                  ),
                  TextSmall(text: data.status),
                ],
              ),
              SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/${data.logo}",
                      color: data.type == "blue" ? Colors.white : Colors.black,
                      width: 28,
                    ),
                    data.event != null
                        ? Expanded(
                            child: TextBody1(
                              text: data.event ?? "",
                              align: TextAlign.center,
                              color: data.type == "blue"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
