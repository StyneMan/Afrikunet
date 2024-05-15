import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MicroVoucherCard extends StatelessWidget {
  final String bgType;
  final String status;
  final String amount;
  final String code;
  final String type;
  final double? width;

  const MicroVoucherCard({
    Key? key,
    required this.amount,
    required this.bgType,
    required this.code,
    required this.status,
    required this.type,
    this.width = 128,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/giftcard_bg.png'),
          fit: BoxFit.cover,
        ),
        color: bgType == "blue"
            ? Constants.primaryColor
            : bgType == "black"
                ? Colors.black
                : const Color(0xFFC5C5CF),
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
                bgType == "blue" || bgType == "black"
                    ? "assets/images/afrikunet_logo_white.png"
                    : "assets/images/logo_blue.png",
                scale: 3.5,
              ),
              Text(
                "≈$amount",
                style: TextStyle(
                  color: bgType == "blue" || bgType == "black"
                      ? Colors.white
                      : Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1.0),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Voucher",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: bgType == "blue"
                            ? Constants.primaryColor
                            : bgType == "black"
                                ? Colors.black
                                : const Color(0xFFC5C5CF),
                        fontSize: 10,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "www.afrikunet.com",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: bgType == "blue"
                            ? Constants.primaryColor
                            : bgType == "black"
                                ? Colors.black
                                : const Color(0xFFC5C5CF),
                        fontSize: 4,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 4.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(
                        1.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: bgType == "blue"
                              ? Constants.primaryColor
                              : bgType == "black"
                                  ? Colors.black
                                  : const Color(0xFFC5C5CF),
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          code,
                          style: TextStyle(
                            fontSize: 7,
                            color: bgType == "blue"
                                ? Constants.primaryColor
                                : bgType == "black"
                                    ? Colors.black
                                    : const Color(0xFFC5C5CF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //           SvgPicture.asset(
                          //             "assets/images/$logo",
                          //             color: bgType == "blue"
                          // ? Constants.primaryColor
                          // : bgType == "black"
                          //     ? Colors.black
                          //     : const Color(0xFFC5C5CF),
                          //             width: 10,
                          //           ),
                          Text(
                            type,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 8,
                              color:
                                  type == "blue" ? Colors.white : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
