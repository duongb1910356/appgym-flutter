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
}
