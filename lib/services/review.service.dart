import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitivation_app/models/review.model.dart';
import 'package:fitivation_app/shared/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReviewService {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/review";
  final API api = API();

  ReviewService();

  Future<dynamic> getReviewSummary(String facilityId) async {
    try {
      String endpoint = '$baseUrl/facility/summary/$facilityId';
      final Response response = await api.get(endpoint);
      final jsonData = response.data;
      return jsonData;
    } catch (ex) {
      print("Error get reviewsummary: ${ex}");
      return null;
    }
  }

  Future<List<Review>?> getReviewByFacilityId(String facilityId) async {
    try {
      String endpoint = '$baseUrl/facility/$facilityId';
      List<Review>? list = [];
      final Response response = await api.get(endpoint);
      final jsonData = response.data;

      if (jsonData != null) {
        final List<dynamic> tempList = jsonData['items'];
        list = tempList.map((item) => Review.fromJson(item)).toList();
      }

      return list;
    } catch (ex) {
      print("Error get reviews: ${ex}");
      return null;
    }
  }
}
