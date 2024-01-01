import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(
          "assets/images/home_icon.svg",
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/images/bell_icon.svg",
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
