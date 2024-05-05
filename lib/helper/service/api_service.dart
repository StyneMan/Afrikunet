import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/interceptors/api_interceptors.dart';
import 'package:afrikunet/helper/interceptors/token_retry.dart';
import 'package:afrikunet/helper/state/state_manager.dart';

class APIService {
  final _controller = Get.find<StateController>();
  http.Client client = InterceptedClient.build(
    interceptors: [
      MyApiInterceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  APIService() {
    // init();
  }

  Future<http.Response> signup(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/auth/signup'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> login(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/auth/login'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> googleAuth(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/auth/google/login'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> googleAuthRedirect({var authHeaders}) async {
    return await http.get(
        Uri.parse('${Constants.baseURL}/auth/google/redirect'),
        headers: authHeaders,);
  }

  Future<http.Response> forgotPass(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/auth/send-password-reset'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> resetPass(Map body) async {
    return await http.put(
      Uri.parse('${Constants.baseURL}/auth/reset-password'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> verifyOTP(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/auth/verify'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> resendOTP(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/auth/resend-otp'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> getProfile(String accessToken) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/users/profile'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Future<http.Response> getHistory(String accessToken) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/history/user'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Future<http.Response> logout(String accessToken, String email) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/auth/logout/'),
      headers: {
        "Content-type": "application/json",
        // "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Future<http.Response> updateProfile(
      {var body, var accessToken, var id}) async {
    return await client.put(
      Uri.parse('${Constants.baseURL}/users/$id/update'),
      headers: {
        "Content-type": "application/json",
        // "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future getVTUs() async {
    return await http.get(
      Uri.parse('${Constants.baseURL}/vtu/all'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> initVtuRequest(String accessToken, Map body) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vtu/request/initiate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> initElectricityRequest(
      String accessToken, Map body) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vtu/request/electricity/initiate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> initCableTVRequest(String accessToken, Map body) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vtu/request/cable-tv/initiate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> getPlans(String serviceId) async {
    return await http.get(
      Uri.parse('${Constants.baseURL}/vtu/$serviceId/plans'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> initPayment(String accessToken, var encodedData) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vtu/request/payment/initiate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(encodedData),
    );
  }

  Future<http.Response> buyVoucher(String accessToken, var payload) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vouchers/purchase'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(payload),
    );
  }
}
