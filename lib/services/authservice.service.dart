import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitivation_app/helper/dialog_helper.dart';
import 'package:fitivation_app/models/user.model.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:fitivation_app/shared/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

class AuthService {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/auth";
  final API api = API();

  AuthService();

  Future<User?> signUp(BuildContext context, String username, String email,
      String password, String displayName, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'role': [role],
          'displayName': displayName
        }),
      );

      final jsonData = jsonDecode(response.body);

      // ignore: use_build_context_synchronously
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.login(jsonData);
      return User.fromJson(jsonData);
    } catch (ex) {
      // ignore: use_build_context_synchronously
      ErrorHandler.handleHttpError(context, ex);
      return null;
    }
  }

  Future<User?> signIn(
      String username, String password, BuildContext context) async {
    try {
      String endpoint = '$baseUrl/signin';

      Map<String, dynamic> body = {
        'username': username,
        'password': password,
      };

      final Response response = await api.post(endpoint, body);

      final jsonData = response.data;
      await api.saveToken(jsonData);
      print("da goi luu token");

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.login(jsonData);
      print('Success login: ${userProvider.user?.id}');

      return User.fromJson(jsonData);
    } catch (ex) {
      print("Error signin: ${ex}");
      return null;
    }
  }

  Future<bool> refreshAccesssTokenFromRefreshToken(String refreshToken) async {
    try {
      String endpoint = '$baseUrl/refreshtoken';

      final Response response =
          await api.post(endpoint, {refreshToken: refreshToken});
      final jsonData = response.data;
      await api.saveToken(jsonData);
      return true;
    } catch (ex) {
      print("Error refresh access token: ${ex}");
      return false;
    }
  }

  // Future<User?> login(
  //     String username, String password, BuildContext context) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/signin'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'username': username, 'password': password}),
  //     );

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);

  //       // ignore: use_build_context_synchronously
  //       final userProvider = Provider.of<UserProvider>(context, listen: false);
  //       userProvider.login(jsonData);
  //       print('Success login: ${userProvider.user?.id}');

  //       return User.fromJson(jsonData);
  //     } else {
  //       print("Error signin");
  //       return null;
  //     }
  //   } catch (ex) {
  //     // Xử lý lỗi kết nối
  //     print("Error signin: ${ex}");
  //     return null;
  //   }
  // }
}
