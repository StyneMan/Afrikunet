import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/material.dart';

typedef void InitCallback(var value);

class LinedDropdown5 extends StatefulWidget {
  final String title;
  var label;
  final InitCallback onSelected;
  final List<Map<String, dynamic>> items;
  final bool isEnabled;

  LinedDropdown5({
    Key? key,
    required this.label,
    required this.title,
    required this.onSelected,
    required this.items,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<LinedDropdown5> createState() => _LinedDropdownState();
}

class _LinedDropdownState extends State<LinedDropdown5> {
  var selectVal;

  @override
  Widget build(BuildContext context) {
    print("LABEL DEFA :: ${widget.label}");
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
            width: 150,
            child: DropdownButton(
              hint: TextBody1(
                text:
                    "${widget.label.toString() == "{}" ? "" : widget.label['name']}",
                align: TextAlign.end,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w400,
              ),
              alignment: AlignmentDirectional.centerEnd,
              items: widget.items.map((e) {
                return DropdownMenuItem(
                  value: e,
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextBody2(
                    text: "${e['name']}".length > 24
                        ? "${e['name']}".substring(0, 21) + "..."
                        : "${e['name']}",
                    align: TextAlign.end,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }).toList(),
              onChanged: !widget.isEnabled
                  ? null
                  : (newValue) async {
                      print("SATES SELECTED :: $newValue");
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
