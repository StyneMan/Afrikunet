import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final _searchController = TextEditingController();
  final _controller = Get.find<StateController>();

  _filter(String keyword) {
    print("FILTERING  ::: ${keyword}");
    if (keyword.isNotEmpty) {
      final _filtered = widget.items
          .where(
            (element) => element['name'].toString().toLowerCase().contains(
                  keyword.toLowerCase(),
                ),
          )
          .toList();

      print("FILTERED LIST  ::: ${_filtered}");
      _controller.filteredStates.value = _filtered;
    } else {
      _controller.filteredStates.value = widget.items;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          _showChooser();
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
              text: "$selectVal",
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

  _showChooser() {
    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            CustomTextField(
              onChanged: (e) {
                _filter(e);
              },
              prefix: const Icon(CupertinoIcons.search),
              controller: _searchController,
              validator: (value) {},
              inputType: TextInputType.text,
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  itemBuilder: (context, index) => TextButton(
                    onPressed: () {
                      widget.onSelected(
                        _controller.filteredStates.value[index],
                      );
                      setState(() {
                        selectVal =
                            _controller.filteredStates.value[index]['name'];
                      });
                      Get.back();
                    },
                    child: Text(
                      '${_controller.filteredStates.value[index]['name']}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: _controller.filteredStates.value.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
