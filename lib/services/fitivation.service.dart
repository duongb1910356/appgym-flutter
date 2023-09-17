import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitivation_app/models/fitivation.model.dart';
import 'package:fitivation_app/models/schedule.model.dart';
import 'package:fitivation_app/shared/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fitivation_app/helper/dialog_helper.dart';
import 'package:fitivation_app/models/user.model.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:http/http.dart' as http;
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
}
