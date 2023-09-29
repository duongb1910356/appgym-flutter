import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitivation_app/models/dto/create_facility.dto.dart';
import 'package:fitivation_app/models/fitivation.model.dart';
import 'package:fitivation_app/models/schedule.model.dart';
import 'package:fitivation_app/shared/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fitivation_app/helper/dialog_helper.dart';
import 'package:fitivation_app/models/user.model.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FitivationService {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/facility";
  final API api = API();

  FitivationService();

  Future<Schedule?> getScheduleByFacilityId(String facilityId) async {
    try {
      String endpoint =
          "${dotenv.env['BASE_URL']}/api/schedule/get/facility/$facilityId";
      Schedule? schedule;
      final Response response = await api.get(endpoint);
      final jsonData = response.data;
      if (jsonData != null) {
        schedule = Schedule.fromJson(jsonData);
      }

      return schedule;
    } catch (ex) {
      print('Error get schedule by facilityId: ${ex}');
      return null;
    }
  }

  Future<Fitivation?> getFitivationById(String id) async {
    try {
      String endpoint = '$baseUrl/$id';
      Fitivation? facility;
      final Response response = await api.get(endpoint);
      final jsonData = response.data;

      if (jsonData != null) {
        facility = Fitivation.fromJson(jsonData);
      }
      return facility;
    } catch (ex) {
      print('Error get facility by id: ${ex}');
      return null;
    }
  }

  Future<List<Fitivation>?> getFacilitiesByOwnerId(String id) async {
    try {
      String endpoint = '$baseUrl/owner/$id';
      print("url getFacilitiesByOwnerId $endpoint");
      List<Fitivation>? facilities;
      final Response response = await api.get(endpoint);
      final jsonData = response.data;

      if (jsonData != null) {
        final List<dynamic> facilityJsonList = jsonData;
        facilities =
            facilityJsonList.map((item) => Fitivation.fromJson(item)).toList();
      }
      print("da goi xong url getFacilitiesByOwnerId $endpoint");

      return facilities;
    } catch (ex) {
      print('Error get facilities by owner id: ${ex}');
      return null;
    }
  }

  Future<List<Fitivation>?> getNearByFacilities(
      BuildContext context, double longtitude, double latitude) async {
    try {
      String endpoint = '$baseUrl/get_nearby_facilities';
      List<Fitivation> fitivations = [];
      Map<String, dynamic> queryParam = {
        "longtitude": longtitude,
        "latitude": latitude
      };

      final Response response =
          await api.get(endpoint, queryParameters: queryParam);
      final jsonData = response.data;
      // print("da goi xong respone near ${jsonData["items"]}");

      if (jsonData != null) {
        final List<dynamic> facilityJsonList = jsonData['items'];
        fitivations =
            facilityJsonList.map((item) => Fitivation.fromJson(item)).toList();
        // print(fitivations[0].address?.province);
      }

      return fitivations;
    } catch (ex) {
      print('Error getNearByFacilities ${ex}');
      // ignore: use_build_context_synchronously
      ErrorHandler.handleHttpError(context, ex);
      return null;
    }
  }

  Future<Fitivation?> createFacility(
      Map<String, dynamic> createFacilityDto) async {
    try {
      String endpoint = '$baseUrl/create';
      Fitivation? fitivation;

      final Response response =
          await api.post(endpoint, body: createFacilityDto);
      final jsonData = response.data;

      if (jsonData != null) {
        fitivation = Fitivation.fromJson(jsonData);
      }

      print("da goi xong $endpoint");

      return fitivation;
    } catch (ex) {
      print('Error createFacility ${ex}');
      // ignore: use_build_context_synchronously
      return null;
    }
  }

  Future<dynamic> uploadImagesFacility(
      String facilityId, List<XFile> images) async {
    try {
      String endpoint = '${dotenv.env['BASE_URL']}/api/file/upload_bulk';
      print("endpoint uploadImagesFacility $endpoint");
      List<MultipartFile> imageFiles = [];

      for (int i = 0; i < images.length; i++) {
        String imagePath = images[i].path;
        File imageFile = File(imagePath);

        MultipartFile imageMultipartFile = await MultipartFile.fromFile(
          imageFile.path,
          filename: 'image_$i.jpg',
        );

        imageFiles.add(imageMultipartFile);
      }

      FormData formData =
          FormData.fromMap({"images": imageFiles, "facilityId": facilityId});

      final Response response =
          await api.patchWithFile(endpoint, body: formData);
      final jsonData = response.data;

      return jsonData;
    } catch (ex) {
      print('Error uploadImagesFacility ${ex}');
      // ignore: use_build_context_synchronously
      return null;
    }
  }
}
