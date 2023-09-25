import 'package:dio/dio.dart';
import 'package:fitivation_app/models/bill.model.dart';
import 'package:fitivation_app/shared/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BillService {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/bill";
  final API api = API();

  BillService();

  Future<List<Bill>?> getBillsOfMe() async {
    try {
      String endpoint = '$baseUrl/me';
      List<Bill>? bills = [];

      print("endpoint bill $endpoint");
      final Response response = await api.get(endpoint);
      final jsonData = response.data;

      if (jsonData != null) {
        final List<dynamic> tempList = jsonData;
        bills = tempList.map((item) => Bill.fromJson(item)).toList();
      }

      return bills;
    } catch (ex) {
      print('Error get bills of me: ${ex}');
      return null;
    }
  }
}
