import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/helper/state/theme_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _controller = Get.find<StateController>();
  String _currentMode = "light";
  bool _enableEmailNotification = false;
  bool _enablePushNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
              child: InkWell(
                onTap: () {
                  _controller.selectedIndex.value = 0;
                },
                child: Icon(
                  CupertinoIcons.back,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            TextMedium(
              text: "Settings",
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 8.0),
          TextSmall(
            text: "Appearance",
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _currentMode = "light";
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextSmall(
                        text: "Light",
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      Radio(
                        activeColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        value: "light",
                        groupValue: _currentMode,
                        onChanged: (value) {
                          setState(() {
                            _currentMode = "light";
                          });
                        },
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _currentMode = "light";
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextSmall(
                        text: "Dark",
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      Radio(
                        activeColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        value: "dark",
                        groupValue: _currentMode,
                        onChanged: (value) {
                          setState(() {
                            _currentMode = "dark";
                          });
                        },
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _currentMode = "dark";
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextSmall(
                        text: "System Default",
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      Radio(
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: "system default",
                        groupValue: _currentMode,
                        onChanged: (value) {
                          setState(() {
                            _currentMode = "system default";
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            color: Theme.of(context).colorScheme.background.withOpacity(0.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: SvgPicture.asset(
                            "assets/images/carbon_email.svg",
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        TextSmall(
                          text: "Email Notification",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    ),
                    CupertinoSwitch(
                      value: _enableEmailNotification,
                      onChanged: (value) {
                        setState(
                          () => _enableEmailNotification =
                              !_enableEmailNotification,
                        );
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: SvgPicture.asset(
                            "assets/images/carbon_bell.svg",
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        TextSmall(
                          text: "Push Notification",
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    ),
                    CupertinoSwitch(
                      value: _enablePushNotification,
                      onChanged: (value) {
                        setState(
                          () => _enablePushNotification =
                              !_enablePushNotification,
                        );
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.background.withOpacity(0.4),
            child: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextSmall(
                    text: "Language",
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.tertiary,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
