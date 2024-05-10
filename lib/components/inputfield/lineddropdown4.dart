import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

typedef void InitCallback(var value);

class LinedDropdown4 extends StatefulWidget {
  final String title;
  var label;
  final InitCallback onSelected;
  final List<Map<String, dynamic>> items;
  final bool isEnabled;

  LinedDropdown4({
    Key? key,
    required this.label,
    required this.title,
    required this.onSelected,
    required this.items,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<LinedDropdown4> createState() => _LinedDropdownState();
}

class _LinedDropdownState extends State<LinedDropdown4> {
  var selectVal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextBody1(
            text: widget.title,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          Expanded(
            child: Container(
              width: 100,
              color: Colors.transparent,
            ),
          ),
          SizedBox(
            width: 200,
            child: DropdownButton(
              hint: TextBody1(
                text:
                    "${widget.label.toString() == "{}" ? "" : Constants.getFlagEmojiFromISO3(widget.label['iso3'])} ${widget.label.toString() == "{}" ? "" : widget.label['name']}",
                align: TextAlign.end,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w400,
              ),
              alignment: AlignmentDirectional.centerEnd,
              items: widget.items.map((e) {
                return DropdownMenuItem(
                  value: e,
                  alignment: AlignmentDirectional.centerEnd,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CountryFlag.fromCountryCode(
                      //   "${e['iso3']}".substring(0, 2),
                      //   height: 18,
                      //   width: 18,
                      //   borderRadius: 3,
                      // ),
                      const SizedBox(width: 6.0),
                      TextBody2(
                        text: "${e['name']}".length > 26
                            ? "${e['name']}".substring(0, 24) + "..."
                            : "${e['name']}",
                        align: TextAlign.end,
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                );
              }).toList(),
              value: selectVal,
              onChanged: !widget.isEnabled
                  ? null
                  : (newValue) async {
                      print("INNEC LANG SELECTED :: $newValue");
                      widget.onSelected(
                        newValue,
                      );
                      setState(
                        () {
                          selectVal = newValue as Map;
                        },
                      );
                    },
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              iconSize: 30,
              isExpanded: true,
              underline: const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
