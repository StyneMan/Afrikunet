import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FullPaymentMethod extends StatefulWidget {
  const FullPaymentMethod({Key? key}) : super(key: key);

  @override
  State<FullPaymentMethod> createState() => _FullPaymentMethodState();
}

class _FullPaymentMethodState extends State<FullPaymentMethod> {
  bool _isChecked = true;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool _isChecked5 = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 12.0),
        Text(
          "Payment Method",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w500,
              ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(0.0),
          child: Card(
            elevation: 1.0,
            shadowColor: const Color(0xFFF2F2F2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            color: const Color(0xFFFDFDFD),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/GTBank_logo.svg/1200px-GTBank_logo.svg.png",
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextSmall(
                            text: "GTBank",
                            color: const Color(0xFF3B3B3B),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextSmall(
                            text: "Stanley Brown",
                            color: const Color(0xFF3B3B3B),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextSmall(
                            text: "12343***48",
                            color: const Color(0xFF3B3B3B),
                          ),
                        ],
                      ),
                      Checkbox(
                          value: _isChecked,
                          onChanged: (val) {
                            setState(() {
                              _isChecked = val!;
                              _isChecked2 = false;
                              _isChecked3 = false;
                              _isChecked4 = false;
                              _isChecked5 = false;
                            });
                          })
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            "https://i.pinimg.com/originals/ca/0c/70/ca0c7039ddcf224cb6b075cb59e4677e.png",
                            width: 48,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextSmall(
                            text: "52389976***742",
                            color: const Color(0xFF3B3B3B),
                          ),
                        ],
                      ),
                      Checkbox(
                        value: _isChecked2,
                        onChanged: (val) {
                          setState(() {
                            _isChecked2 = val!;
                            _isChecked = false;
                            _isChecked3 = false;
                            _isChecked4 = false;
                            _isChecked5 = false;
                          });
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: TextBody2(
                          text: "Add card",
                          color: Constants.primaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(0.0),
          child: Card(
            elevation: 1.0,
            shadowColor: const Color(0xFFF2F2F2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            color: const Color(0xFFFDFDFD),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/bank_transfer.svg",
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10.0),
                          TextSmall(
                            text: "Bank Transfer",
                            color: const Color(0xFF3B3B3B),
                          ),
                        ],
                      ),
                      Checkbox(
                        value: _isChecked3,
                        onChanged: (val) {
                          setState(() {
                            _isChecked = false;
                            _isChecked2 = false;
                            _isChecked3 = val!;
                            _isChecked4 = false;
                            _isChecked5 = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/card_payment.svg",
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10.0),
                          TextSmall(
                            text: "Card",
                            color: const Color(0xFF3B3B3B),
                          ),
                        ],
                      ),
                      Checkbox(
                        value: _isChecked4,
                        onChanged: (val) {
                          setState(() {
                            _isChecked4 = val!;
                            _isChecked2 = false;
                            _isChecked = false;
                            _isChecked3 = false;
                            _isChecked5 = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/voucher_payment.svg",
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10.0),
                          TextSmall(
                            text: "Voucher",
                            color: const Color(0xFF3B3B3B),
                          ),
                        ],
                      ),
                      Checkbox(
                        value: _isChecked5,
                        onChanged: (val) {
                          setState(() {
                            _isChecked5 = val!;
                            _isChecked4 = false;
                            _isChecked3 = false;
                            _isChecked2 = false;
                            _isChecked = false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
