import 'dart:convert';

import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import 'widgets/airtime-tab.dart';

class Airtime extends StatefulWidget {
  const Airtime({
    Key? key,
  }) : super(key: key);

  @override
  State<Airtime> createState() => _AirtimeState();
}

class _AirtimeState extends State<Airtime> {
  PreferenceManager? _manager;
  final _controller = Get.find<StateController>();

  _init() async {
    try {
      final _topupResponse = await APIService().getVTUCountries(type: '');
      debugPrint("INTERNATIONAL VTU PEOPLE ::: ${_topupResponse.body}");
      if (_topupResponse.statusCode >= 200 &&
          _topupResponse.statusCode <= 299) {
        Map<String, dynamic> map = jsonDecode(_topupResponse.body);
        _controller.internationVTUData.value = map['data'];
        _controller.internationVTUTopup.value = map['topup'];
        _controller.filteredVTUCountries.value = map['topup'];
      }
    } catch (e) {
      debugPrint("INIT VTU ERR ::: $e");
    }
  }

  @override
  void initState() {
    _manager = PreferenceManager(context);
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      CupertinoIcons.back,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                TextMedium(
                  text: "Airtime",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: AirtimeTab(
                manager: _manager!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
