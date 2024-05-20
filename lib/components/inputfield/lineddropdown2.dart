import 'package:afrikunet/components/text/textComponents.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          _showChooser(
            items: widget.items,
          );
        },
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
            TextBody1(
              text: "${selectVal ?? widget.label}",
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            const SizedBox(width: 4.0),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }

  _showChooser({var items}) {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: SingleChildScrollView(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 8.0,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => TextButton(
              onPressed: () {
                widget.onSelected(
                  items[index],
                );
                setState(() {
                  selectVal = items[index];
                });
                Get.back();
              },
              child: Text(
                '${items[index]}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: items.length,
          ),
        ),
      ),
    );
  }
}
