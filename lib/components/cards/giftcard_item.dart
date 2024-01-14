import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GiftCardItem extends StatelessWidget {
  final String bgImage;
  final String logo;
  final String amount;
  final String code;
  final String type;
  final double width;

  const GiftCardItem({
    Key? key,
    required this.amount,
    required this.bgImage,
    required this.code,
    required this.logo,
    required this.type,
    this.width = 350,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bgImage),
              fit: BoxFit.cover,
            ),
            color: type == "blue"
                ? Constants.primaryColor
                : const Color(0xFFC5C5CF),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        Positioned(
          top: 5,
          right: 16,
          left: 4.0,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    logo,
                    scale: 1.5,
                  ),
                  Text(
                    "$amount units",
                    style: TextStyle(
                      color: type == "blue" ? Colors.white : Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4.0),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: type == "blue" ? Colors.white : Colors.black,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: TextBody2(
                            text: code,
                            color: type == "blue" ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1.0),
                      Text(
                        "Gift Card",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: type == "blue" ? Colors.white : Colors.black,
                          fontSize: 36,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "www.afrikunet.com",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: type == "blue" ? Colors.white : Colors.black,
                          fontSize: 13,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                    ],
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Music, Games, Apps, Movies, Books and more...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: type == "blue" ? Colors.white : Colors.black,
                    fontSize: 11,
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 13,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/asterisk.svg",
                width: 10.0,
                color: type == "blue" ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 1.0),
              Text(
                "Pay",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 11,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 6.0),
              SvgPicture.asset(
                "assets/images/asterisk.svg",
                width: 10.0,
                color: type == "blue" ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 1.0),
              Text(
                "Get Paid",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 11,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 6.0),
              SvgPicture.asset(
                "assets/images/asterisk.svg",
                width: 10.0,
                color: type == "blue" ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 1.0),
              Text(
                "Split",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 11,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 6.0),
              SvgPicture.asset(
                "assets/images/asterisk.svg",
                width: 10.0,
                color: type == "blue" ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 1.0),
              Text(
                "Shop",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 11,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 6.0),
              SvgPicture.asset(
                "assets/images/asterisk.svg",
                width: 10.0,
                color: type == "blue" ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 1.0),
              Text(
                "Share",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 11,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 6.0),
              SvgPicture.asset(
                "assets/images/asterisk.svg",
                width: 10.0,
                color: type == "blue" ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 1.0),
              Text(
                "Connect",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: type == "blue" ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
