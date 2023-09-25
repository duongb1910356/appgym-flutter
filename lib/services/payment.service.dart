import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitivation_app/shared/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentService {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/payment";
  final API api = API();

  PaymentService();

  Future<dynamic> createPaymentIntentService(
      int amount, String currency, String customerId) async {
    try {
      String endpoint = '$baseUrl/create_payment_intent';
      print("endpoint $endpoint customerId: $customerId");
      final Response response = await api.post(endpoint, requestParams: {
        'amount': 10000,
        'currency': currency,
        'customerId': customerId
      });
      final jsonData = response.data;
      return jsonData;
    } catch (ex) {
      print('Error create payment intent: ${ex}');
      return null;
    }
  }

  Future<String?> getEphemeralKey(String customerId) async {
    try {
      String endpoint = '$baseUrl/create_ephemeral_key';
      print("endpoint $endpoint customerId: $customerId");
      final Response response =
          await api.post(endpoint, requestParams: {'customerId': customerId});
      final jsonData = response.data;
      return jsonData;
    } catch (ex) {
      print('Error create payment intent: ${ex}');
      return null;
    }
  }

  Future<dynamic> createCustomerStripe() async {
    try {
      String endpoint = '$baseUrl/create_customer';
      print("endpoint $endpoint");
      final Response response = await api.post(endpoint);
      final jsonData = response.data;
      print("jsonData of customer: >> $jsonData");

      return jsonData;
    } catch (ex) {
      print('Error create customer stripe: ${ex}');
      return null;
    }
  }
}
