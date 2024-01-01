import 'package:afrikunet/components/dividers/dotted_divider.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/material.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  bool _isChecked = true;
  bool _isChecked2 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(1.0),
      child: Card(
        elevation: 2.0,
        shadowColor: const Color(0xFFD0D0D0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        color: const Color(0xFFF2F2F2),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12.0),
              Text(
                "Payment Method",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DottedDivider(),
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
                        width: 60,
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
                        });
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
