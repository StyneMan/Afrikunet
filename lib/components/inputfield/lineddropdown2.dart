import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/material.dart';

typedef void InitCallback(String value);

class LinedDropdown2 extends StatefulWidget {
  final String label, title;
  final InitCallback onSelected;
  final List<String> items;
  final bool isEnabled;

  const LinedDropdown2({
    Key? key,
    required this.label,
    required this.title,
    required this.onSelected,
    required this.items,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<LinedDropdown2> createState() => _LinedDropdownState();
}

class _LinedDropdownState extends State<LinedDropdown2> {
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
            width: 120,
            child: DropdownButton(
              hint: TextBody1(
                text: widget.label,
                align: TextAlign.end,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w400,
              ),
              alignment: AlignmentDirectional.centerEnd,
              items: widget.items.map((e) {
                return DropdownMenuItem(
                  value: e,
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextBody1(
                    text: e,
                    align: TextAlign.end,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }).toList(),
              value: selectVal,
              onChanged: !widget.isEnabled
                  ? null
                  : (newValue) async {
                      widget.onSelected(
                        newValue as String,
                      );
                      setState(
                        () {
                          selectVal = newValue;
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
