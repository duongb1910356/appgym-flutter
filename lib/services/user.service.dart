import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitivation_app/models/user.model.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:fitivation_app/shared/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class UserService {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/user";
  final API api = API();

  UserService();

  Future<User?> fetchUser(String username) async {
    try {
      String endpoint = '$baseUrl/$username';

      final Response response = await api.get(endpoint);

      final jsonData = response.data;

      return User.fromJson(jsonData);
    } catch (ex) {
      print("Error fetch user: ${ex}");
      return null;
    }
  }

  Future<User?> updateAvatarUser(String userId, File file) async {
    try {
      String endpoint = '$baseUrl/update/avatar/$userId';
      print("endpoint $endpoint");

      FormData formData = FormData.fromMap({
        'image':
            await MultipartFile.fromFile(file.path, filename: 'filename.jpg'),
      });

      final Response response =
          await api.patchWithFile(endpoint, body: formData);

      final jsonData = response.data;

      return User.fromJson(jsonData);
    } catch (ex) {
      print("Error update avatar of user: ${ex}");
      return null;
    }
  }

  Future<User?> updateUser(String userId, Map<String, dynamic> formData) async {
    try {
      String endpoint = '$baseUrl/update/$userId';
      print("endpoint $endpoint");

      final Response response =
          await api.patchWithFile(endpoint, body: formData);

      final jsonData = response.data;

      return User.fromJson(jsonData);
    } catch (ex) {
      print("Error update avatar of user: ${ex}");
      return null;
    }
  }
}
