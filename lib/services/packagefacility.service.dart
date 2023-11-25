import 'package:dio/dio.dart';
import 'package:fitivation_app/models/package.model.dart';
import 'package:fitivation_app/shared/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PackageService {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/package_facility";
  final API api = API();

  PackageService();

  Future<List<PackageFacility>?> getPackageOfFacilityId(
      String facilityId) async {
    try {
      String endpoint = '$baseUrl/facility/$facilityId';
      List<PackageFacility>? list = [];
      final Response response = await api.get(endpoint);
      final jsonData = response.data;

      if (jsonData != null) {
        final List<dynamic> tempList = jsonData;
        list = tempList.map((item) => PackageFacility.fromJson(item)).toList();
      }

      return list;
    } catch (ex) {
      print('Error get package ${ex}');
      return null;
    }
  }

  Future<void> createPackage(String packageName, int basePrice, String discount,
      String facilityId) async {
    try {
      String endpoint = '$baseUrl/create';
      List<PackageFacility>? list = [];
      Map<String, double> discountMap = {};

      List<String> parts = discount.split(",");
      for (String part in parts) {
        List<String> keyValue = part.trim().split(" - ");
        if (keyValue.length == 2) {
          String key = keyValue[0];
          double value = double.tryParse(keyValue[1]) ?? 0.0;
          discountMap[key] = value;
        }
      }

      Map<String, dynamic> formData = {
        "name": packageName,
        "basePrice": basePrice,
        "facilityId": facilityId,
        "discount": discountMap
      };

      print("formData create package $formData");

      final Response response = await api.post(endpoint, body: formData);
      final jsonData = response.data;

      // if (jsonData != null) {
      //   final List<dynamic> tempList = jsonData;
      //   list = tempList.map((item) => PackageFacility.fromJson(item)).toList();
      // }

      // return list;
    } catch (ex) {
      print('Error create package ${ex}');
      return null;
    }
  }
}
