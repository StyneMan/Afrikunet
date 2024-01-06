import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:afrikunet/helper/constants/constants.dart';

typedef void InitCallback(String value);

class BankCustomDropdown extends StatefulWidget {
  final InitCallback onSelected;
  final double borderRadius;
  final String hint;
  final List<dynamic> items;
  var validator;
  BankCustomDropdown({
    Key? key,
    required this.items,
    required this.hint,
    this.borderRadius = 6.0,
    required this.onSelected,
    this.validator,
  }) : super(key: key);

  @override
  State<BankCustomDropdown> createState() => _BankCustomDropdownState();
}

class _BankCustomDropdownState extends State<BankCustomDropdown> {
  String _hint = "";
  var _bank;

  @override
  void initState() {
    super.initState();
    setState(() {
      _hint = widget.hint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(
        _hint,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 21.0,
          vertical: 8.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          borderSide: const BorderSide(
            color: Constants.strokeColor,
          ),
          gapPadding: 4.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          borderSide: const BorderSide(
            color: Constants.strokeColor,
          ),
          gapPadding: 4.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
          borderSide: const BorderSide(
            color: Constants.strokeColor,
          ),
          gapPadding: 4.0,
        ),
        filled: false,
        hintText: _hint,
        labelText: _hint,
        focusColor: Constants.accentColor,
        hintStyle: const TextStyle(
          fontFamily: "OpenSans",
          color: Colors.black38,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          fontFamily: "OpenSans",
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        // suffixIcon: endIcon,
      ),
      items: widget.items.map((e) {
        return DropdownMenuItem(
          value: e['name'],
          child: Text(
            e['name'],
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        );
      }).toList(),
      value: _bank,
      onChanged: (newValue) async {
        widget.onSelected(
          newValue as String,
        );
        setState(
          () {
            _bank = newValue;
          },
        );
      },
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      iconSize: 24,
      isExpanded: true,
    );
  }
}
