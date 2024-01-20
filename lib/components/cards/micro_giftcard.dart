import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MicroGiftCard extends StatelessWidget {
  final String bgImage;
  final String logo;
  final String amount;
  final String code;
  final String type;
  final double width;
  const MicroGiftCard({
    Key? key,
    required this.amount,
    required this.bgImage,
    required this.code,
    required this.logo,
    required this.type,
    this.width = 128,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bgImage),
          fit: BoxFit.cover,
        ),
        color:
            type == "blue" ? Constants.primaryColor : const Color(0xFFC5C5CF),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                type == "blue"
                    ? "assets/images/afrikunet_logo_white.png"
                    : "assets/images/logo_blue.png",
                scale: 3.5,
              ),
              Text(
                "≈$amount",
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: type == "blue" ? Colors.white : Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    code,
                    style: TextStyle(
                      fontSize: 8,
                      color: type == "blue" ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              Text(
                "Gift Card",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Music, Games, Apps, Movies and more...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 5,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/asterisk.svg",
                width: 4.0,
                color: type == "blue" ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 1.0),
              Text(
                "Pay",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 7,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 2.0),
              SvgPicture.asset(
                "assets/images/asterisk.svg",
                width: 4.0,
                color: type == "blue" ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 1.0),
              Text(
                "Get Paid",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 7,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 2.0),
              SvgPicture.asset(
                "assets/images/asterisk.svg",
                width: 4.0,
                color: type == "blue" ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 1.0),
              Text(
                "Split",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 7,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 2.0),
              SvgPicture.asset(
                "assets/images/asterisk.svg",
                width: 4.0,
                color: type == "blue" ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 1.0),
              Text(
                "Share",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 7,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
