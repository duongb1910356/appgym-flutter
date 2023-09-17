import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitivation_app/models/cart.model.dart';
import 'package:fitivation_app/shared/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CartService {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/cart";
  final API api = API();

  CartService();

  Future<bool> addPackageToCart(String packageId) async {
    try {
      String endpoint = '$baseUrl/add_item';
      print("endpoint $endpoint");
      final Response response =
          await api.patch(endpoint, {"packageId": packageId, "quantity": 1});
      final jsonData = response.data;
      if (jsonData != null) {
        return true;
      }
      return false;
    } catch (ex) {
      print('Error add package to cart: ${ex}');
      return false;
    }
  }

  Future<Cart?> getCartOfMe() async {
    try {
      String endpoint = '$baseUrl/me';
      Cart? cart;
      final Response response = await api.get(endpoint);
      final jsonData = response.data;
      if (jsonData != null) {
        cart = Cart.fromJson(jsonData);
      }
      return cart;
    } catch (ex) {
      print('Error get cart: ${ex}');
      return null;
    }
  }
}
