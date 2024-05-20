import 'package:afrikunet/components/buttons/action.dart';
import 'package:afrikunet/components/inputfield/rounded_money_input.dart';
import 'package:flutter/material.dart';

// typedef void InitCallback(String amount);

class AmountSection extends StatefulWidget {
  // final InitCallback onAmounted;
  final TextEditingController controller;
  const AmountSection({
    Key? key,
    // required this.onAmounted,
    required this.controller,
  }) : super(key: key);

  @override
  State<AmountSection> createState() => _AmountSectionState();
}

class _AmountSectionState extends State<AmountSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 6.0,
        ),
        RoundedInputMoney(
          hintText: "Amount",
          onChanged: (value) {
            if (value.toString().contains("-")) {
              setState(() {
                widget.controller.text = value.toString().replaceAll("-", "");
              });
              // widget.onAmounted(value.toString().replaceAll("-", ""));
            }
          },
          strokeColor: Theme.of(context).colorScheme.tertiary,
          controller: widget.controller,
          validator: (value) {
            if (value.toString().isEmpty) {
              return "Amount is required!";
            }
            if (value.toString().contains("-")) {
              return "Negative numbers not allowed";
            }
            return null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ActionButton(
                strokeColor: Colors.black,
                icon: Text(
                  "₦200",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                bgColor:
                    Theme.of(context).colorScheme.background.withOpacity(0.8),
                radius: 10,
                onPressed: () {
                  setState(() {
                    widget.controller.text = "₦200";
                  });
                  // widget.onAmounted("₦200");
                },
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: ActionButton(
                strokeColor: Colors.black,
                icon: Text(
                  "₦500",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                radius: 10,
                bgColor:
                    Theme.of(context).colorScheme.background.withOpacity(0.8),
                onPressed: () {
                  setState(() {
                    widget.controller.text = "₦500";
                  });
                  // widget.onAmounted("₦500");
                },
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: ActionButton(
                radius: 10,
                strokeColor: Colors.black,
                icon: Text(
                  "₦1000",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                bgColor:
                    Theme.of(context).colorScheme.background.withOpacity(0.8),
                onPressed: () {
                  setState(() {
                    widget.controller.text = "₦1,000";
                  });
                  // widget.onAmounted("₦1,000");
                },
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: ActionButton(
                strokeColor: Colors.black,
                icon: Text(
                  "₦1500",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                bgColor:
                    Theme.of(context).colorScheme.background.withOpacity(0.8),
                radius: 10,
                onPressed: () {
                  setState(() {
                    widget.controller.text = "₦1,500";
                  });
                  // widget.onAmounted("₦1,500");
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
