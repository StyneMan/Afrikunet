import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:afrikunet/helper/constants/constants.dart';

typedef void InitCallback(var item);

class BankCountriesCustomDropdown extends StatefulWidget {
  final InitCallback onSelected;
  final double borderRadius;
  final String hint;
  final List<dynamic> items;
  var validator;
  var value;
  BankCountriesCustomDropdown({
    Key? key,
    required this.items,
    required this.hint,
    this.borderRadius = 6.0,
    required this.onSelected,
    this.validator,
    required this.value,
  }) : super(key: key);

  @override
  State<BankCountriesCustomDropdown> createState() =>
      _BankCountriesCustomDropdownState();
}

class _BankCountriesCustomDropdownState
    extends State<BankCountriesCustomDropdown> {
  String _hint = "";
  var _country;

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
      hint: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: '${widget.value['logo']}',
            width: 24,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              return Image.asset(
                'assets/images/logo_blue.png',
                width: 24,
                height: 24,
              );
            },
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(
            '${widget.value['name']}',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
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
          value: e,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                '${e['logo']}',
                width: 24,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/logo_blue.png',
                    width: 24,
                    height: 24,
                  );
                },
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                e['name'],
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      // value: widget.value,
      onChanged: (newValue) async {
        widget.onSelected(
          newValue,
        );
        setState(
          () {
            _country = newValue;
            widget.value = newValue;
          },
        );
      },
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      iconSize: 24,
      isExpanded: true,
    );
  }
}
