import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/text/textComponents.dart';
// import 'package:afrikunet/helper/constants/countries.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
// import 'package:afrikunet/data/countries/countries.dart';
// import 'package:afrikunet/helper/constants/constants.dart';
// import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/constants/countries.dart';

typedef void InitCallback(var value);
typedef void FilterCallback(var value);

class LinedDropdown4 extends StatefulWidget {
  final String title;
  var label;
  final InitCallback onSelected;
  final FilterCallback onFiltered;
  // final List<Map<String, dynamic>> items;
  var items;
  final bool isEnabled;

  LinedDropdown4({
    Key? key,
    required this.label,
    required this.title,
    required this.onSelected,
    required this.onFiltered,
    required this.items,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<LinedDropdown4> createState() => _LinedDropdownState();
}

class _LinedDropdownState extends State<LinedDropdown4> {
  var selectVal;
  final _searchController = TextEditingController();
  final _controller = Get.find<StateController>();

  @override
  void initState() {
    super.initState();
  }

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
      _controller.filteredCountries.value = _filtered;
    } else {
      _controller.filteredCountries.value = widget.items;
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
                        _controller.filteredCountries.value[index],
                      );
                      setState(() {
                        selectVal =
                            _controller.filteredCountries.value[index]['name'];
                      });
                      

                      // _controller.filteredStates.value = _filterer[0]['states'];
                      Get.back();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          "${_controller.filteredCountries.value[index]['logo']}",
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '${_controller.filteredCountries.value[index]['name']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: _controller.filteredCountries.value.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
