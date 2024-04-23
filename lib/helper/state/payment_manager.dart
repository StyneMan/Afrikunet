import 'dart:convert';

import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:afrikunet/screens/success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  final _controller = Get.find<StateController>();
  // var data = Get.arguments['data'];
  // var orderId = Get.arguments['order_id'];
  final DateTime pageStartTime = DateTime.now();

  late WebViewController webviewController;

  _initWebview() {
    webviewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (String url) {
            // Set loading here
            _controller.setLoading(true);
          },
          onPageFinished: (String url) {
            // Get.back();
            _controller.setLoading(false);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            final DateTime pageStartTime = DateTime.now();

            if (request.url
                .startsWith('https://afrikunet.com/mobile/success/buy')) {
              // User has paid. Now render his/her service here
              final payload = Get.arguments['payload'];
              final customerData = Get.arguments['customerData'];

              _initiatePurchase(
                payload: payload,
                customerData: customerData,
                accessToken: Get.arguments['accessToken'],
                manager: Get.arguments['manager'],
                selectedDataPlanName: Get.arguments['selectedDataPlanName'],
              );
            }

            if (request.url
                .startsWith('https://afrikunet.com/mobile/error/buy')) {
              Get.back();
              Duration durationOnPage =
                  DateTime.now().difference(pageStartTime);
            }

            return NavigationDecision.navigate;
          }))
      ..loadRequest(
        Uri.parse(
          kDebugMode
              ? 'https://test.afrikunet.com/mobile/buy?code=${Get.arguments['data']}'
              : 'https://afrikunet.com/mobile/buy?code=${Get.arguments['data']}',
        ),
      );
  }

  void _initiatePurchase({
    required var payload,
    required var customerData,
    required var accessToken,
    required var manager,
    required var selectedDataPlanName,
  }) async {
    if (payload['type'] == "electricity") {
      try {
        var updatedPayload = {
          "type": payload['type'],
          "name": payload['name'],
          "amount": payload['amount'],
          "phone": payload['phone'],
          "network_id": payload['network_id'],
          "product_type_id": payload['product_type_id'],
          "otherParams": {
            "variation_code": customerData['Meter_Type'],
            "billersCode": customerData['MeterNumber'],
          }
        };

        print('CUSTOMER ::: $customerData');
        print('PAYLOAD ::: $payload');
        print('ACCESS TOKEN ::: $accessToken');

        _controller.setLoading(true);
        final _response = await APIService()
            .initElectricityRequest(accessToken, updatedPayload);
        print("INIT REQUEST REPONSE :: ${_response.body}");
        _controller.setLoading(false);

        if (_response.statusCode >= 200 && _response.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(_response.body);
          Constants.toast(map['message']);

          Get.to(
            SuccessPage(
              isVoucher: false,
              manager: manager,
              message:
                  'You have successfully purchased electricity token worth ${payload['amount']} from ${payload['name']}',
            ),
            transition: Transition.cupertino,
          );
        } else {
          Map<String, dynamic> errMap = jsonDecode(_response.body);
          Constants.toast(errMap['message']);
        }
      } catch (e) {
        _controller.setLoading(false);
      }
    } else if (payload['type'] == "cable_tv") {
      try {
        var updatedPayload = {
          "type": payload['type'],
          "name": payload['name'],
          "amount": payload['amount'],
          "phone": payload['phone'],
          "network_id": payload['network_id'],
          "product_type_id": payload['product_type_id'],
          "otherParams": {
            "billersCode": payload['otherParams']['billersCode'],
            "subscription_type": "renew"
          }
        };

        _controller.setLoading(true);
        final _response = await APIService().initCableTVRequest(
          accessToken,
          updatedPayload,
        );
        print("INIT REQUEST REPONSE :: ${_response.body}");
        _controller.setLoading(false);

        if (_response.statusCode >= 200 && _response.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(_response.body);
          Constants.toast(map['message']);

          Get.to(
            SuccessPage(
              isVoucher: false,
              manager: manager,
              message:
                  'You have successfully renewed your ${payload['name']} cable subscription with ${payload['amount']}',
            ),
            transition: Transition.cupertino,
          );
        } else {
          Map<String, dynamic> errMap = jsonDecode(_response.body);
          Constants.toast(errMap['message']);
        }
      } catch (e) {
        _controller.setLoading(false);
      }
    } else if (payload['type'] == "airtime") {
      try {
        _controller.setLoading(true);

        final _response =
            await APIService().initVtuRequest(accessToken, payload);
        print("INIT REQUEST REPONSE :: ${_response.body}");
        _controller.setLoading(false);

        if (_response.statusCode >= 200 && _response.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(_response.body);
          Constants.toast('${map['message']}');

          _controller.onInit();

          if ('${map['message']}'.toLowerCase().contains('success')) {
            Get.to(
              SuccessPage(
                isVoucher: false,
                manager: manager,
                message:
                    'You have successfully purchased ${payload['name']} airtime worth of ${payload['amount']} for ${payload['phone']}',
              ),
              transition: Transition.cupertino,
            );
          }
        }
      } catch (e) {
        _controller.setLoading(false);
      }
    } else if (payload['type'] == "data") {
      try {
        _controller.setLoading(true);

        final _response =
            await APIService().initVtuRequest(accessToken, payload);
        print("DATA REQUEST REPONSE :: ${_response.body}");
        _controller.setLoading(false);

        if (_response.statusCode >= 200 && _response.statusCode <= 299) {
          Map<String, dynamic> map = jsonDecode(_response.body);
          Constants.toast('${map['message']}');

          _controller.onInit();

          if ('${map['message']}'.toLowerCase().contains('success')) {
            Get.to(
              SuccessPage(
                isVoucher: false,
                manager: manager,
                message:
                    'You have successfully purchased $selectedDataPlanName for ${payload['phone']}',
              ),
              transition: Transition.cupertino,
            );
          }
        } else {
          Map<String, dynamic> errMap = jsonDecode(_response.body);
          Constants.toast('${errMap['message']}');
        }
      } catch (e) {
        _controller.setLoading(false);
      }
    }
  }

  @override
  void onInit() {
    _initWebview();
    Duration durationOnPage = DateTime.now().difference(pageStartTime);
    super.onInit();
  }

  @override
  void onClose() {
    Duration durationOnPage = DateTime.now().difference(pageStartTime);
    super.onClose();
  }
}
